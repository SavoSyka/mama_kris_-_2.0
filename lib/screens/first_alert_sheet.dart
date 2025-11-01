import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/next_button.dart';

/// Вызов модального листа (alert sheet)
Future<void> showFirstAlertSheet(BuildContext context) {
  // Базовые размеры из макета Figma: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  /// Функция, которая будет вызываться при нажатии на кнопку «Далее»
  void onAlertNextPressed() {
    // Здесь можно добавить любую нужную логику,
    // а пока просто закроем модальный лист:
    Navigator.of(context).pop();
    // debugPrint('Кнопка «Далее» нажата!');
  }

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "LoginSheet",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Основная панель, выезжающая сверху
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
                      color: const Color(0x78E7E7E7), // #E7E7E778
                      offset: Offset(0, 4 * scaleY),
                      blurRadius: 19 * scaleX,
                    ),
                  ],
                ),
                // Внутренний Stack для позиционирования элементов в панели
                child: Stack(
                  children: [
                    // Текст «Внимание!»
                    Positioned(
                      // top: 369 - 329 = 40
                      top: 40 * scaleY,
                      // left: 36 - 16 = 20
                      left: 20 * scaleX,
                      child: Text(
                        "Внимание!",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w700,
                          fontSize: 28 * scaleX,
                          height: 1.0, // 100% = 28px
                          letterSpacing: 0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Второй абзац
                    Positioned(
                      // top: 407 - 329 = 78
                      top: 78 * scaleY,
                      // left: 36 - 16 = 20
                      left: 20 * scaleX,
                      child: SizedBox(
                        width: 356 * scaleX, // 356 по макету
                        height: 100 * scaleY,
                        child: Text(
                          "Если Вам понравилась вакансия, сразу нажимайте "
                          "\"Интересно\", а то к вакансии вернуться будет "
                          "нельзя.\nПосле нажатия \"Интересно\" вакансия "
                          "сохранится  у вас в разделе \"Мои заказы\" и будет "
                          "доступна  для отклика в течении 10 дней.",
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w400,
                            fontSize: 14 * scaleX,
                            height: 20 / 14,
                            letterSpacing: -0.1 * scaleX,
                            color: const Color(0xFF596574),
                          ),
                        ),
                      ),
                    ),
                    // Кнопка "Далее"
                    Positioned(
                      // top: 537 - 329 = 208
                      top: 208 * scaleY,
                      // left: 36 - 16 = 20
                      left: 20 * scaleX,
                      child: NextButton(
                        scaleX: scaleX,
                        scaleY: scaleY,
                        onPressed: onAlertNextPressed, // вызываем функцию
                        text: 'Далее',
                      ),
                    ),
                  ],
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
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
