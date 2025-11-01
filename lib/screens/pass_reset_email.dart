import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/screens/pass_reset_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Функция для показа модального окна "CareerSheet" – панели, выезжающей снизу,
/// с прокручиваемым содержимым.
void showPassResetEmailSheet(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  Future<void> PassReset({
    required String email,
    required BuildContext context,
    required void Function() onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${kBaseUrl}auth/reset-password-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      // print(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Код для сброса пароля отправлен на $email')),
        );
        onSuccess();
      } else {
        throw Exception('Ошибка отправки запроса на сброс пароля');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отправке запроса: $error')),
      );
    }
  }

  /// Функция, которая вызывается при нажатии на основную кнопку.
  void onButtonPressed() async {
    final String email = emailController.text.trim();
    if (email.isEmpty) {
      // Если поле пустое, показываем SnackBar и не продолжаем дальше.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите вашу электронную почту'),
        ),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    Navigator.pop(context);
    PassReset(
      email: email,
      context: context,
      onSuccess: () {
        showPassResetFlow(context);
      },
    );
  }

  showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "CareerSheet",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Панель, выезжающая сверху
            Positioned(
              top: 329 * scaleY,
              left: 16 * scaleX,
              child: Container(
                width: 396 * scaleX,
                height: 627 * scaleY,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15 * scaleX),
                    topRight: Radius.circular(15 * scaleX),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x78E7E7E7),
                      offset: Offset(0, 4 * scaleY),
                      blurRadius: 19 * scaleX,
                    ),
                  ],
                ),
                // Прокручиваемое содержимое панели
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20 * scaleX),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40 * scaleY,
                      ), // Отступ сверху (369 - 329 = 40)
                      // Заголовок
                      SizedBox(
                        width: 340 * scaleX,
                        child: Text(
                          "Введите вашу электронную почту",
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
                      // Описание
                      Text(
                        "На нее придет код подтверждения для сброса пароля",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          letterSpacing: -0.1 * scaleX,
                          color: const Color(0xFF596574),
                        ),
                      ),
                      SizedBox(height: 30 * scaleY),
                      CustomTextField(
                        scaleX: scaleX,
                        scaleY: scaleY,
                        hintText: "Email",
                        isPassword: false,
                        enableToggle: false,
                        controller: emailController,
                      ),
                      SizedBox(height: 250 * scaleY),
                      // Кнопка "Узнать больше" – часть прокручиваемого контента
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
                          onPressed: () {
                            onButtonPressed();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A80E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15 * scaleX),
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
                                  'Сбросить пароль',
                                  textAlign: TextAlign.center,
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
                      SizedBox(height: 50 * scaleY),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
