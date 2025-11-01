import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/screens/banners_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class VacanciesBanner extends StatelessWidget {
  const VacanciesBanner({super.key});

  // Получаем URL рекламного изображения из кэша
  Future<String?> _getAdvImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('adv_image_url');
  }

  @override
  Widget build(BuildContext context) {
    // Размеры и коэффициенты масштабирования (по макету 428x956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    return FutureBuilder<String?>(
      future: _getAdvImageUrl(),
      builder: (context, snapshot) {
        // Если данные ещё загружаются, произошла ошибка или URL пустой – показываем кнопку
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return _buildButton(context, scaleX, scaleY);
        } else {
          final imageUrl = snapshot.data!;
          return GestureDetector(
            onTap: () async {
              // print("Рекламное изображение нажато");
              final prefs = await SharedPreferences.getInstance();
              final advLink = prefs.getString('adv_link');
              // print("adv_link = $advLink");
              if (advLink != null && advLink.isNotEmpty) {
                if (await canLaunch(advLink)) {
                  await launch(advLink);
                  // print("Переход по ссылке выполнен: $advLink");
                } else {
                  // print("Невозможно открыть ссылку: $advLink");
                }
              } else {
                // print("Ссылка не найдена в кэше");
              }
            },
            child: Container(
              width: 395 * scaleX,
              height: 97 * scaleY,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(15 * scaleX),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x78E7E7E7),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15 * scaleX),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Если изображение не загрузилось — показываем кнопку
                    return _buildButton(context, scaleX, scaleY);
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// Возвращает кнопку с тем же оформлением и размерами
  Widget _buildButton(BuildContext context, double scaleX, double scaleY) {
    return ElevatedButton(
      onPressed: () {
        showBannersSheet(context);
        // print("Кнопка 'Реклама' нажата");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15 * scaleX),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: 395 * scaleX,
        height: 97 * scaleY,
        alignment: Alignment.center,
        child: Text(
          "Здесь может быть ваша реклама!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w600,
            fontSize: 20 * scaleX,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
