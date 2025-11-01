import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // добавьте этот импорт
import 'package:flutter_svg/flutter_svg.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool careerChecked = false;
  bool psychoChecked = false;

  /// Функция обновления: определяет URL для магазина в зависимости от платформы,
  /// выводит отладочную информацию, и пытается запустить URL.
  void _onUpdatePressed(BuildContext context) async {
    // print("Кнопка 'Обновить' нажата");

    // Задаём URL для iOS и Android
    const String appStoreUrl =
        "https://apps.apple.com/gb/app/mamakris/id6479370258";
    const String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.mama.mama_kris";

    // Определяем URL в зависимости от платформы
    final String url = Theme.of(context).platform == TargetPlatform.iOS
        ? appStoreUrl
        : playStoreUrl;
    // print("Определён URL для обновления: $url");

    // Отладочная информация перед попыткой запуска URL
    if (await canLaunch(url)) {
      // print("canLaunch вернул true, запускаем URL...");
      await launch(url);
      // print("URL запущен: $url");
    } else {
      // print("Не удалось запустить URL: $url");
      // Здесь можно добавить отображение ошибки через SnackBar, если нужно.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не удалось открыть ссылку для обновления.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Рассчитываем коэффициенты масштабирования от базового макета (428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Фон с blur из welcome_screen
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
          Positioned(
            top: 350 * scaleY,
            left: 32 * scaleX,
            child: SizedBox(
              width: 395 * scaleX,
              child: Text(
                'Доступна новая версия приложения',
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
            top: 420 * scaleY,
            left: 32 * scaleX,
            child: SizedBox(
              width: 396 * scaleX,
              child: Text(
                'Пожалуйста, обновите приложение\nдля продолжения использования.',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w400,
                  fontSize: 18 * scaleX,
                  height: 20 / 14,
                  letterSpacing: -0.1 * scaleX,
                  color: const Color(0xFF596574),
                ),
              ),
            ),
          ),
          // Логотип из welcome_screen
          Positioned(
            top: 49 * scaleY,
            left: 83 * scaleX,
            child: SvgPicture.asset(
              'assets/welcome_screen/logo.svg',
              width: 263 * scaleX,
              height: 263 * scaleY,
            ),
          ),
          Positioned(
            top: 785 * scaleY,
            left: 16 * scaleX,
            child: Container(
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
                onPressed: () => _onUpdatePressed(context),
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
                        'Обновить',
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
          ),
        ],
      ),
    );
  }
}
