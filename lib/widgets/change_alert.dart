import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Показывает диалог "DeleteAlert" с текстовым содержимым.
Future<void> showChangeAlert(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  /// Функция, которая будет вызываться при нажатии на кнопку «Удалить»
  void onPressed() {
    // Здесь можно добавить любую нужную логику,
    // а пока просто закроем модальный лист:
    Navigator.of(context).pop();
    // debugPrint('Кнопка  нажата!');
  }

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'CustomDialog',
    barrierColor: Colors.white.withOpacity(0.5),
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return SafeArea(
        child: Stack(
          children: [
            // Основной контейнер диалога
            Positioned(
              top: 165 * scaleY,
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
                  // Размещаем текстовые элементы внутри контейнера
                  child: Stack(
                    children: [
                      // Текст "Удалить из избранного?"
                      Positioned(
                        top: 40 * scaleY,
                        left: 20 * scaleX,
                        child: SizedBox(
                          width: 383 * scaleX,
                          height: 28 * scaleY,
                          child: Text(
                            "Ваша роль успешно изменена",
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w700,
                              fontSize: 22 * scaleX,
                              height: 1.0, // line-height: 100%
                              letterSpacing: 0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // Текст "Вы больше не увидите эту вакансию, вы согласны?"
                      Positioned(
                        top: 78 * scaleY,
                        left: 20 * scaleX,
                        child: SizedBox(
                          width: 383 * scaleX,
                          height: 40 * scaleY,
                          child: Text(
                            "Теперь вы находитесь в роли «работодатель» и можете разместить свою вакансию. Нажав на кнопку ниже 👇",
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w400,
                              fontSize: 14 * scaleX,
                              height: 20 / 14, // line-height: 20px
                              letterSpacing: -0.1 * scaleX,
                              color: const Color(0xFF596574),
                            ),
                          ),
                        ),
                      ),
                      // ЛОГО
                      Positioned(
                        top: 138 * scaleY,
                        left: 67 * scaleX,
                        child: SvgPicture.asset(
                          'assets/welcome_screen/logo.svg',
                          width: 263 * scaleX,
                          height: 263 * scaleY,
                        ),
                      ),
                      // Кнопка "Разместить заказ"
                      Positioned(
                        top: 458 * scaleY,
                        left: 16 * scaleX,
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
                              onPressed();
                            },
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
                                    'Разместить заказ',
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
                                Image.asset(
                                  'assets/welcome_screen/arrow.png',
                                  width: 32 * scaleX,
                                  height: 32 * scaleY,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
