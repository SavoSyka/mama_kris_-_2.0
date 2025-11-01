import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/widgets/delete_alert.dart';
import 'package:mama_kris/utils/vacancy_service.dart';

import 'package:mama_kris/utils/share_and_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

/// Функция для получения деталей контакта по его идентификатору через API
Future<Map<String, dynamic>?> fetchContactDetails(int contactsID) async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');
  int? userID = prefs.getInt('user_id');
  // print(
  // "fetchContactDetails: accessToken = $accessToken, contactsID = $contactsID",
  // );
  if (accessToken == null) {
    // print("fetchContactDetails: accessToken is null");
    return null;
  }
  final url = Uri.parse('${kBaseUrl}contacts/$userID/$contactsID');
  // print("fetchContactDetails: Request URL = $url");
  final headers = {'Authorization': 'Bearer $accessToken'};
  // print("fetchContactDetails: Request Headers = $headers");

  try {
    final response = await http.get(url, headers: headers);
    // print("fetchContactDetails: response.statusCode = ${response.statusCode}");
    // print("fetchContactDetails: response.body = ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print("fetchContactDetails: Decoded data = $data");
      return data; // Предполагаем, что data имеет тип Map<String, dynamic>
    } else if (response.statusCode == 401) {
      bool refreshed = await funcs.refreshAccessToken();
      // print("fetchContactDetails: token refreshed = $refreshed");
      if (refreshed) {
        return await fetchContactDetails(contactsID);
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception(
        'Failed to load contact details, status: ${response.statusCode}',
      );
    }
  } catch (e) {
    // print("fetchContactDetails error: $e");
    return null;
  }
}

/// Функция для обработки удаления вакансии из избранного.
/// Если предупреждение ещё не было показано (ключ "favorite_alert_shown" отсутствует или false),
/// функция вызывает диалог showDeleteAlert. После подтверждения вызывается API (VacancyService.dislikeVacancy)
/// и диалог закрывается с результатом true.
Future<bool> handleFavoriteDeletion(BuildContext context, int jobId) async {
  // print("handleFavoriteDeletion: jobId = $jobId");
  final prefs = await SharedPreferences.getInstance();
  final bool alertShown = prefs.getBool('favorite_alert_shown') ?? false;
  if (!alertShown) {
    // Показываем предупреждение через ваш AlertDialog (showDeleteAlert)
    await showDeleteAlert(context);
    // Записываем, что предупреждение уже было показано
    await prefs.setBool('favorite_alert_shown', true);
  }

  // Вызываем API для удаления вакансии (например, дизлайк)
  await VacancyService.dislikeVacancy(jobId);
  // Закрываем диалог и возвращаем результат (true)
  Navigator.pop(context, true);
  return true;
}

Future<void> handleShare(BuildContext context, int jobId) async {
  showShareContacts(context, jobId);
}

