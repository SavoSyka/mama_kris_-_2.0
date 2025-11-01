import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'package:mama_kris/screens/career_sheet.dart';
import 'package:mama_kris/screens/psycho_sheet.dart';
import 'application_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;

class MonetizationScreen extends StatefulWidget {
  const MonetizationScreen({super.key});

  @override
  State<MonetizationScreen> createState() => _MonetizationScreenState();
}

class _MonetizationScreenState extends State<MonetizationScreen> {
  bool careerChecked = false;
  bool psychoChecked = false;

  void _onCareerButtonPressed(BuildContext context) async {
    final bool? result = await showCareerSheet(context);
    if (result == true) {
      setState(() {
        careerChecked = true;
      });
      // print("Чекбокс отмечен");
    }
  }

  void _onPsychoButtonPressed(BuildContext context) async {
    final bool? result = await showPsychoSheet(context);
    if (result == true) {
      setState(() {
        psychoChecked = true;
      });
      // print("Чекбокс отмечен");
    }
  }

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
              'assets/monetization_screen/text1.svg',
              width: 253 * scaleX,
              height: 26 * scaleY,
              fit: BoxFit.cover,
            ),
          ),
          // SVG-текст 2 из monetization_screen
          Positioned(
            top: 383 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/monetization_screen/text2.svg',
              width: 389 * scaleX,
              height: 98 * scaleY,
              fit: BoxFit.cover,
            ),
          ),

          // Карьерный консультант
          Positioned(
            top: 503 * scaleY,
            left: 16 * scaleX,
            child: Container(
              width: 396 * scaleX,
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
                  // showCareerSheet(context);
                  _onCareerButtonPressed(context);
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
                    // Текст «Карьерный консультант», занимающий всё доступное пространство слева
                    Expanded(
                      child: Text(
                        'Карьерный консультант',
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

          // Психологическая поддержка
          Positioned(
            top: 595 * scaleY,
            left: 16 * scaleX,
            child: Container(
              width: 396 * scaleX,
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
                  _onPsychoButtonPressed(context);
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
                    // Текст "Психологическая поддержка", занимающий всё доступное пространство слева
                    Expanded(
                      child: Text(
                        'Психологическая поддержка',
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
          // Чекбокс 1
          Positioned(
            top: 687 * scaleY, // (505 - 329) = 176
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
            top: 687 * scaleY,
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
                    TextSpan(
                      text: 'Услуга “Карьерный консультант” актуальна для меня',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Чекбокс 2
          Positioned(
            top: 717 * scaleY, // (505 - 329) = 176
            left: 16 * scaleX, // (36 - 16) = 20
            child: CustomCheckbox(
              initialValue: psychoChecked,
              onChanged: (bool value) {
                setState(() {
                  psychoChecked = value;
                });
                // print("Первый чекбокс: $value");
              },
              scaleX: scaleX,
              scaleY: scaleY,
            ),
          ),
          Positioned(
            top: 717 * scaleY,
            left: 45 * scaleX,
            child: SizedBox(
              width: 302 * scaleX,
              height: 40 * scaleY,
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
                    TextSpan(
                      text:
                          'Услуга “Психологическая поддержка” актуальна для меня',
                    ),
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
              onPressed: () async {
                // Если отмечен чекбокс "Карьерный консультант", вызываем функцию обновления
                if (careerChecked) {
                  // final resultKar =
                  await funcs.updateKarKonsStatusFromCache();
                  // print("Updated kar_kons data: $resultKar");
                }
                // Если отмечен чекбокс "Психологическая поддержка", вызываем функцию обновления
                if (psychoChecked) {
                  // final resultPsy =
                  await funcs.updatePsyKonsStatusFromCache();
                  // print("Updated psy_kons data: $resultPsy");
                }

                // Переходим на следующую страницу
                _navigateToChoice(context);
                // print("Далее");
              },
            ),
          ), // Добавляем BottomBar в нижней части экрана:
        ],
      ),
    );
  }
}
