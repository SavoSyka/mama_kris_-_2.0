import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mama_kris/utils/vacancy_service.dart';
import 'package:mama_kris/screens/favorite_contacts_sheet.dart';

/// Запрашивает отзыв у пользователя, если функция In-App Review доступна.
Future<void> requestReview() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    // print("In-app review available. Requesting review...");
    await inAppReview.requestReview();
  } else {
    // print("In-app review is not available.");
  }
}

/// Показывает всплывающий диалог с предложением поделиться приложением.
void showShareContacts(BuildContext context, int jobId) async {
  final job = await VacancyService.fetchVacancyById(jobId);
  dynamic contacts; // или нужный тип, например Map<String, dynamic> или String
  if (job != null) {
    contacts = await fetchContactDetails(job['contactsID']);
  } else {
    contacts = '';
  }
  // print(contacts);
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ShareAppNotification",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20 * scaleY),
                    // Логотип внутри панели
                    SvgPicture.asset(
                      'assets/welcome_screen/logo.svg',
                      width: 263 * scaleX,
                      height: 263 * scaleY,
                    ),
                    SizedBox(height: 20 * scaleY),
                    // Заголовок
                    SizedBox(
                      width: 340 * scaleX,
                      child: Text(
                        'Понравилась эта вакансия?',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w700,
                          fontSize: 26 * scaleX,
                          height: 1.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20 * scaleY),
                    // Описание
                    SizedBox(
                      width: 340 * scaleX,
                      child: Text(
                        'Поделитесь ею с друзьями!',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 16 * scaleX,
                          height: 20 / 14,
                          color: const Color(0xFF596574),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40 * scaleY),
                    // Кнопка "Поделиться"
                    Container(
                      width: 396 * scaleX,
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
                          // print("Кнопка 'Поделиться' нажата");
                          if (job != null) {
                            String salary = '';
                            if (job['salary'].toString() == "0.00") {
                              salary = 'По договоренности';
                            } else {
                              salary = '${job['salary'].toString()} руб';
                            }
                            String contactData = '';
                            if (contacts != null && contacts != '') {
                              contactData = 'Контакты:\n';
                              if (contacts['telegram'] != null &&
                                  contacts['telegram'].toString().isNotEmpty) {
                                contactData +=
                                    'Telegram: @${contacts['telegram']}\n';
                              }
                              if (contacts['email'] != null &&
                                  contacts['email'].toString().isNotEmpty) {
                                contactData += 'Email: ${contacts['email']}\n';
                              }
                              if (contacts['phone'] != null &&
                                  contacts['phone'].toString().isNotEmpty) {
                                contactData +=
                                    'Телефон: ${contacts['phone']}\n';
                              }
                              if (contacts['whatsapp'] != null &&
                                  contacts['whatsapp'].toString().isNotEmpty) {
                                contactData +=
                                    'WhatsApp: ${contacts['whatsapp']}\n';
                              }
                              if (contacts['vk'] != null &&
                                  contacts['vk'].toString().isNotEmpty) {
                                contactData += 'VK: ${contacts['vk']}\n';
                              }
                              if (contacts['link'] != null &&
                                  contacts['link'].toString().isNotEmpty) {
                                contactData += 'Ссылка: ${contacts['link']}\n';
                              }
                            }

                            // if (contacts != null)
                            String shareText =
                                'Смотри какая вакансия попалась мне в MamaKris:\n'
                                '${job['title']} \n\n'
                                '${job['description']}\n\n'
                                'Цена: $salary \n\n';
                            shareText += contactData;
                            Share.share(shareText);
                            Navigator.of(context).pop(true);
                          } else {
                            const String androidLink =
                                'https://play.google.com/store/apps/details?id=com.mama.mama_kris';
                            const String iosLink =
                                'https://apps.apple.com/ru/app/mamakris';
                            const String shareText =
                                'Попробуйте приложение MamaKris для поиска вакансий на удаленке! '
                                'Скачайте его по ссылке: \n\n'
                                'Для Android: $androidLink\n'
                                'Для iPhone: $iosLink';
                            Share.share(shareText);
                            Navigator.of(context).pop(true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A80E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15 * scaleX),
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
                                'Поделиться',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18 * scaleX,
                                  height: 28 / 18,
                                  letterSpacing: -0.18 * scaleX,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10 * scaleX),
                            SvgPicture.asset(
                              'assets/welcome_screen/arrow.svg',
                              width: 32 * scaleX,
                              height: 32 * scaleY,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * scaleY),
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

void showShareAppNotification(BuildContext context, int viewedCount) {
  // Базовые размеры макета: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double scaleX = screenWidth / 428;
  final double scaleY = screenHeight / 956;

  showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ShareAppNotification",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20 * scaleY),
                    // Логотип внутри панели
                    SvgPicture.asset(
                      'assets/welcome_screen/logo.svg',
                      width: 263 * scaleX,
                      height: 263 * scaleY,
                    ),
                    SizedBox(height: 20 * scaleY),
                    // Заголовок
                    SizedBox(
                      width: 340 * scaleX,
                      child: Text(
                        'Вы просмотрели $viewedCount вакансий!',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w700,
                          fontSize: 26 * scaleX,
                          height: 1.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20 * scaleY),
                    // Описание
                    SizedBox(
                      width: 340 * scaleX,
                      child: Text(
                        'Поделитесь приложением с друзьями,\nчтобы они тоже могли найти\nинтересные вакансии.',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 16 * scaleX,
                          height: 20 / 14,
                          color: const Color(0xFF596574),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40 * scaleY),
                    // Кнопка "Поделиться"
                    Container(
                      width: 396 * scaleX,
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
                          // print("Кнопка 'Поделиться' нажата");
                          const String androidLink =
                              'https://play.google.com/store/apps/details?id=com.mama.mama_kris';
                          const String iosLink =
                              'https://apps.apple.com/ru/app/mamakris';
                          const String shareText =
                              'Попробуйте приложение MamaKris для поиска вакансий на удаленке! '
                              'Скачайте его по ссылке: \n\n'
                              'Для Android: $androidLink\n'
                              'Для iPhone: $iosLink';
                          Share.share(shareText);
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A80E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15 * scaleX),
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
                                'Поделиться',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18 * scaleX,
                                  height: 28 / 18,
                                  letterSpacing: -0.18 * scaleX,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10 * scaleX),
                            SvgPicture.asset(
                              'assets/welcome_screen/arrow.png',
                              width: 32 * scaleX,
                              height: 32 * scaleY,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * scaleY),
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
