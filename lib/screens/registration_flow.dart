import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'register_confidentiality_sheet.dart';
import 'register_contacts_sheet.dart';
import 'register_code_sheet.dart';
import 'register_role_sheet.dart';

import 'package:mama_kris/constants/api_constants.dart';
import 'monetization_screen.dart';
import 'monetization_banner_screen.dart';

/// Универсальная функция для показа SnackBar и дублирования сообщения в терминал.
void showSnack(BuildContext context, String message) {
  // print(message);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Функция отправки кода подтверждения на email.
/// Если запрос успешен (201), возвращает true, иначе – false.
Future<bool> sendVerificationCodeFunction(
  BuildContext context,
  String email,
) async {
  if (email.isEmpty) {
    showSnack(context, 'Пожалуйста, введите email');
    return false;
  }
  try {
    final response = await http.post(
      Uri.parse('${kBaseUrl}auth/check-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 201) {
      showSnack(context, 'Код верификации отправлен на ваш email');
      return true;
    } else if (response.statusCode == 409) {
      showSnack(context, 'Этот email уже используется');
      return false;
    } else {
      showSnack(context, 'Произошла ошибка. Пожалуйста, попробуйте снова');
      return false;
    }
  } catch (e) {
    showSnack(
      context,
      'sendVerificationCodeFunction: Ошибка соединения. Пожалуйста, проверьте подключение к интернету',
    );
    return false;
  }
}

/// Функция проверки кода верификации.
/// Если код корректный (201), возвращает токен, иначе – null.
Future<String?> verifyCodeFunction(
  BuildContext context,
  String email,
  String codeText,
) async {
  if (codeText.isEmpty) {
    showSnack(context, 'Пожалуйста, введите код верификации');
    return null;
  }
  try {
    final response = await http.post(
      Uri.parse('${kBaseUrl}auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'verificationCode': int.parse(codeText),
      }),
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['token'];
    } else {
      showSnack(context, 'Неверный код верификации');
      return null;
    }
  } catch (e) {
    showSnack(
      context,
      'verifyCodeFunction: Ошибка соединения. Пожалуйста, проверьте подключение к интернету',
    );
    return null;
  }
}

/// Функция регистрации.
/// После успешной верификации отправляет на сервер email, displayName и password.
/// При успешной регистрации сохраняет токены и возвращает true, иначе – false.
Future<bool> registerFunction(
  BuildContext context,
  String verificationToken,
  String email,
  String displayName,
  String password,
  String phone,
) async {
  try {
    final url = Uri.parse('${kBaseUrl}auth/register');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $verificationToken',
    };
    final body = jsonEncode({
      'email': email,
      'password': password,
      'phone': phone,
      'name': displayName,
    });

    // print("📤 Отправка запроса на регистрацию:");
    // print("➡️ URL: $url");
    // print("➡️ Headers: $headers");
    // print("➡️ Body: $body");

    final response = await http.post(url, headers: headers, body: body);

    // print("📥 Ответ от сервера:");
    // print("➡️ Status: ${response.statusCode}");
    // print("➡️ Body: ${response.body}");

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('auth_token', responseData['accessToken']);
      await prefs.setString('refresh_token', responseData['refreshToken']);
      await prefs.setInt('user_id', responseData['userId']);
      await prefs.setBool('isLogged', true);
      await prefs.setString('current_page', 'choice');
      await prefs.setInt('viewed_count', 0);
      await prefs.setInt('liked_count', 0);

      // 🧠 Обновляем профиль из API
      await funcs.updateUserDataInCache(
        responseData['accessToken'],
        responseData['userId'],
      );
      await funcs.startSession(
        responseData['userId'],
        responseData['accessToken'],
      );

      // print("✅ Регистрация прошла успешно");
      return true;
    } else {
      showSnack(
        context,
        'Ошибка при регистрации. Пожалуйста, попробуйте снова',
      );
      return false;
    }
  } catch (e) {
    // print("🚨 Исключение при регистрации: $e");
    showSnack(
      context,
      'registerFunction: Ошибка соединения. Проверьте интернет',
    );
    return false;
  }
}

/// Функция отправки запроса на обновление выбора пользователя (роль).
Future<http.Response> _makeApiRequest(
  String choice,
  String? accessToken,
  int userId,
) async {
  final url = '${kBaseUrl}users/$userId/update-info';
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'choice': choice});
  return await http.put(Uri.parse(url), headers: headers, body: body);
}

/// Функция обработки выбора роли.
/// После успешного обновления данных на сервере выполняется навигация с использованием текущей логики.
Future<void> _navigateToChoice(
  String choice,
  SharedPreferences prefs,
  BuildContext context,
) async {
  // Определяем целевую страницу и значение для current_page по выбору пользователя.
  // final Widget targetPage =
  //     (choice == 'Looking for job') ? ApplicationScreen() : OrderScreen();
  final Widget targetPage = (choice == 'Looking for job')
      ? const MonetizationScreen()
      : const MonetizationBannerScreen();
  final String currentPage = (choice == 'Looking for job') ? 'search' : 'job';

  // Сохраняем данные в кэш
  await prefs.setString('current_page', currentPage);

  // Навигация с использованием PageRouteBuilder
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        );
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