/// Показывает модальное окно с контактами, полученными по API по идентификатору контакта.
/// [contactsID] – идентификатор контакта, [jobId] – идентификатор вакансии (для удаления из избранного)
Future<bool?> showFavoriteContactsSheet(
  BuildContext context,
  int contactsID,
  int jobId,
  VoidCallback onReload,
) {
  // print("showFavoriteContactsSheet: Вызывается для contactsID = $contactsID");
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "FavoriteContactsSheet",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      // Получаем базовые размеры устройства (исходя из макета 428 x 956)
      final double screenWidth = MediaQuery.of(context).size.width;
      final double screenHeight = MediaQuery.of(context).size.height;
      double scaleX = screenWidth / 428;
      double scaleY = screenHeight / 956;
      // print("showFavoriteContactsSheet: scaleX = $scaleX, scaleY = $scaleY");

      return Material(
        type: MaterialType.transparency,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchContactDetails(contactsID),
          builder: (context, snapshot) {
            // print(
            // "FavoriteContactsSheet: FutureBuilder state = ${snapshot.connectionState}",
            // );
            if (snapshot.connectionState == ConnectionState.waiting) {
              // print("FavoriteContactsSheet: Загрузка контактов...");
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              // print(
              // "FavoriteContactsSheet: Ошибка или нет данных: ${snapshot.error}",
              // );
              return const Center(child: Text("Ошибка загрузки контактов"));
            }
            final contact = snapshot.data!;
            // print(
            // "FavoriteContactsSheet: Полученные данные контакта: $contact",
            // );

            // Список ключей для создания кнопок (исключая имя)
            final List<String> contactKeys = [
              'telegram',
              'email',
              'phone',
              'whatsapp',
              'vk',
              'link',
            ];
            // Отфильтровываем только те поля, у которых значение не null и не пустое
            final List<String> nonNullKeys = contactKeys
                .where(
                  (key) =>
                      contact[key] != null &&
                      contact[key].toString().isNotEmpty,
                )
                .toList();
            // print("FavoriteContactsSheet: nonNullKeys = $nonNullKeys");

            return Stack(
              children: [
                // Панель с контактами, выезжающая сверху
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
                    child: Padding(
                      padding: EdgeInsets.only(top: 40 * scaleY),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20 * scaleX,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Заголовок панели
                              Padding(
                                padding: EdgeInsets.only(right: 83 * scaleX),
                                child: SvgPicture.asset(
                                  'assets/favorite_contacts_sheet/title.svg',
                                  width: 273 * scaleX,
                                  height: 20 * scaleY,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 24 * scaleY),
                              // Динамически создаём кнопки для каждого заполненного поля контакта
                              ...nonNullKeys.map((key) {
                                String platform;
                                String primaryText;
                                String secondaryText;
                                VoidCallback onPressedCallback;
                                switch (key) {
                                  case 'telegram':
                                    platform = "Telegram";
                                    final String telegramValue =
                                        contact['telegram'].toString();
                                    primaryText = telegramValue.startsWith('@')
                                        ? telegramValue
                                        : '@$telegramValue';
                                    secondaryText =
                                        "Свяжитесь с заказчиком через Telegram";
                                    onPressedCallback = () => onTelegramPressed(
                                          telegramValue,
                                          context,
                                        );
                                    break;

                                  case 'whatsapp':
                                    platform = "WhatsApp";
                                    primaryText =
                                        contact['whatsapp'].toString();
                                    secondaryText =
                                        "Свяжитесь с заказчиком через WhatsApp";
                                    onPressedCallback = () => onWhatsAppPressed(
                                          contact['whatsapp'].toString(),
                                          context,
                                        );
                                    break;
                                  case 'email':
                                    platform = "Email";
                                    primaryText = contact['email'].toString();
                                    secondaryText =
                                        "Свяжитесь с заказчиком через Email";
                                    onPressedCallback = () => onEmailPressed(
                                          contact['email'].toString(),
                                          context,
                                        );
                                    break;
                                  case 'phone':
                                    platform = "Телефон";
                                    primaryText = contact['phone'].toString();
                                    secondaryText =
                                        "Свяжитесь с заказчиком по телефону";
                                    onPressedCallback = () => onPhonePressed(
                                          contact['phone'].toString(),
                                          context,
                                        );
                                    break;
                                  case 'vk':
                                    platform = "VK";
                                    primaryText = contact['vk'].toString();
                                    secondaryText =
                                        "Свяжитесь с заказчиком через VK";
                                    onPressedCallback = () => onVKPressed(
                                          contact['vk'].toString(),
                                          context,
                                        );
                                    break;
                                  case 'link':
                                    platform = "Ссылка";
                                    primaryText = contact['link'].toString();
                                    secondaryText =
                                        "Заполните анкету по ссылке";
                                    onPressedCallback = () => onLinkPressed(
                                          contact['link'].toString(),
                                          context,
                                        );
                                    break;
                                  default:
                                    platform = key;
                                    primaryText = contact[key].toString();
                                    secondaryText = "";
                                    onPressedCallback = () {};
                                }
                                // print(
                                // "FavoriteContactsSheet: Создаю кнопку для $platform с данными: $primaryText",
                                // );
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 20 * scaleY),
                                  child: Container(
                                    width: 357 * scaleX,
                                    height: 111 * scaleY,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x78E7E7E7),
                                          offset: Offset(0, 4 * scaleY),
                                          blurRadius: 19 * scaleX,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                        15 * scaleX,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: onPressedCallback,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15 * scaleX,
                                          ),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.fromLTRB(
                                          20 * scaleX,
                                          20 * scaleY,
                                          20 * scaleX,
                                          20 * scaleY,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "$platform - $primaryText",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Jost',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18 * scaleX,
                                                    height: 28 / 18,
                                                    letterSpacing:
                                                        -0.18 * scaleX,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 4 * scaleY),
                                                Text(
                                                  secondaryText,
                                                  style: TextStyle(
                                                    fontFamily: 'Jost',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14 * scaleX,
                                                    height: 20 / 14,
                                                    letterSpacing:
                                                        -0.1 * scaleX,
                                                    color: const Color(
                                                      0xFF596574,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 40 * scaleY),
                              // Ряд кнопок: star и share
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Кнопка star
                                  Container(
                                    width: 60 * scaleX,
                                    height: 60 * scaleY,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x78E7E7E7),
                                          offset: Offset(0, 4 * scaleY),
                                          blurRadius: 19 * scaleX,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                        15 * scaleX,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // print("star! jobId = $jobId");
                                        final result =
                                            await handleFavoriteDeletion(
                                          context,
                                          jobId,
                                        );
                                        if (result == true) {
                                          onReload();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15 * scaleX,
                                          ),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/favorite_contacts_sheet/favorite.svg',
                                          width: 29 * scaleX,
                                          height: 29 * scaleY,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20 * scaleX),
                                  // Кнопка share
                                  Container(
                                    width: 60 * scaleX,
                                    height: 60 * scaleY,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x78E7E7E7),
                                          offset: Offset(0, 4 * scaleY),
                                          blurRadius: 19 * scaleX,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                        15 * scaleX,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // print("share!");
                                        await handleShare(context, jobId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15 * scaleX,
                                          ),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/favorite_contacts_sheet/share.svg',
                                          width: 21 * scaleX,
                                          height: 29 * scaleY,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50 * scaleY),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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

/// Обработчик для Telegram
Future<void> onTelegramPressed(String value, BuildContext context) async {
  // print("Telegram pressed: $value");
  // Если перед именем стоит '@', удаляем его
  if (value.startsWith('@')) {
    value = value.substring(1);
  }
  final Uri url = Uri.parse('https://t.me/$value');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    // Копируем ссылку в буфер обмена
    await Clipboard.setData(ClipboardData(text: url.toString()));
    Navigator.pop(context);

    // Выводим SnackBar с сообщением
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось открыть Telegram. Ссылка скопирована в буфер обмена.",
        ),
      ),
    );
  }
}

/// Обработчик для WhatsApp
Future<void> onWhatsAppPressed(String value, BuildContext context) async {
  // print("WhatsApp pressed: $value");
  final Uri url = Uri.parse('https://wa.me/$value');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    await Clipboard.setData(ClipboardData(text: url.toString()));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось открыть WhatsApp. Ссылка скопирована в буфер обмена.",
        ),
      ),
    );
  }
}

