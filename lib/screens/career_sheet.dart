import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/widgets/next_button.dart';

/// Функция для показа модального окна "CareerSheet" – панели, выезжающей снизу.
Future<bool?> showCareerSheet(BuildContext context) {
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  return showGeneralDialog<bool>(
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
                child: Stack(
                  children: [
                    // text1.svg
                    Positioned(
                      top: 40 * scaleY, // 369 - 329 = 40
                      left: 20 * scaleX, // 36 - 16 = 20
                      child: SvgPicture.asset(
                        'assets/career_sheet/title.svg',
                        width: 162 * scaleX,
                        height: 56 * scaleY,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // text2.svg
                    Positioned(
                      top: 106 * scaleY, // 435 - 329 = 106
                      left: 20 * scaleX, // 36 - 16 = 20
                      child: SvgPicture.asset(
                        'assets/career_sheet/description.svg',
                        width: 356 * scaleX,
                        height: 260 * scaleY,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Кнопка "Мне интересно"
                    // Относительно панели: top = 725 - 329 = 396, left = 36 - 16 = 20.
                    Positioned(
                      top: 396 * scaleY,
                      left: 20 * scaleX,
                      child: Container(
                        width: 162.33 * scaleX,
                        height: 44.78 * scaleY,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A80E),
                          borderRadius: BorderRadius.circular(13 * scaleX),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCFFFD1),
                              offset: Offset(0, 4 * scaleY),
                              blurRadius: 19 * scaleX,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            // print("Кнопка 'Мне интересно' нажата");
                            // final resultKar =
                            await funcs.updateKarKonsStatusFromCache();
                            // print("Updated kar_kons data: $resultKar");
                            Navigator.pop(context, true);

                            // Добавьте здесь логику обработки нажатия
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A80E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13 * scaleX),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.fromLTRB(
                              2 * scaleX,
                              2 * scaleY,
                              2 * scaleX,
                              2 * scaleY,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Мне интересно",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.w600,
                                fontSize: 17 * scaleX,
                                height: 28 / 18,
                                letterSpacing: -0.54 * scaleX,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 396 * scaleY, // (645 - 329) = 316
                      right: 20 * scaleX, // (36 - 16) = 20
                      child: PopButton(
                        scaleX: scaleX,
                        scaleY: scaleY,
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
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
