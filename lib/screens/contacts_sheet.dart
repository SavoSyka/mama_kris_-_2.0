import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/utils/contacts_service.dart'; // <-- убедись, что есть такой файл
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

Future<void> showContactsSheet(BuildContext context, int contactId) async {
  final contactData = await ContactsService.fetchContacts(contactId);

  // Если не получили данные — показываем SnackBar
  if (contactData == null || contactData.isEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не удалось получить контактные данные')),
    );
    return;
  }

  if (!context.mounted) return;

  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  // Список ключей, по которым рендерим кнопки
  final List<String> contactKeys = [
    'telegram',
    'email',
    'phone',
    'whatsapp',
    'vk',
    'link',
  ];

  final List<String> nonNullKeys = contactKeys
      .where(
        (key) =>
            contactData[key] != null && contactData[key].toString().isNotEmpty,
      )
      .toList();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 329 * scaleY,
          left: 16 * scaleX,
          right: 16 * scaleX,
        ),
        child: Container(
          height: 627 * scaleY,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15 * scaleX),
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
                padding: EdgeInsets.symmetric(horizontal: 20 * scaleX),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    ...nonNullKeys.map((key) {
                      String platform;
                      String primaryText;
                      String secondaryText;
                      VoidCallback onPressedCallback;
                      switch (key) {
                        case 'telegram':
                          platform = "Telegram";
                          final String telegramValue = contactData['telegram']
                              .toString();
                          primaryText = telegramValue.startsWith('@')
                              ? telegramValue
                              : '@' + telegramValue;
                          secondaryText =
                              "Свяжитесь с заказчиком через Telegram";
                          onPressedCallback = () =>
                              onTelegramPressed(telegramValue, context);
                          break;

                        case 'whatsapp':
                          platform = "WhatsApp";
                          primaryText = contactData['whatsapp'].toString();
                          secondaryText =
                              "Свяжитесь с заказчиком через WhatsApp";
                          onPressedCallback = () => onWhatsAppPressed(
                            contactData['whatsapp'].toString(),
                            context,
                          );
                          break;
                        case 'email':
                          platform = "Email";
                          primaryText = contactData['email'].toString();
                          secondaryText = "Свяжитесь с заказчиком через Email";
                          onPressedCallback = () => onEmailPressed(
                            contactData['email'].toString(),
                            context,
                          );
                          break;
                        case 'phone':
                          platform = "Телефон";
                          primaryText = contactData['phone'].toString();
                          secondaryText = "Свяжитесь с заказчиком по телефону";
                          onPressedCallback = () => onPhonePressed(
                            contactData['phone'].toString(),
                            context,
                          );
                          break;
                        case 'vk':
                          platform = "VK";
                          primaryText = contactData['vk'].toString();
                          secondaryText = "Свяжитесь с заказчиком через VK";
                          onPressedCallback = () => onVKPressed(
                            contactData['vk'].toString(),
                            context,
                          );
                          break;
                        case 'link':
                          platform = "Ссылка";
                          primaryText = contactData['link'].toString();
                          secondaryText = "Заполните анкету по ссылке";
                          onPressedCallback = () => onLinkPressed(
                            contactData['link'].toString(),
                            context,
                          );
                          break;
                        default:
                          platform = key;
                          primaryText = contactData[key].toString();
                          secondaryText = "";
                          onPressedCallback = () {};
                      }
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
                            borderRadius: BorderRadius.circular(15 * scaleX),
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
                                    children: [
                                      Text(
                                        '$platform - $primaryText',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18 * scaleX,
                                          height: 28 / 18,
                                          letterSpacing: -0.18 * scaleX,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4 * scaleY),
                                      Text(
                                        '$secondaryText',
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14 * scaleX,
                                          height: 20 / 14,
                                          letterSpacing: -0.1 * scaleX,
                                          color: const Color(0xFF596574),
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
                    SizedBox(height: 20 * scaleY),
                    SizedBox(
                      width: 396 * scaleX,
                      height: 140 * scaleY,
                      child: Text(
                        "Дорогой исполнитель, Вы можете продолжить свой поиск. Возможно Вас заинтересуют еще и другие вакансии на удалёнке.\n"
                        "А данное объявление прямо сейчас отправится в раздел «мои заказы». И вы сможете связаться с работодателем чуть позже.",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          letterSpacing: -0.1 * scaleX,
                          color: const Color(0xFF596574),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 20 * scaleY),
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
                        onPressed: () => Navigator.pop(context),
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
                                'Продолжить поиск',
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
                  ],
                ),
              ),
            ),
          ),
        ),
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
