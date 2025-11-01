import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/banners_sheet.dart';
import 'package:mama_kris/screens/usage_sheet.dart';
import 'package:mama_kris/screens/scammers_sheet.dart';
import 'package:mama_kris/screens/career_sheet.dart';
import 'package:mama_kris/screens/psycho_sheet.dart';
import 'package:mama_kris/screens/investors_sheet.dart';

import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // =======================
  // ОБРАБОТЧИКИ КНОПОК
  // =======================

  void _onAboutAdsPressed(BuildContext context) {
    showBannersSheet(context);
  }

  void _onInvestorsPressed(BuildContext context) {
    showInvestorsSheet(context);

    // TODO: Реализовать переход
  }

  void _onHowToUsePressed(BuildContext context) {
    showUsageSheet(context);
    // TODO: Реализовать переход
  }

  void _onHowToAvoidScammersPressed(BuildContext context) {
    showScammersSheet(context);
    // TODO: Реализовать переход
  }

  void _onCareerConsultantPressed(BuildContext context) {
    showCareerSheet(context);
    // TODO: Реализовать переход
  }

  void _onPsychSupportPressed(BuildContext context) {
    showPsychoSheet(context);
    // TODO: Реализовать переход
  }

  void _onWriteUsPressed(BuildContext context) async {
    final telegramUrl = Uri.encodeFull('https://t.me/MamaKris_support_bot');

    final uri = Uri.parse(telegramUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть Telegram')),
      );
    }
  }

  void _onChatIconTapped(BuildContext context) async {
    const telegramUrl = 'https://t.me/MamaKris_support_bot';

    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(
        Uri.parse(telegramUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть Telegram')),
      );
    }
  }

  // =========================
  // САМ ВИЗУАЛЬНЫЙ БЛОК
  // =========================

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    // Вспомогательная функция для повторяющихся кнопок
    Widget buildButton({
      required String text,
      required VoidCallback onPressed,
      required double top,
    }) {
      return Positioned(
        top: top * scaleY,
        left: 16 * scaleX,
        child: Container(
          width: 396 * scaleX,
          height: 72 * scaleY,
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
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: 20 * scaleY,
                horizontal: 20 * scaleX,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      fontSize: 18 * scaleX,
                      height: 28 / 18,
                      letterSpacing: -0.18 * scaleX,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10 * scaleX),
                SvgPicture.asset(
                  'assets/welcome_screen/arrow_green.svg',
                  width: 32 * scaleX,
                  height: 32 * scaleY,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Блюр‑фон
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
          // Заголовок
          Positioned(
            top: 75 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/chat/title.svg',
              width: 213 * scaleX,
              height: 21 * scaleY,
            ),
          ),
          // Иконка чата
          Positioned(
            top: 84 * scaleY,
            left: 391 * scaleX,
            child: GestureDetector(
              onTap: () => _onChatIconTapped(context),
              child: SvgPicture.asset(
                'assets/chat/chat.svg',
                width: 21 * scaleX,
                height: 21 * scaleY,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Кнопки
          buildButton(
            text: 'О рекламе в приложении',
            onPressed: () => _onAboutAdsPressed(context),
            top: 136,
          ),
          buildButton(
            text: 'Инвесторам',
            onPressed: () => _onInvestorsPressed(context),
            top: 228,
          ),
          buildButton(
            text: 'Как пользоваться приложением?',
            onPressed: () => _onHowToUsePressed(context),
            top: 320,
          ),
          buildButton(
            text: 'Как защититься от мошенников?',
            onPressed: () => _onHowToAvoidScammersPressed(context),
            top: 412,
          ),
          buildButton(
            text: 'Карьерный консультант',
            onPressed: () => _onCareerConsultantPressed(context),
            top: 504,
          ),
          buildButton(
            text: 'Психологическая поддержка',
            onPressed: () => _onPsychSupportPressed(context),
            top: 596,
          ),
          buildButton(
            text: 'Напишите нам',
            onPressed: () => _onWriteUsPressed(context),
            top: 688,
          ),
        ],
      ),
    );
  }
}
