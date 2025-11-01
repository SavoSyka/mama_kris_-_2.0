import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/welcome_screen.dart';
import 'package:mama_kris/screens/application_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'dart:convert';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/screens/pass_reset_manager.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/screens/subscribtion_info_screen.dart';

Future<void> onExitPressed(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? accessToken = prefs.getString('auth_token');
    if (userId != null && accessToken != null) {
      await funcs.endSession(userId, accessToken);
    }
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    await prefs.remove('email');
    await prefs.remove('isLoggedIn');
    await prefs.remove('isLogged');

    await prefs.remove('saved_jobs');
    await prefs.remove('saved_reduced_jobs');
    // await prefs.remove('current_page');

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, secondaryAnimation) =>
            const WelcomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
      (route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ошибка при выходе из аккаунта')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onEditProfilePressed(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ApplicationScreen(),
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
    // print("Редактировать анкету");
  }

  Future<void> _onChangeRolePressed(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? accessToken = prefs.getString('auth_token');

    if (userId == null || accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка: пользователь не найден")),
      );
      return;
    }

    // Запрашиваем данные пользователя для получения текущей роли (choice)
    final userResponse = await http.get(
      Uri.parse('${kBaseUrl}users/$userId'),
      headers: {'Authorization': 'Bearer $accessToken', 'accept': '*/*'},
    );

    if (userResponse.statusCode == 200) {
      final data = jsonDecode(userResponse.body);
      String currentChoice = data['choice'] ?? "";
      // Переключаем роль: если текущая "Looking for job" — ставим "Have vacancies", иначе наоборот.
      String newChoice;
      if (currentChoice == "Looking for job") {
        newChoice = "Have vacancies";
      } else if (currentChoice == "Have vacancies") {
        newChoice = "Looking for job";
      } else {
        newChoice = "Looking for job"; // значение по умолчанию
      }

      final putResponse = await http.put(
        Uri.parse('${kBaseUrl}users/$userId/update-info'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'choice': newChoice}),
      );

      if (putResponse.statusCode == 401) {
        final refreshSuccess = await funcs.refreshAccessToken();
        if (refreshSuccess) {
          accessToken = (await SharedPreferences.getInstance()).getString(
            'auth_token',
          );
          if (accessToken == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ошибка: новый токен не получен")),
            );
            return;
          }
          final retryResponse = await http.put(
            Uri.parse('${kBaseUrl}users/$userId/update-info'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'choice': newChoice}),
          );
          if (retryResponse.statusCode == 200) {
            await prefs.setString(
              'current_page',
              newChoice == "Looking for job" ? 'search' : 'job',
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                      showChangeDialog: newChoice == "Have vacancies")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ошибка обновления данных")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ошибка аутентификации")),
          );
        }
      } else if (putResponse.statusCode == 200) {
        await prefs.setString(
          'current_page',
          newChoice == "Looking for job" ? 'search' : 'job',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainScreen(showChangeDialog: newChoice == "Have vacancies")),
        );
        // await showChangeAlert(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка обновления данных")),
        );
      }
    } else if (userResponse.statusCode == 401) {
      final refreshSuccess = await funcs.refreshAccessToken();
      if (refreshSuccess) {
        _onChangeRolePressed(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Ошибка аутентификации")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка получения данных пользователя")),
      );
    }
  }

  Future<void> onResetPressed({
    required BuildContext context,
    required void Function() onSuccess,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    String? email = prefs.getString('email');

    if (accessToken == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: отсутствуют данные авторизации')),
      );
      return;
    }

    // Обновим email из API, если его нет в кэше
    if (email == null || email.isEmpty) {
      await funcs.updateUserDataInCache(accessToken, userId);
      email = prefs.getString('email');
    }

    // Если после обновления email всё ещё нет — ошибка
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось получить email пользователя')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${kBaseUrl}auth/reset-password-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      // print(response.body);
      if (response.statusCode == 201) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Код для сброса пароля отправлен на $email')),
        // );
        onSuccess();
      } else if (response.statusCode == 401) {
        // Попробуем обновить accessToken
        bool refreshed = await funcs.refreshAccessToken();
        if (refreshed) {
          accessToken = prefs.getString('auth_token');
          if (accessToken != null) {
            return await onResetPressed(context: context, onSuccess: onSuccess);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сессия устарела. Повторите попытку позже.'),
          ),
        );
      } else {
        throw Exception('Ошибка отправки запроса на сброс пароля');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отправке запроса: $error')),
      );
    }
  }

  void _onSubscriptionPressed(BuildContext context) {
    // print("Управление подпиской");
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, secondaryAnimation) =>
            const SubscribtionInfoScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _onDeleteAccountPressed(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('auth_token');
      int? userId = prefs.getInt('user_id');

      // print('🔐 Текущий userId: $userId');
      // print('🔐 Текущий accessToken: $accessToken');

      if (userId != null && accessToken != null) {
        // print('📤 Завершаем сессию на сервере...');
        await funcs.endSession(userId, accessToken);
      }

      if (accessToken == null || userId == null) {
        // print('❌ Ошибка: Пользователь не аутентифицирован');
        throw Exception('User not authenticated');
      }

      // print('🗑 Отправка запроса на удаление аккаунта...');
      final response = await http.delete(
        Uri.parse('${kBaseUrl}users/$userId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': '*/*',
        },
      );

      // print('📨 Ответ от сервера:');
      // print('↪️ Статус: ${response.statusCode}');
      // print('↪️ Тело: ${response.body}');

      if (response.statusCode == 200) {
        // print('✅ Аккаунт успешно удалён. Очищаем локальные данные...');
        await prefs.clear();
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, animation, secondaryAnimation) =>
                const WelcomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Аккаунт успешно удален')),
        );
      } else if (response.statusCode == 401) {
        // print('⚠️ Токен истёк. Пробуем обновить...');
        bool refreshed = await funcs.refreshAccessToken();
        if (refreshed) {
          // print('🔄 Токен обновлён. Повторяем удаление...');
          return _onDeleteAccountPressed(context);
        } else {
          // print('❌ Не удалось обновить токен');
          throw Exception('Failed to refresh token');
        }
      } else {
        // print('❌ Не удалось удалить аккаунт. Статус: ${response.statusCode}');
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      // print('🚨 Ошибка при удалении аккаунта: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении аккаунта: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    Widget buildActionButton({
      required String title,
      required String subtitle,
      required VoidCallback onPressed,
      required double top,
    }) {
      return Positioned(
        top: top * scaleY,
        left: 32 * scaleX,
        child: Container(
          width: 364 * scaleX,
          height: 91 * scaleY,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0x78E7E7E7),
                offset: Offset(0, 4 * scaleY),
                blurRadius: 19 * scaleX,
              ),
            ],
            borderRadius: BorderRadius.circular(15 * scaleX),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 16 * scaleY,
                horizontal: 20 * scaleX,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w600,
                          fontSize: 18 * scaleX,
                          height: 28 / 18,
                          letterSpacing: -0.18 * scaleX,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          letterSpacing: -0.1 * scaleX,
                          color: const Color(0xFF596574),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10 * scaleX),
                SvgPicture.asset(
                  'assets/welcome_screen/arrow_green.svg',
                  width: 32 * scaleX,
                  height: 32 * scaleY,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Зеленый блюр
          Positioned(
            top: 108 * scaleY,
            left: 0,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                width: 428 * scaleX,
                height: 195 * scaleY,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFFFD1).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20 * scaleX),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20 * scaleX),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 83, sigmaY: 83),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
          // Заголовок
          Positioned(
            top: 75 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/profile/title.svg',
              width: 213 * scaleX,
              height: 28 * scaleY,
            ),
          ),
          // Иконка выхода
          Positioned(
            top: 78 * scaleY,
            left: 391 * scaleX,
            child: GestureDetector(
              onTap: () => onExitPressed(context),
              child: SvgPicture.asset(
                'assets/profile/exit.svg',
                width: 21 * scaleX,
                height: 21 * scaleY,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Имя
          Positioned(
            top: 136 * scaleY,
            left: 0,
            right: 0,
            child: FutureBuilder<String>(
              future: funcs.resolveDisplayName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Center(
                  child: Text(
                    snapshot.data ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w700,
                      fontSize: 24 * scaleX,
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          // Email
          // Email
          Positioned(
            top: 171 * scaleY,
            left: 0,
            right: 0,
            child: FutureBuilder<String>(
              future: funcs.resolveEmail(), // функция, возвращающая email
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Center(
                  child: Text(
                    snapshot.data ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          // Кнопки
          buildActionButton(
            title: 'Редактировать анкету',
            subtitle: 'Персональная информация',
            onPressed: () => _onEditProfilePressed(context),
            top: 271 * scaleY,
          ),
          buildActionButton(
            title: 'Сменить роль',
            subtitle: 'Станьте исполнителем или соискателем',
            onPressed: () => _onChangeRolePressed(context),
            top: 392 * scaleY,
          ),
          buildActionButton(
            title: 'Сбросить пароль',
            subtitle: 'Создайте новый пароль',
            onPressed: () => onResetPressed(
              context: context,
              onSuccess: () {
                showPassResetFlow(context);
              },
            ),
            top: 513 * scaleY,
          ),
          buildActionButton(
            title: 'Управление подпиской',
            subtitle: 'Выберите подходящий для вас тариф',
            onPressed: () => _onSubscriptionPressed(context),
            top: 634 * scaleY,
          ),
          buildActionButton(
            title: 'Удалить аккаунт',
            subtitle: 'Удалите ваш аккаунт',
            onPressed: () => _onDeleteAccountPressed(context),
            top: 755 * scaleY,
          ),
        ],
      ),
    );
  }
}
