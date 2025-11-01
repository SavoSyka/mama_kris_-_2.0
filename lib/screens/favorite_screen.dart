// import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/favorite_contacts_sheet.dart';
import 'package:mama_kris/utils/favorite_service.dart';
import 'package:mama_kris/widgets/vacancy_dialog.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _reloadFavorites();
  }

  void _reloadFavorites() {
    setState(() {
      _favoritesFuture = FavoriteService.getApprovedJobs();
    });
  }

  /// Функция для обработки нажатия на вакансию (открытие контактов)
  void onVacancyPressed(BuildContext context, int contactsID, int jobId) {
    // print("onVacancyPressed: Нажата вакансия, открываю контакты");
    showFavoriteContactsSheet(context, contactsID, jobId, () {
      setState(() {
        _reloadFavorites();
      });
    });
  }

  Widget _buildFavoriteVacancyItem(
    BuildContext context,
    Map<String, dynamic> job,
    double scaleX,
    double scaleY,
  ) {
    final String titleText = job['title'] ?? 'Без названия';
    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Jost',
      fontWeight: FontWeight.w600,
      fontSize: 18 * scaleX,
      height: 28 / 18,
      letterSpacing: -0.18 * scaleX,
      color: Colors.black,
    );
    final double containerWidth = (428 - 32) * scaleX;
    final double horizontalPadding = 22 * scaleX * 2;
    final double availableWidth = containerWidth - horizontalPadding;

    final TextSpan textSpan = TextSpan(text: titleText, style: titleStyle);
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: availableWidth);
    final int lineCount = textPainter.computeLineMetrics().length;

    final double spacingBetween = lineCount > 1 ? 2 * scaleY : 8 * scaleY;
    final double topPadding = lineCount > 1 ? 10 * scaleY : 20 * scaleY;
    final double bottomPadding = lineCount > 1 ? 0 * scaleY : 18 * scaleY;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 20 * scaleY,
        left: 16 * scaleX,
        right: 16 * scaleX,
      ),
      child: GestureDetector(
        onTap: () {
          // print("Открыта вакансия: ${job['title']}");
          showVacancyDialog(context, job);
        },
        child: Container(
          width: containerWidth,
          height: 178 * scaleY,
          padding: EdgeInsets.fromLTRB(
            25 * scaleX,
            topPadding,
            25 * scaleX,
            bottomPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15 * scaleX),
            boxShadow: [
              BoxShadow(
                color: const Color(0x78E7E7E7),
                offset: Offset(0, 4 * scaleY),
                blurRadius: 19 * scaleX,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle),
              SizedBox(height: spacingBetween),
              Text(
                job['salary'] == "0.00"
                    ? "По договоренности"
                    : "Цена: ${job['salary']} руб",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                  fontSize: 16 * scaleX,
                  color: const Color(0xFF596574),
                  height: 28 / 16,
                  letterSpacing: 0.48 * scaleX,
                ),
              ),
              SizedBox(height: 8 * scaleY),
              Container(
                width: 162.33 * scaleX,
                height: 44.78 * scaleY,
                decoration: BoxDecoration(
                  color: job['status'] == "archived"
                      ? const Color(0xFF979AA0)
                      : const Color(0xFF00A80E),
                  borderRadius: BorderRadius.circular(13 * scaleX),
                  boxShadow: job['status'] == "archived"
                      ? []
                      : [
                          BoxShadow(
                            color: const Color(0xFFCFFFD1),
                            offset: Offset(0, 4 * scaleY),
                            blurRadius: 19 * scaleX,
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // print(
                    // "Кнопка 'Контакты' нажата для вакансии: ${job['title']}",
                    // );
                    onVacancyPressed(context, job['contactsID'], job['jobID']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: job['status'] == "archived"
                        ? const Color(0xFF979AA0)
                        : const Color(0xFF00A80E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13 * scaleX),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Center(
                    child: Text(
                      "Контакты",
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Фон с ShaderMask
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
          // Заголовок (SVG-изображение)
          Positioned(
            top: 75 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/favorite_screen/title.svg',
              width: 153 * scaleX,
              height: 21 * scaleY,
              fit: BoxFit.cover,
            ),
          ),
          // Список вакансий
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // print("FavoriteScreen: snapshot.hasError: ${snapshot.error}");
                return const Center(child: Text('Ошибка загрузки'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                // print("FavoriteScreen: Нет одобренных вакансий");
                return Center(
                  child: Text(
                    "Нет понравившихся вакансий",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      fontSize: 18 * scaleX,
                      height: 28 / 18,
                      letterSpacing: -0.18 * scaleX,
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return Positioned(
                  top: 136 * scaleY,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final job = snapshot.data![index];
                      return _buildFavoriteVacancyItem(
                        context,
                        job,
                        scaleX,
                        scaleY,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
