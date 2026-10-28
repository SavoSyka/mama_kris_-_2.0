import 'package:flutter/material.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';

/// Карточка вакансии в режиме «Слайдер» (макет «С рекламой предложение»).
class ApplicantJobSlider extends StatelessWidget {
  final Map<String, dynamic> vacancy;
  final int vacancyIndex;
  final int previousVacancyIndex;
  // slideDirection: -1 для "Интересно" (новый появляется с левой стороны), +1 для "Неинтересно" (новый появляется с правой стороны)
  final int slideDirection;
  final VoidCallback onInterestedPressed;
  final VoidCallback onNotInterestedPressed;
  final VoidCallback? onTap;

  /// Высота карточки целиком; описание прокручивается внутри
  final double height;

  const ApplicantJobSlider({
    super.key,
    required this.vacancy,
    required this.vacancyIndex,
    required this.previousVacancyIndex,
    required this.slideDirection,
    required this.onInterestedPressed,
    required this.onNotInterestedPressed,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AdUi.greyStroke),
        boxShadow: const [AdUi.shadowGreen],
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  layoutBuilder: (current, previous) => Stack(
                    children: [...previous, if (current != null) current],
                  ),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        // Входящая карточка
                        if (child.key == ValueKey(vacancyIndex)) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: slideDirection == 1
                                  ? const Offset(-1, 0)
                                  : const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
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
                        // Уходящая карточка
                        if (child.key == ValueKey(previousVacancyIndex)) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              end: Offset.zero,
                              begin: slideDirection == 1
                                  ? const Offset(1, 0)
                                  : const Offset(-1, 0),
                            ).animate(animation),
                            child: FadeTransition(
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
                  child: _VacancyInfo(
                    key: ValueKey(vacancyIndex),
                    vacancy: vacancy,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CardButton(
                  text: 'Неинтересно',
                  onTap: onNotInterestedPressed,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _CardButton(
                  text: 'Интересно',
                  primary: true,
                  onTap: onInterestedPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VacancyInfo extends StatelessWidget {
  const _VacancyInfo({super.key, required this.vacancy});

  final Map<String, dynamic> vacancy;

  String? get _salary {
    final value = num.tryParse(vacancy['salary']?.toString() ?? '');
    if (value == null) return null;
    if (value == 0) return 'По договоренности';
    final digits = value.round().toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+$)'),
      (_) => ' ',
    );
    return 'от $grouped руб';
  }

  @override
  Widget build(BuildContext context) {
    final salary = _salary;
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vacancy['title'] ?? 'Нет названия',
              style: AdUi.manrope(16, FontWeight.w700, lineHeight: 20.8),
            ),
            if (salary != null) ...[
              const SizedBox(height: 4),
              Text(
                salary,
                style: AdUi.manrope(16, FontWeight.w500, lineHeight: 20.8),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              vacancy['description'] ?? 'Нет описания',
              style: AdUi.manrope(
                12,
                FontWeight.w600,
                color: AdUi.grey,
                lineHeight: 15.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    required this.text,
    required this.onTap,
    this.primary = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? AdUi.green : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [AdUi.shadowGreen],
        ),
        child: Text(
          text,
          style: AdUi.manrope(
            12,
            FontWeight.w600,
            color: primary ? Colors.white : AdUi.darkGreen,
            lineHeight: 15.6,
          ),
        ),
      ),
    );
  }
}
