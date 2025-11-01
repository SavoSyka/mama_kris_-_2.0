import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'dart:convert';
import 'package:mama_kris/screens/order_screen.dart';
import 'package:mama_kris/constants/api_constants.dart';

void onVacancyPressed(BuildContext context, Map<String, dynamic> jobData) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderScreen(prefillData: jobData)),
  );
}

Future<List<Map<String, dynamic>>> fetchUserJobs() async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');
  int? userId = prefs.getInt('user_id');

  if (accessToken == null || userId == null) {
    throw Exception('Не найден accessToken или userId');
  }

  final response = await http.get(
    Uri.parse('${kBaseUrl}jobs/user/$userId'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  // print(json.decode(response.body));

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else if (response.statusCode == 401) {
    // Попытка обновить токен
    bool refreshed = await funcs.refreshAccessToken();
    if (refreshed) {
      // Повторный запрос
      final newToken = prefs.getString('auth_token');
      final retryResponse = await http.get(
        Uri.parse('${kBaseUrl}jobs/user/$userId'),
        headers: {'Authorization': 'Bearer $newToken'},
      );

      if (retryResponse.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(retryResponse.body));
      } else {
        throw Exception('Не удалось получить вакансии после обновления токена');
      }
    } else {
      throw Exception('Ошибка 401: Не удалось обновить токен');
    }
  } else {
    throw Exception('Ошибка при получении вакансий: ${response.statusCode}');
  }
}

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

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
          // Заголовок с SvgPicture
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
            future: fetchUserJobs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Ошибка загрузки'));
              }
              // Фильтрация: исключаем вакансии со статусом "rejected"
              // Фильтрация: исключаем вакансии со статусом "rejected"
              final filteredJobs = snapshot.data!;

              return Positioned.fill(
                top: 136 * scaleY,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    final jobStatus = job['status'];
                    String statusText;
                    switch (jobStatus) {
                      case "approved":
                        statusText = "Одобрено";
                        break;
                      case "rejected":
                        statusText = "Отклонено";
                        break;
                      case "checking":
                        statusText = "На проверке";
                        break;
                      case "archived":
                        statusText = "В архиве";
                        break;
                      case "unpaid":
                        statusText = "Не оплачено";
                        break;
                      default:
                        statusText = jobStatus;
                        break;
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 14 * scaleY,
                        left: 16 * scaleX,
                        right: 16 * scaleX,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // print("Открыта: ${job['title']}");
                        },
                        child: Container(
                          width: 395 * scaleX,
                          height: 178 * scaleY,
                          padding: EdgeInsets.fromLTRB(
                            25 * scaleX,
                            27 * scaleY,
                            25 * scaleX,
                            25 * scaleY,
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
                              Text(
                                job['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18 * scaleX,
                                  letterSpacing: -0.18 * scaleX,
                                  color: Colors.black,
                                  height: 28 / 18,
                                ),
                              ),
                              SizedBox(height: 4 * scaleY),
                              Text(
                                "Статус: $statusText",
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16 * scaleX,
                                  color: const Color(0xFF596574),
                                  height: 28 / 16,
                                  letterSpacing: 0 * scaleX,
                                ),
                              ),
                              SizedBox(height: 8 * scaleY),
                              // Кнопка "Редактировать"
                              Container(
                                width: 162.33 * scaleX,
                                height: 44.78 * scaleY,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF00A80E,
                                  ), // можно оставить ту же логику определения цвета, если требуется
                                  borderRadius: BorderRadius.circular(
                                    13 * scaleX,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFCFFFD1),
                                      offset: Offset(0, 4 * scaleY),
                                      blurRadius: 19 * scaleX,
                                    ),
                                  ], // и тень
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    onVacancyPressed(context, job);
                                    // Здесь можно добавить дополнительную логику, например, переход на экран редактирования
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00A80E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        13 * scaleX,
                                      ),
                                    ),
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Редактировать",
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
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
