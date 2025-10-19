import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/widgets/vacancy_content.dart';

class ApplicantJobSlider extends StatelessWidget {
  final Map<String, dynamic> vacancy;
  final int vacancyIndex;
  final int previousVacancyIndex;
  // slideDirection: -1 для "Интересно" (новый появляется с левой стороны), +1 для "Неинтересно" (новый появляется с правой стороны)
  final int slideDirection;
  final VoidCallback onInterestedPressed;
  final VoidCallback onNotInterestedPressed;

  const ApplicantJobSlider({
    super.key,
    required this.vacancy,
    required this.vacancyIndex,
    required this.previousVacancyIndex,
    required this.slideDirection,
    required this.onInterestedPressed,
    required this.onNotInterestedPressed,
  });

  @override
  Widget build(BuildContext context) {
    // print("Building ApplicantJobSlider with key: ${key}");

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Container(
      width: 395 * scaleX,
      height: screenHeight * 0.58,
      padding: const EdgeInsets.all(30),
      decoration: AppTheme.cardDecoration,

      child: Column(
        children: [
          Container(
            width: 395 * scaleX,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 32,
                ),
                decoration: AppTheme.cardDecoration,
                child: InkWell(
                  onTap: onInterestedPressed,

                  child: const Text(
                    'Интересно',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,

                      color: AppPalette.primaryColor,
                    ),
                  ),
                ),
              ),
              // Фиксированная кнопка "Неинтересно" (слева)
              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 32,
                ),
                decoration: AppTheme.primaryColordecoration,
                child: InkWell(
                  onTap: onNotInterestedPressed,

                  child: Text(
                    'Неинтересно',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      fontSize: 18 * scaleX,
                      height: 28 / 18,
                      letterSpacing: -0.54 * scaleX,
                      color: AppPalette.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
