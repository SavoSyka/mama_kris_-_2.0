import 'package:flutter/material.dart';
import 'package:mama_kris/screens/usage_screen.dart';
import 'package:mama_kris/widgets/next_button.dart';

/// Функция для показа модального окна "CareerSheet" – панели, выезжающей снизу,
/// с прокручиваемым содержимым.
void showUsageSheet(BuildContext context) {
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  /// Функция, которая вызывается при нажатии на основную кнопку.
  void onButtonPressed() {
    // print("Кнопка 'Узнать больше' нажата");
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, secondaryAnimation) => const UsageScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0); // справа
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  showGeneralDialog<bool>(
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
                // Прокручиваемое содержимое панели
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20 * scaleX),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40 * scaleY,
                      ), // Отступ сверху (369 - 329 = 40)
                      // Заголовок
                      SizedBox(
                        width: 300 * scaleX,
                        child: Text(
                          "Как пользоваться приложением?",
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
                      SizedBox(height: 20 * scaleY),
                      // Описание
                      Text(
                        "Добро пожаловать на платформу для поиска удалённых вакансий! Я, Кристина, автор идеи и руководитель проекта. С более чем 12-летним опытом работы онлайн, я создала эту платформу, чтобы упростить процесс поиска и размещения вакансий.\n\n"
                        "Роли в приложении:\n"
                        "• Исполнитель (ищет работу)\n"
                        "• Работодатель (размещает вакансии)\n\n"
                        "Как начать:\n"
                        "1. Нажмите кнопку «Исполнитель» и ответьте на вопросы для доступа к проверенным вакансиям.\n"
                        "2. Или нажмите кнопку «Работодатель», чтобы получить доступ к размещению вакансий\n"
                        "3. После лайка вакансии вы получите контакт работодателя, а вакансия переместится в раздел «Мои заказы» на 10 дней.\n\n"
                        "Внизу приложения находится панель с разделами:\n"
                        "• Главная: просмотр предложений о работе\n"
                        "• Мои заказы: вакансии с контактами работодателей\n"
                        "• Чат: техподдержка, реклама, полезные статьи, дополнительные услуги\n"
                        "• Профиль: редактирование анкеты, смена роли, управление подпиской\n\n"
                        "Рекомендуем откликаться на 30-50 вакансий в день для быстрого поиска работы. У нас на платформе собраны лучшие вакансии и задания для онлайн-заработка. Никогда еще поиск онлайн-работы не был таким простым и удобным!\n\n"
                        "Успехов в поиске!\n"
                        "С уважением, команда \"MamaKris\".",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          letterSpacing: -0.1 * scaleX,
                          color: const Color(0xFF596574),
                        ),
                      ),
                      SizedBox(height: 20 * scaleY),
                      // Кнопка "Узнать больше" – часть прокручиваемого контента
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                              onPressed: onButtonPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A80E),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15 * scaleX),
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
                                  "Узнать больше",
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
                          SizedBox(
                              width:
                                  10 * scaleX), // пространство между кнопками
                          PopButton(
                            scaleX: scaleX,
                            scaleY: scaleY,
                          ),
                        ],
                      ),

                      SizedBox(height: 50 * scaleY),
                    ],
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
