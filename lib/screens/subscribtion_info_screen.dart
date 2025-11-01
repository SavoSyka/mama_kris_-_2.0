import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SubscribtionInfoScreen extends StatelessWidget {
  const SubscribtionInfoScreen({super.key});

  // Функция для получения информации о подписке
  Future<Map<String, dynamic>?> fetchSubscriptionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    await initializeDateFormatting('ru_RU', null);

    // Используем фиксированный id, например 26, как в вашем запросе
    final url = Uri.parse(
      '${kBaseUrl}payments.v2/subscription-info/$userId',
    );
    final response = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Коэффициенты масштабирования по базовому макету (428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Фон с blur (аналог из welcome_screen)
          Positioned(
            top: 108 * scaleY,
            left: 0,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                width: 428 * scaleX,
                height: 195 * scaleY,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFFFD1).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20 * scaleX),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20 * scaleX),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 83, sigmaY: 83),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
          // Логотип
          Positioned(
            top: 49 * scaleY,
            left: 83 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/logo.svg',
              width: 263 * scaleX,
              height: 263 * scaleY,
            ),
          ),
          // Надпись о подписке
          Positioned(
            top: 350 * scaleY,
            left: 16 * scaleX,
            right: 16 * scaleX,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: fetchSubscriptionInfo(),
              builder: (context, snapshot) {
                String text = '';
                TextStyle style;
                // Если ждём ответа, не отображаем ничего
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  final subInfo = snapshot.data!;
                  if (subInfo['hasSubscription'] == true) {
                    if (subInfo['expiresAt'] != null) {
                      final rawDate = subInfo['expiresAt']; // "2026-04-10T12:37:16.000Z"
                      final parsedDate = DateTime.parse(rawDate).toLocal();
                      final formattedDate = DateFormat('d MMMM y \'года\'', 'ru_RU').format(parsedDate);

                      text = 'Ваша подписка истекает:\n$formattedDate';

                      // Стиль для даты подписки
                      style = TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w700,
                        fontSize: 26 * scaleX,
                        height: 20 / 14,
                        letterSpacing: -0.1 * scaleX,
                        color: const Color(0xFF596574),
                      );
                    } else {
                      text = 'У вас активная подписка';
                      // Стиль для активной подписки без даты
                      style = TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w700,
                        fontSize: 26 * scaleX,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.black,
                      );
                    }
                  } else {
                    text = 'У вас нет активной подписки';
                    // Стиль для отсутствующей подписки
                    style = TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w700,
                      fontSize: 26 * scaleX,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    );
                  }
                } else {
                  text = 'Ошибка получения информации о подписке';
                  style = TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w700,
                    fontSize: 26 * scaleX,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.black,
                  );
                }
                return Text(text, textAlign: TextAlign.center, style: style);
              },
            ),
          ),

          // Кнопка "Далее"
          Positioned(
            top: 787 * scaleY,
            left: 32 * scaleX,
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
                        'Продолжить',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w600,
                          fontSize: 20 * scaleX,
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
          ),
        ],
      ),
    );
  }
}
