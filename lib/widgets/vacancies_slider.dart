import 'dart:ui';
import 'package:flutter/material.dart';
import 'vacancy_content.dart';

class VacanciesSlider extends StatelessWidget {
  final Map<String, dynamic> vacancy;
  final int vacancyIndex;
  final int previousVacancyIndex;
  // slideDirection: -1 для "Интересно" (новый появляется с левой стороны), +1 для "Неинтересно" (новый появляется с правой стороны)
  final int slideDirection;
  final VoidCallback onInterestedPressed;
  final VoidCallback onNotInterestedPressed;

  const VacanciesSlider({
    Key? key,
    required this.vacancy,
    required this.vacancyIndex,
    required this.previousVacancyIndex,
    required this.slideDirection,
    required this.onInterestedPressed,
    required this.onNotInterestedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("Building VacanciesSlider with key: ${key}");

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Container(
      width: 395 * scaleX,
      height: 500 * scaleY,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15 * scaleX),
        boxShadow: const [
          BoxShadow(
            color: Color(0x78E7E7E7),
            offset: Offset(0, 4),
            blurRadius: 19,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            width: 395 * scaleX,
            height: 440 * scaleY,
            padding: EdgeInsets.symmetric(horizontal: 16 * scaleX),
            decoration: BoxDecoration(
              color: Colors.white, // или другой фон, если требуется
              borderRadius: BorderRadius.circular(15 * scaleX),
            ),
            clipBehavior:
                Clip.hardEdge, // обрезаем всё, что выходит за рамки контейнерак
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Если child.key соответствует новому vacancyIndex, это входящий виджет
                if (child.key == ValueKey(vacancyIndex)) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: slideDirection == 1
                          ? const Offset(-1, 0)
                          : const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      // Исходящий виджет остается полностью видимым (opacity = 1)
                      // до тех пор, пока не пройдет 20% времени анимации,
                      // а затем плавно исчезает до 0.
                      opacity: TweenSequence<double>([
                        TweenSequenceItem(
                          tween: ConstantTween(0.0),
                          weight: 20,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 0.0, end: 1.0),
                          weight: 80,
                        ),
                      ]).animate(animation),
                      child: child,
                    ),
                  );
                }
                // Если child.key соответствует previousVacancyIndex, это исходящий виджет
                if (child.key == ValueKey(previousVacancyIndex)) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      end: Offset.zero,
                      begin: slideDirection == 1
                          ? const Offset(1, 0)
                          : const Offset(-1, 0),
                    ).animate(animation),
                    child: FadeTransition(
                      // Исходящий виджет остается полностью видимым (opacity = 1)
                      // до тех пор, пока не пройдет 20% времени анимации,
                      // а затем плавно исчезает до 0.
                      opacity: TweenSequence<double>([
                        TweenSequenceItem(
                          tween: ConstantTween(1.0),
                          weight: 20,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 1.0, end: 0.0),
                          weight: 80,
                        ),
                      ]).animate(animation),
                      child: child,
                    ),
                  );
                }
                return child;
              },
              child: VacancyContent(
                vacancy: vacancy,
                key: ValueKey(vacancyIndex),
              ),
            ),
          ),
          // Фиксированная кнопка "Интересно" (справа)
          Positioned(
            top: 430.36 * scaleY,
            left: 205.64 * scaleX,
            child: Container(
              width: 162.33 * scaleX,
              height: 44.78 * scaleY,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15 * scaleX),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCFFFD1),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onInterestedPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A80E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Интересно',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 18 * scaleX,
                    height: 28 / 18,
                    letterSpacing: -0.54 * scaleX,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Фиксированная кнопка "Неинтересно" (слева)
          Positioned(
            top: 430 * scaleY,
            left: 26 * scaleX,
            child: Container(
              width: 162.33 * scaleX,
              height: 44.78 * scaleY,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15 * scaleX),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x78E7E7E7),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onNotInterestedPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Неинтересно',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 18 * scaleX,
                    height: 28 / 18,
                    letterSpacing: -0.54 * scaleX,
                    color: const Color(0xFF596574),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
