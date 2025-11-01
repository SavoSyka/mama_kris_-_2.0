import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/custom_dropdown.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/constants/api_constants.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // GlobalKey для доступа к состоянию CustomMultiSelectDropdown
  final GlobalKey<CustomMultiSelectDropdownState> multiSelectKey =
      GlobalKey<CustomMultiSelectDropdownState>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadPhoneNumber();
  }

  /// Загружает сохранённые имя, телефон и выбранные сферы из SharedPreferences.
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('name');
    String? savedPhone = prefs.getString('phone');
    List<String>? savedSpheres = prefs.getStringList(
      'job_search_selected_spheres',
    );
    if (savedName != null) {
      nameController.text = savedName;
    }
    if (savedPhone != null) {
      phoneController.text = savedPhone;
    }
    if (savedSpheres != null && savedSpheres.isNotEmpty) {
      Set<int> savedSphereIDs = savedSpheres.map((s) => int.parse(s)).toSet();
      if (multiSelectKey.currentState != null) {
        multiSelectKey.currentState!.updateSelectedValues(savedSphereIDs);
      }
    }
  }

  /// Загружает номер телефона с сервера
  Future<void> _loadPhoneNumber() async {
    final phone = await _getPhoneNumber();
    if (phone != null) {
      setState(() {
        phoneController.text = phone;
      });
    }
  }

  /// Обработка нажатия кнопки "Опубликовать"
  Future<void> _onPublishPressed(BuildContext context) async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    final cleanedPhone = funcs.validateAndFormatPhone(phone, context);
    if (cleanedPhone == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Введите номер телефона")));
      return;
    }

    // Получаем выбранные сферы (идентификаторы) из CustomMultiSelectDropdown
    Set<int> selectedSphereIDs =
        multiSelectKey.currentState?.selectedValues ?? {};

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Введите имя")));
      return;
    }

    if (selectedSphereIDs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Выберите хотя бы одну сферу")),
      );
      return;
    }

    // print("Имя: $name");
    // print("Телефон: $cleanedPhone");
    // print("Выбранные сферы:");
    // for (var id in selectedSphereIDs) {
    //   // print("ID: $id");
    // }

    final isChanged = await _isUserDataChanged();
    // print("Имя/телефон изменены: $isChanged");
    // только если изменены — обновим имя/телефон
    // final isChanged = await _isUserDataChanged();
    if (isChanged) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('auth_token');
      String? userId = prefs.getInt('user_id')?.toString();
      if (accessToken != null && userId != null) {
        final updated = await _updateNameAndPhone(accessToken, userId);
        if (!updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ошибка обновления данных")),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка: Пользователь не найден")),
        );
        return;
      }
    }

    // Сохраняем введённые данные для будущей инициализации
    await _saveInitialData(name, cleanedPhone, selectedSphereIDs);

    // Выполняем цепочку обновления данных: обновление номера телефона и отправка выбранных сфер
    await _saveJobSearch();
  }

  Future<bool> _isUserDataChanged() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name')?.trim() ?? '';
    final savedPhone = prefs.getString('phone')?.trim() ?? '';

    final currentName = nameController.text.trim();
    final currentPhone =
        funcs.validateAndFormatPhone(phoneController.text.trim(), context) ??
            '';

    return currentName != savedName || currentPhone != savedPhone;
  }

  /// Сохраняет имя, телефон и выбранные сферы в SharedPreferences.
  Future<void> _saveInitialData(
    String name,
    String phone,
    Set<int> sphereIDs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('phone', phone);
    await prefs.setStringList(
      'job_search_selected_spheres',
      sphereIDs.map((e) => e.toString()).toList(),
    );
    // print(phone);
  }

  /// Выполняет цепочку обновления: обновление номера телефона и отправка выбранных сфер.
  Future<void> _saveJobSearch() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('auth_token');
    String? userId = prefs.getInt('user_id')?.toString();
    if (accessToken == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка: Пользователь не найден")),
      );
      return;
    }

    // Если требуется удаление старых сфер, раскомментируйте следующую строку:
    // bool spheresDeleted = await _deleteAllSpheres(accessToken, userId);
    // if (!spheresDeleted) return;

    Set<int> selectedSphereIDs =
        multiSelectKey.currentState?.selectedValues ?? {};
    bool spheresAdded = await _addNewSpheres(
      accessToken,
      userId,
      selectedSphereIDs,
    );
    if (!spheresAdded) return;

    await prefs.setString('current_page', 'search');
    await prefs.remove('saved_jobs');
    await prefs.remove('saved_reduced_jobs');

    // Навигация на MainScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (_) => false,
    );
  }

  Future<bool> _updateNameAndPhone(String accessToken, String userId) async {
    final name = nameController.text.trim();
    final rawPhone = phoneController.text.trim();
    final phone = funcs.validateAndFormatPhone(rawPhone, context);

    if (phone == null) return false;

    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse('${kBaseUrl}users/$userId/update-info');

    final body = jsonEncode({'phone': cleanedPhone, 'name': name});

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // debugPrint('📤 Отправка запроса на обновление имени/телефона:');
    // debugPrint('➡️ URL: $url');
    // debugPrint('➡️ Headers: $headers');
    // debugPrint('➡️ Body: $body');

    final response = await http.put(url, headers: headers, body: body);

    // debugPrint('📥 Ответ от сервера: ${response.statusCode}');
    // debugPrint('📦 Тело ответа: ${response.body}');

    if (response.statusCode == 401) {
      final refreshSuccess = await funcs.refreshAccessToken();
      if (refreshSuccess) {
        final newToken = (await SharedPreferences.getInstance()).getString(
          'auth_token',
        );
        if (newToken != null) {
          return await _updateNameAndPhone(newToken, userId);
        }
      }
      _showErrorSnackBar(context, 'Ошибка аутентификации');
      return false;
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      _showErrorSnackBar(context, 'Ошибка обновления имени/телефона');
      return false;
    }

    return true;
  }

  /// Функция удаления всех сфер на сервере (при необходимости).
  Future<bool> _deleteAllSpheres(String accessToken, String userId) async {
    for (int i = 1; i <= 30; i++) {
      final response = await http.delete(
        Uri.parse('${kBaseUrl}user-preferences/$userId/$i'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 401) {
        final refreshSuccess = await funcs.refreshAccessToken();
        if (refreshSuccess) {
          final newAccessToken = await SharedPreferences.getInstance().then(
            (prefs) => prefs.getString('auth_token')!,
          );
          return await _deleteAllSpheres(newAccessToken, userId);
        } else {
          _showErrorSnackBar(context, 'Ошибка аутентификации');
          return false;
        }
      }
      if (response.statusCode != 200 && response.statusCode != 404) {
        _showErrorSnackBar(context, 'Ошибка удаления сферы с id $i');
        return false;
      }
    }
    return true;
  }

  /// Функция добавления выбранных сфер на сервере.
  Future<bool> _addNewSpheres(
    String accessToken,
    String userId,
    Set<int> sphereIDs,
  ) async {
    final response = await http.post(
      Uri.parse('${kBaseUrl}user-preferences/bulk/$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'sphereIDs': sphereIDs.toList()}),
    );
    if (response.statusCode == 401) {
      final refreshSuccess = await funcs.refreshAccessToken();
      if (refreshSuccess) {
        final newAccessToken = await SharedPreferences.getInstance().then(
          (prefs) => prefs.getString('auth_token')!,
        );
        return await _addNewSpheres(newAccessToken, userId, sphereIDs);
      } else {
        _showErrorSnackBar(context, 'Ошибка аутентификации');
        return false;
      }
    }
    if (response.statusCode != 201) {
      _showErrorSnackBar(context, 'Ошибка добавления сфер');
      return false;
    }
    return true;
  }

  /// Функция получения номера телефона с сервера.
  Future<String?> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('auth_token');
    String? userId = prefs.getInt('user_id')?.toString();
    if (accessToken == null || userId == null) {
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('${kBaseUrl}users/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return userData['phone'];
      } else if (response.statusCode == 401) {
        final refreshSuccess = await funcs.refreshAccessToken();
        if (refreshSuccess) {
          return _getPhoneNumber();
        }
      }
    } catch (e) {
      // print("Ошибка при получении номера телефона: $e");
    }
    return null;
  }

  /// Отображает SnackBar с сообщением об ошибке.
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Масштабирование по размерам макета (428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Фон (зелёный блюр)
          Positioned(
            top: 151 * scaleY,
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
          // Логотип
          Positioned(
            top: 65 * scaleY,
            left: 83 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/logo.svg',
              width: 262.5 * scaleX,
              height: 262.5 * scaleY,
            ),
          ),
          // Форма размещения заявки с прокруткой
          Positioned(
            top: 335 * scaleY,
            left: 0,
            right: 0,
            bottom: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleX,
                    vertical: 20 * scaleY,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        SizedBox(
                          width: 260 * scaleX,
                          height: 76 * scaleY,
                          child: Text(
                            "Разместите заявку на поиск работы",
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w700,
                              fontSize: 26 * scaleX,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Имя"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Ваше имя",
                          isPassword: false,
                          enableToggle: false,
                          controller: nameController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Выпадающий список "Категория" (мультивыбор)
                        CustomMultiSelectDropdown(
                          key: multiSelectKey,
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Категория",
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Телефон"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Телефон",
                          isPassword: false,
                          enableToggle: false,
                          controller: phoneController,
                        ),
                        SizedBox(height: 40 * scaleY),
                        // Кнопка "Опубликовать"
                        Container(
                          width: 396 * scaleX,
                          height: 72 * scaleY,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFCFFFD1),
                                offset: Offset(0, 4 * scaleY),
                                blurRadius: 19 * scaleX,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15 * scaleX),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _onPublishPressed(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A80E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15 * scaleX,
                                ),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: 20 * scaleY,
                                horizontal: 24 * scaleX,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Опубликовать',
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 * scaleX,
                                      height: 28 / 18,
                                      letterSpacing: -0.18 * scaleX,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10 * scaleX),
                                SvgPicture.asset(
                                  'assets/welcome_screen/arrow.svg',
                                  width: 32 * scaleX,
                                  height: 32 * scaleY,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scaleY),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
