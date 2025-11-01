import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/widgets/next_button.dart';

/// Показывает модальное окно "PsychoSheet" – панель, выезжающая снизу.
/// Панель имеет фиксированные размеры (396×627, расположение: top:329px, left:16px).
/// Содержимое внутри панели прокручивается, если выходит за пределы.
Future<bool?> showPsychoSheet(BuildContext context) {
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "PsychoSheet",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Панель с фиксированными размерами, выезжающая сверху
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
                child: SingleChildScrollView(
                  child: SizedBox(
                    // Фиксированная высота, чтобы Stack имел размеры панели
                    height: 755 * scaleY,
                    child: Stack(
                      children: [
                        // SVG-текст "title" (text1.svg)
                        // Относительно панели: top = 369 - 329 = 40, left = 36 - 16 = 20.
                        Positioned(
                          top: 40 * scaleY,
                          left: 20 * scaleX,
                          child: SvgPicture.asset(
                            'assets/psycho_sheet/title.svg',
                            width: 162 * scaleX,
                            height: 56 * scaleY,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // SVG-текст "description" (text2.svg)
                        // Относительно панели: top = 435 - 329 = 106, left = 36 - 16 = 20.
                        Positioned(
                          top: 106 * scaleY,
                          left: 20 * scaleX,
                          child: SvgPicture.asset(
                            'assets/psycho_sheet/description.svg',
                            width: 356 * scaleX,
                            height: 480 * scaleY,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Кнопка "Мне интересно"
                        // Относительно панели: top = 725 - 329 = 396, left = 36 - 16 = 20.
                        Positioned(
                          top: 656 * scaleY,
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
                                // final resultPsy =
                                await funcs.updatePsyKonsStatusFromCache();
                                // print("Updated psy_kons data: $resultPsy");
                                Navigator.pop(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A80E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    13 * scaleX,
                                  ),
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
                          top: 656 * scaleY, // (645 - 329) = 316
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
