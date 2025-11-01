// vacancy_dialog.dart
import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/vacancy_content.dart';
import 'package:mama_kris/widgets/vacancies_banner.dart';

/// Показывает диалоговое окно с содержимым VacancyContent и VacanciesBanner
/// для переданной вакансии.
void showVacancyDialog(BuildContext context, Map<String, dynamic> vacancy) {
  // Вычисляем масштабные коэффициенты по размерам экрана (исходя из макета 428x956)
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'VacancyDialog',
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Stack(
          children: [
            // Основной контейнер диалога
            Positioned(
              top: 105 * scaleY,
              left: 16 * scaleX,
              child: Material(
                borderRadius: BorderRadius.circular(15 * scaleX),
                child: Container(
                  width: 395 * scaleX,
                  height: 570 * scaleY,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: VacancyContent(vacancy: vacancy),
                ),
              ),
            ),
            Positioned(
              top: 688 * scaleY,
              left: 16 * scaleX,
              child: const VacanciesBanner(),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
