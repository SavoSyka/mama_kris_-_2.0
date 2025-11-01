import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/login_sheet.dart'; // путь к файлу с showLoginSheet
import 'package:mama_kris/screens/registration_flow_dialog.dart';
import 'dart:ui';
import 'package:mama_kris/screens/pass_reset_email.dart';
import 'package:mama_kris/utils/google_apple_auth.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Масштабирование от размеров экрана из Figma (428x956)
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Зеленый блюр (фон)
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

          // logo.svg
          Positioned(
            top: 65 * scaleY,
            left: 83 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/logo.svg',
              width: 262.5 * scaleX,
              height: 262.5 * scaleY,
            ),
          ),

          // text1.svg
          Positioned(
            top: 364 * scaleY,
            left: 79 * scaleX,
            right: 79 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/text1.svg',
              width: 271 * scaleX,
              height: 40 * scaleY,
            ),
          ),

          // text2.svg
          Positioned(
            top: 414 * scaleY,
            left: 71 * scaleX,
            right: 71 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/text2.svg',
              width: 286 * scaleX,
              height: 40 * scaleY,
            ),
          ),

          // Кнопка Регистрации
          Positioned(
            top: 502 * scaleY,
            left: 32 * scaleX,
            child: Container(
              width: 364 * scaleX,
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
                  // Действие при нажатии
                  _onRegisterPressed(context);
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
                        'Пройти регистрацию',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w600,
                          fontSize: 18 *
                              scaleX, // масштабирование текста (при необходимости)
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
          ),

          // Кнопка Вход
          Positioned(
            top: 591 * scaleY,
            left: 32 * scaleX,
            child: Container(
              width: 364 * scaleX,
              height: 72 * scaleY,
              decoration: BoxDecoration(
                // Тень из Figma: 0px 4px 19px 0px #E7E7E778
                boxShadow: [
                  BoxShadow(
                    // #E7E7E7 с альфой 0x78 (десятичное 120)
                    color: const Color(0x78E7E7E7),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                  ),
                ],
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Действие при нажатии
                  _onLoginPressed(context);
                },
                style: ElevatedButton.styleFrom(
                  // Фон белый
                  backgroundColor: Colors.white,
                  // Скруглённые углы
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  // Убираем стандартную «материальную» тень
                  elevation: 0,
                  // Отступы внутри кнопки (20 сверху/снизу, 24 слева/справа)
                  padding: EdgeInsets.symmetric(
                    vertical: 20 * scaleY,
                    horizontal: 24 * scaleX,
                  ),
                ),
                child: Row(
                  children: [
                    // Текст «Войти в аккаунт», занимающий всё доступное пространство слева
                    Expanded(
                      child: Text(
                        'Войти в аккаунт',
                        style: TextStyle(
                          fontFamily: 'Jost', // Подключите в pubspec.yaml
                          fontWeight: FontWeight.w600,
                          fontSize: 18 * scaleX, // Масштабируем шрифт
                          height: 28 / 18, // Относительная высота строки
                          letterSpacing: -0.18 * scaleX, // -1% от 18px ≈ -0.18
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10 * scaleX),

                    // Иконка стрелки
                    SvgPicture.asset(
                      'assets/welcome_screen/arrow_green.svg',
                      width: 32 * scaleX,
                      height: 32 * scaleY,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Текст для соцсетей
          Positioned(
            top: 693 * scaleY,
            left: 91 * scaleX,
            right: 91 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/text3.svg',
              height: 29 * scaleY,
            ),
          ),

          buildSocialButtons(
            top: 732,
            scaleX: scaleX,
            scaleY: scaleY,
            onGooglePressed: () => onGooglePressed(context),
            onApplePressed: () => onApplePressed(context),
            context: context,
          ),
          // Текстовая кнопка "Сбросить пароль" внизу экрана
          // Текстовая кнопка "Сбросить пароль" внизу экрана
          Positioned(
            top: 850 * scaleY,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  foregroundColor: WidgetStateProperty.all(const Color(0xFF00A80E)),
                  textStyle: WidgetStateProperty.resolveWith<TextStyle>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Jost',
                        fontSize: 16 * scaleX,
                      );
                    }
                    return TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'Jost',
                      fontSize: 16 * scaleX,
                    );
                  }),
                ),
                onPressed: () {
                  showPassResetEmailSheet(context);
                },
                child: const Text('Сбросить пароль'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRegisterPressed(BuildContext context) {
    // print("Регистрация нажата");
    showRegistrationFlowDialog(context);
  }

  // 👉 Функция для обработки нажатия кнопки входа
  void _onLoginPressed(BuildContext context) {
    // print("Вход нажата");
    showLoginSheet(context);

    // TODO: Добавить логику входа
  }
}