/// Обработчик для Email
Future<void> onEmailPressed(String value, BuildContext context) async {
  // print("Email pressed: $value");
  final Uri emailUri = Uri(scheme: 'mailto', path: value);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    await Clipboard.setData(ClipboardData(text: emailUri.toString()));
    // Получаем корневой контекст для отображения SnackBar поверх диалога
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    Navigator.pop(context);
    ScaffoldMessenger.of(rootContext).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось открыть Email. Ссылка скопирована в буфер обмена.",
        ),
      ),
    );
  }
}

/// Обработчик для телефонного звонка
Future<void> onPhonePressed(String value, BuildContext context) async {
  // print("Phone pressed: $value");
  final Uri phoneUri = Uri(scheme: 'tel', path: value);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    await Clipboard.setData(ClipboardData(text: phoneUri.toString()));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось сделать звонок. Номер скопирован в буфер обмена.",
        ),
      ),
    );
  }
}

/// Обработчик для VK
Future<void> onVKPressed(String value, BuildContext context) async {
  // print("VK pressed: $value");
  if (value.startsWith('@')) {
    value = value.substring(1);
  }
  final Uri url = Uri.parse('https://vk.com/$value');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    await Clipboard.setData(ClipboardData(text: url.toString()));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось открыть VK. Ссылка скопирована в буфер обмена.",
        ),
      ),
    );
  }
}

/// Обработчик для произвольной ссылки
Future<void> onLinkPressed(String value, BuildContext context) async {
  // print("Link pressed: $value");
  if (!value.startsWith('http://') && !value.startsWith('https://')) {
    value = 'https://$value';
  }
  final Uri url = Uri.parse(value);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    await Clipboard.setData(ClipboardData(text: url.toString()));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Не удалось открыть ссылку. Ссылка скопирована в буфер обмена.",
        ),
      ),
    );
  }
}
