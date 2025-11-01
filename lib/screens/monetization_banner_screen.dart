import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'application_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mama_kris/utils/funcs.dart' as funcs;

class MonetizationBannerScreen extends StatefulWidget {
  const MonetizationBannerScreen({super.key});

  @override
  State<MonetizationBannerScreen> createState() =>
      _MonetizationBannerScreenState();
}

class _MonetizationBannerScreenState extends State<MonetizationBannerScreen> {
  bool careerChecked = false;
  bool psychoChecked = false;
  Future<void> _navigateToChoice(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final choice = prefs.getString('choice');
    // Определяем целевую страницу и значение для current_page по выбору пользователя.
    final Widget targetPage =
        (choice == 'Looking for job') ? const ApplicationScreen() : const MainScreen();
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

  @override
  Widget build(BuildContext context) {
    // Рассчитываем коэффициенты масштабирования от базового макета (428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Фон с blur из welcome_screen
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

          // Логотип из welcome_screen
          Positioned(
            top: 65 * scaleY,
            left: 83 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/logo.svg',
              width: 263 * scaleX,
              height: 263 * scaleY,
            ),
          ),
          // SVG-текст 1 из monetization_screen
          Positioned(
            top: 335 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/monetization_banner_screen/title.svg',
              width: 50 * scaleX,
              height: 25 * scaleY,
              fit: BoxFit.cover,
            ),
          ),
          // SVG-текст 2 из monetization_screen
          Positioned(
            top: 383 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/monetization_banner_screen/description.svg',
              width: 389 * scaleX,
              height: 220 * scaleY,
              fit: BoxFit.cover,
            ),
          ),

          // Чекбокс 1
          Positioned(
            top: 623 * scaleY, // (505 - 329) = 176
            left: 16 * scaleX, // (36 - 16) = 20
            child: CustomCheckbox(
              initialValue: careerChecked,
              onChanged: (bool value) {
                setState(() {
                  careerChecked = value;
                });
                // print("Первый чекбокс: $value");
              },
              scaleX: scaleX,
              scaleY: scaleY,
            ),
          ),
          Positioned(
            top: 623 * scaleY,
            left: 45 * scaleX,
            child: SizedBox(
              width: 323 * scaleX,
              height: 20 * scaleY,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * scaleX,
                    height: 20 / 14,
                    letterSpacing: -0.1 * scaleX,
                    color: Colors.black,
                  ),
                  children: const [
                    TextSpan(text: 'Да, предложение для меня актуально'),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 787 * scaleY, // (505 - 329) = 176
            left: 16 * scaleX, // (36 - 16) = 20
            child: NextButton(
              scaleX: scaleX,
              scaleY: scaleY,
              onPressed: () {
                _navigateToChoice(context);
                // print("Далее");
                // Добавьте здесь логику перехода или обработки нажатия.
              },
            ),
          ), // Добавляем BottomBar в нижней части экрана:
        ],
      ),
    );
  }
}