Future<void> updateChoice(String choice, BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    if (userId == null) {
      throw Exception('User ID not found');
    }
    final response = await _makeApiRequest(choice, accessToken, userId);
    if (response.statusCode == 401) {
      final refreshSuccess = await funcs.refreshAccessToken();
      if (refreshSuccess) {
        accessToken = prefs.getString('auth_token');
        final retryResponse = await _makeApiRequest(
          choice,
          accessToken,
          userId,
        );
        if (retryResponse.statusCode == 200) {
          await _navigateToChoice(choice, prefs, context);
        } else {
          showSnack(context, 'Ошибка обновления данных');
        }
      } else {
        showSnack(context, 'Ошибка аутентификации');
      }
    } else if (response.statusCode == 200) {
      await _navigateToChoice(choice, prefs, context);
    } else {
      showSnack(context, 'Ошибка обновления данных');
    }
  } catch (e) {
    showSnack(context, 'Ошибка сети или сервера');
  }
}

class RegistrationFlow extends StatefulWidget {
  final double scaleX;
  final double scaleY;

  const RegistrationFlow({super.key, required this.scaleX, required this.scaleY});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow> {
  int currentStep =
      0; // 0 – конфиденциальность, 1 – контакты, 2 – код, 3 – выбор роли
  final int totalSteps = 4;

  // Сохранение данных, введённых на шаге 1
  String _userEmail = '';
  String _displayName = '';
  String _password = '';
  String _phone = '';
  void _nextStep() {
    setState(() {
      if (currentStep < totalSteps - 1) {
        currentStep++;
      }
    });
  }

  /// Обработка данных с ContactsPanel.
  /// Если отправка кода проходит успешно, сохраняем данные и переходим к следующему шагу.
  Future<void> _handleRegistrationDetails(
    String email,
    String displayName,
    String password,
    String phone,
  ) async {
    bool sent = await sendVerificationCodeFunction(context, email);
    if (sent) {
      _userEmail = email;
      _displayName = displayName;
      _password = password;
      _phone = phone;
      _nextStep();
    }
  }

  /// Обработка верификации кода.
  /// Если код верный, вызывается функция регистрации, и при успехе – переход к следующему шагу.
  Future<void> _handleVerification(String token) async {
    bool registered = await registerFunction(
      context,
      token,
      _userEmail,
      _displayName,
      _password,
      _phone,
    );
    if (registered) {
      _nextStep();
    }
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return ConfidentialityPanel(
          key: ValueKey(currentStep),
          scaleX: widget.scaleX,
          scaleY: widget.scaleY,
          onNext: _nextStep,
        );
      case 1:
        return ContactsPanel(
          key: ValueKey(currentStep),
          scaleX: widget.scaleX,
          scaleY: widget.scaleY,
          onNext:
              _handleRegistrationDetails, // Передаёт email, displayName и password
        );
      case 2:
        return CodePanel(
          key: ValueKey(currentStep),
          scaleX: widget.scaleX,
          scaleY: widget.scaleY,
          email: _userEmail,
          onNext: _handleVerification, // Передаёт полученный token
        );
      case 3:
        return RoleSelectionPanel(
          key: ValueKey(currentStep),
          scaleX: widget.scaleX,
          scaleY: widget.scaleY,
          onExecutorPressed: () {
            // Для исполнителя отправляем выбор "Looking for job"
            updateChoice('Looking for job', context);
          },
          onEmployerPressed: () {
            // Для заказчика отправляем выбор "Have vacancies"
            updateChoice('Have vacancies', context);
          },
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Прогресс-бар: ширина меняется от 80 до 396 по шагам
    List<double> progressWidths = [
      80 * widget.scaleX, // для ConfidentialityPanel
      160 * widget.scaleX, // для ContactsPanel
      240 * widget.scaleX, // для CodePanel
      396 * widget.scaleX, // для RoleSelectionPanel
    ];
    double progressWidth = progressWidths[currentStep];

    return Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final int childStep = (child.key as ValueKey<int>).value;
              if (childStep == currentStep) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0), // новый элемент выезжает справа
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              } else {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0), // старый элемент уезжает влево
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }
            },
            child: _buildStep(),
          ),
        ),
        // Прогресс-бар в левом нижнем углу панели
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 0 * widget.scaleX,
              bottom: 0 * widget.scaleY,
            ),
            child: Container(
              width: progressWidth,
              height: 10 * widget.scaleY,
              color: const Color(0xFF00A80E),
            ),
          ),
        ),
      ],
    );
  }
}
