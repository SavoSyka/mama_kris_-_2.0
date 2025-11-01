// lib/login_sheet.dart
import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/custom_text_field.dart'; // Импорт нашего виджета
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/widgets/next_button.dart';

/// Показывает модальный выезжающий лист (modal bottom sheet)
/// с содержимым, масштабируемым под размеры устройства.
void showInvestorsSheet(BuildContext context) {
  // Базовые размеры из макета Figma: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  // Создаем контроллеры для каждого текстового поля:
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController providerController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "InvestorsSheet",
    // Оверлей – белый с opacity
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Панель, выезжающая сверху (modal bottom sheet / sliding panel)
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
                    // Тень из макета: 0px 4px 19px 0px #E7E7E778
                    BoxShadow(
                      color: const Color(0x78E7E7E7),
                      offset: Offset(0, 4 * scaleY),
                      blurRadius: 19 * scaleX,
                    ),
                  ],
                ),
                // Содержимое панели – все элементы выезжают вместе с ней
                child: Stack(
                  children: [
                    // SVG-текст (пример)
                    Positioned(
                      top: 40 * scaleY, // 369 - 329 = 40
                      left: 20 * scaleX, // 36 - 16 = 20
                      child: SizedBox(
                        width: 225 * scaleX,
                        child: Text(
                          "Инвесторам",
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w700,
                            fontSize: 26 * scaleX,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 78 * scaleY,
                      left: 20 * scaleX, // 36 - 16 = 20
                      child: SizedBox(
                        width: 356 * scaleX,
                        child: Text(
                          "У нашей it-компании есть открытые локации для продажи доли в компании. Если интересно участие в нашем проекте, оставляйте заявку. Основательница лично с Вами свяжется, чтобы обсудить все детали. ",
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
                    // Поле ввода "Ваше имя"
                    Positioned(
                      top: 181 * scaleY,
                      left: 20 * scaleX,
                      child: CustomTextField(
                        scaleX: scaleX,
                        scaleY: scaleY,
                        hintText: "Ваше имя",
                        isPassword: false,
                        enableToggle: false,
                        controller: nameController,
                      ),
                    ),
                    // Поле ввода "Номер телефона"
                    Positioned(
                      top: 261 * scaleY,
                      left: 20 * scaleX,
                      child: CustomTextField(
                        scaleX: scaleX,
                        scaleY: scaleY,
                        hintText: "Номер телефона",
                        isPassword: false,
                        enableToggle: false,
                        controller: phoneController,
                      ),
                    ),
                    // Поле ввода "Email"
                    // Positioned(
                    //   top: 341 * scaleY,
                    //   left: 20 * scaleX,
                    //   child: CustomTextField(
                    //     scaleX: scaleX,
                    //     scaleY: scaleY,
                    //     hintText: "Email",
                    //     isPassword: false,
                    //     enableToggle: false,
                    //     controller: emailController,
                    //   ),
                    // ),
                    // // Поле ввода "Ссылка на продвижение"
                    // Positioned(
                    //   top: 421 * scaleY,
                    //   left: 20 * scaleX,
                    //   child: CustomTextField(
                    //     scaleX: scaleX,
                    //     scaleY: scaleY,
                    //     hintText: "Мессенджер для связи",
                    //     isPassword: false,
                    //     enableToggle: false,
                    //     controller: providerController,
                    //   ),
                    // ),
                    // Кнопка "оставить заявку"
                    Positioned(
                      top: 458 * scaleY,
                      left: 20 * scaleX,
                      child: Container(
                        width: 170 * scaleX,
                        height: 47 * scaleY,
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
                            // Извлекаем данные из контроллеров
                            final String name = nameController.text;
                            final String phone = phoneController.text;

                            // Вызываем функцию обновления, передавая номер телефона и имя
                            // final result =
                            await funcs.updateInvestStatus(
                              phone: phone,
                              name: name,
                            );

                            // print("Updated invest data: $result");

                            // Закрываем диалог
                            Navigator.pop(context, true);
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
                              "Оставить заявку ",
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
                      top: 458 * scaleY, // (645 - 329) = 316
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
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
