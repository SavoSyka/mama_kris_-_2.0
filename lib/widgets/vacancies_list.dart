import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/vacancies_banner.dart';
import 'package:mama_kris/utils/vacancy_service.dart';
import 'dart:ui';
// import 'dart:convert';
import 'package:mama_kris/screens/contacts_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/share_and_review.dart' as show;
import 'package:mama_kris/screens/first_alert_sheet.dart';

class VacanciesList extends StatefulWidget {
  const VacanciesList({super.key});

  @override
  _VacanciesListState createState() => _VacanciesListState();
}

class _VacanciesListState extends State<VacanciesList> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> vacancies = [];
  bool isLoading = false;
  int currentPage = 1;
  DateTime? _lastRequestTime;

  @override
  void initState() {
    super.initState();
    // debugPrint(
    //   "VacanciesList initState: Начинаем загрузку вакансий, currentPage = $currentPage",
    // );
    VacancyService.loadCachedVacanciesReduced().then((cached) {
      if (cached.isNotEmpty) {
        setState(() {
          vacancies = cached;
        });
      } else {
        _loadVacancies();
      }
    });
    // _loadVacancies();
    _scrollController.addListener(() {
      final now = DateTime.now();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          (_lastRequestTime == null ||
              now.difference(_lastRequestTime!).inMilliseconds > 1000)) {
        _lastRequestTime = now;
        _loadVacancies();
      }
    });
  }

  Future<void> _loadVacancies() async {
    setState(() {
      isLoading = true;
    });
    // debugPrint("Начинаем загрузку вакансий для страницы $currentPage");
    // Используем новый метод с кэшированием
    final newVacancies = await VacancyService.fetchVacanciesForListWithCache(
      page: currentPage,
    );
    // debugPrint(
    //   "Получено вакансий: ${newVacancies.length} для страницы $currentPage",
    // );

    setState(() {
      currentPage++;
      vacancies = newVacancies; // заменяем список на обновлённый из кэша
      isLoading = false;
    });

    // debugPrint(
    //   "Обновленный список вакансий содержит: ${vacancies.length} элементов",
    // );
  }

  void _onVacancyTap(Map<String, dynamic> vacancy) async {
    debugPrint("Нажата вакансия с jobID: ${vacancy['jobID']}");

    // Запрашиваем полные данные вакансии по её id
    final fullVacancy = await VacancyService.fetchVacancyById(vacancy['jobID']);
    if (fullVacancy == null) {
      // print(
      //   "Ошибка при загрузке полной информации вакансии с jobID: ${vacancy['jobID']}",
      // );
      return;
    }
    // print("Полная вакансия: $vacancy");

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    void onInterestedPressed() async {
      bool result = await VacancyService.likeVacancy(vacancy['jobID']);
      if (result) {
        // final jobID = vacancy['jobID'];
        // ContactsService.fetchContacts(contactsId)
        // final contactsID = vacancy['contactsID']; // Сохраняем ДО удаления
        final prefs = await SharedPreferences.getInstance();

        // 1. Увеличиваем счетчик просмотров
        int currentViewed = prefs.getInt('viewed_count') ?? 0;
        int newViewed = currentViewed + 1;
        await prefs.setInt('viewed_count', newViewed);
        // print("Просмотров: $newViewed");
        // Если достигнут один из порогов: 20, 120, 220, выполняем нужное действие
        // if (newViewed % 100 == 20) {
        //   print("Достигнут порог просмотренных вакансий: $newViewed");
        //   // Здесь можно, например, вызвать функцию показа уведомления о том, что можно поделиться приложением:
        //   show.showShareAppNotification(context, newViewed);
        // }

        int currentLiked = prefs.getInt('liked_count') ?? 0;
        int newLiked = currentLiked + 1;
        await prefs.setInt('liked_count', newLiked);
        // print("Лайков: $newLiked");
        if (newLiked % 100 == 7) {
          // print("Достигнут порог лайков: $newLiked");
          // Здесь можно вызвать функцию для запроса отзыва:
          await show.requestReview();
        }
        if (newViewed == 0) {
          // print("Достигнут порог лайков: $newLiked");
          // Здесь можно вызвать функцию для запроса отзыва:
          await showFirstAlertSheet(context);
        }
        // Показываем контакты работодателя
        // print(vacancy);
        await showContactsSheet(context, fullVacancy['contactsID']);

        // Удаляем вакансию из локального списка
        setState(() {
          vacancies.removeWhere((v) => v['jobID'] == vacancy['jobID']);
        });
        // Удаляем вакансию из кэша (чтобы порядок оставался постоянным при следующей загрузке)
        await VacancyService.removeFromReducedCache(vacancy['jobID']);
        Navigator.of(context).pop();
        // print(
        // 'Кнопка "Интересно" нажата для вакансии с jobID: ${vacancy['jobID']}. Vacancy removed.',
        // );
        // Запрашиваем обновлённый кэш вакансий
        final updatedVacancies =
            await VacancyService.loadCachedVacanciesReduced();
        // Если в кэше осталось мало вакансий, запрашиваем новый пакет
        if (updatedVacancies.length <= 5) {
          final appendedVacancies =
              await VacancyService.fetchVacanciesForListWithCache(
                page: currentPage,
              );
          setState(() {
            vacancies = appendedVacancies;
          });
        } else {
          setState(() {
            vacancies = updatedVacancies;
          });
        }
      } else {
        // print('Ошибка при лайке вакансии с jobID: ${vacancy['jobID']}');
      }
    }

    void onNotInterestedPressed() async {
      // Выполняем запрос дизлайка
      bool result = await VacancyService.dislikeVacancy(vacancy['jobID']);
      if (result) {
        // final jobID = vacancy['jobID'];
        // final contactsID = vacancy['contactsID']; // Сохраняем ДО удаления
        final prefs = await SharedPreferences.getInstance();

        // 1. Увеличиваем счетчик просмотров
        int currentViewed = prefs.getInt('viewed_count') ?? 0;
        int newViewed = currentViewed + 1;
        await prefs.setInt('viewed_count', newViewed);
        // print("Просмотров: $newViewed");
        // Если достигнут один из порогов: 20, 120, 220, выполняем нужное действие
        // if (newViewed > 0) {
        //   print("Достигнут порог просrмотренных вакансий: $newViewed");
        //   // Здесь можно, например, вызвать функцию показа уведомления о том, что можно поделиться приложением:
        //   show.showShareAppNotification(context, newViewed);
        // }

        if (newViewed == 0) {
          // print("Достигнут порог лайков: $newLiked");
          // Здесь можно вызвать функцию для запроса отзыва:
          await showFirstAlertSheet(context);
        }

        // Удаляем вакансию из локального списка
        setState(() {
          vacancies.removeWhere((v) => v['jobID'] == vacancy['jobID']);
        });
        // Удаляем вакансию из кэша (чтобы порядок оставался постоянным при следующей загрузке)
        await VacancyService.removeFromReducedCache(vacancy['jobID']);
        Navigator.of(context).pop();
        // print(
        //   'Кнопка "Неинтересно" нажата для вакансии с jobID: ${vacancy['jobID']}. Vacancy removed.',
        // );
        // Запрашиваем обновлённый кэш вакансий
        final updatedVacancies =
            await VacancyService.loadCachedVacanciesReduced();
        // Если в кэше осталось мало вакансий, запрашиваем новый пакет
        if (updatedVacancies.length <= 5) {
          final appendedVacancies =
              await VacancyService.fetchVacanciesForListWithCache(
                page: currentPage,
              );
          setState(() {
            vacancies = appendedVacancies;
          });
        } else {
          setState(() {
            vacancies = updatedVacancies;
          });
        }
      } else {
        // print('Ошибка при дизлайке вакансии с jobID: ${vacancy['jobID']}');
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'CustomDialog',
      barrierColor: Colors.white.withOpacity(0.5),
      pageBuilder:
          (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SafeArea(
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      top: 148 * scaleY,
                      left: 16 * scaleX,
                      child: Material(
                        borderRadius: BorderRadius.circular(15 * scaleX),
                        child: Container(
                          width: 395 * scaleX,
                          height: 540 * scaleY,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 455 * scaleY,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                    25 * scaleX,
                                    27 * scaleY,
                                    25 * scaleX,
                                    27 * scaleY,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${fullVacancy['title']}',
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18 * scaleX,
                                          height: 28 / 18,
                                          letterSpacing: -0.18 * scaleX,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 9 * scaleY),
                                      Container(
                                        width: 341 * scaleX,
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8 * scaleY,
                                          horizontal: 8 * scaleX,
                                        ),
                                        child: Text(
                                          '${fullVacancy['description']}',
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14 * scaleX,
                                            height: 20 / 14,
                                            letterSpacing: 0,
                                            color: const Color(0xFF596574),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10 * scaleY),
                                      Container(
                                        width: 341 * scaleX,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8 * scaleY,
                                          horizontal: 8 * scaleX,
                                        ),
                                        child: Text(
                                          fullVacancy['salary'].toString() ==
                                                  "0.00"
                                              ? "Цена: По договоренности"
                                              : "Цена: ${fullVacancy['salary']} руб",
                                          // 'Цена: ${fullVacancy['salary']} руб',
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16 * scaleX,
                                            height: 28 / 16,
                                            letterSpacing: -0.48 * scaleX,
                                            color: const Color(0xFF596574),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 468 * scaleY,
                                left: 206 * scaleX,
                                child: Container(
                                  width: 162.33 * scaleX,
                                  height: 44.78 * scaleY,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15 * scaleX,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFCFFFD1),
                                        offset: Offset(0, 4 * scaleY),
                                        blurRadius: 19 * scaleX,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: onInterestedPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00A80E),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15 * scaleX,
                                        ),
                                      ),
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      'Интересно',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Jost',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18 * scaleX,
                                        height: 28 / 18,
                                        letterSpacing: -0.54 * scaleX,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 468 * scaleY,
                                left: 26 * scaleX,
                                child: Container(
                                  width: 162.33 * scaleX,
                                  height: 44.78 * scaleY,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15 * scaleX,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x78E7E7E7),
                                        offset: Offset(0, 4 * scaleY),
                                        blurRadius: 19 * scaleX,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => onNotInterestedPressed(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15 * scaleX,
                                        ),
                                      ),
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      'Неинтересно',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Jost',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18 * scaleX,
                                        height: 28 / 18,
                                        letterSpacing: -0.54 * scaleX,
                                        color: const Color(0xFF596574),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: (148 + 540 + 10) * scaleY,
                      left: 16 * scaleX,
                      child: const VacanciesBanner(),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _buildVacancyItem(
    Map<String, dynamic> vacancy,
    double scaleX,
    double scaleY,
  ) {
    final String titleText = vacancy['title'] ?? '';
    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Jost',
      fontWeight: FontWeight.w600,
      fontSize: 18 * scaleX,
      height: 28 / 18,
      color: Colors.black,
      letterSpacing: -0.18 * scaleX,
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

    final double spacingBetween = lineCount > 1 ? 0 * scaleY : 8 * scaleY;
    final double topPadding = lineCount > 1 ? 8 * scaleY : 20 * scaleY;
    final double bottomPadding = lineCount > 1 ? 0 * scaleY : 18 * scaleY;

    return Padding(
      padding: EdgeInsets.only(bottom: 10 * scaleY),
      child: GestureDetector(
        onTap: () {
          // debugPrint("Tapped vacancy item with jobID: ${vacancy['jobID']}");
          _onVacancyTap(vacancy);
        },
        child: Container(
          width: containerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15 * scaleX),
            boxShadow: const [
              BoxShadow(
                color: Color(0x78E7E7E7),
                offset: Offset(0, 4),
                blurRadius: 19,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: topPadding,
            left: 22 * scaleX,
            right: 22 * scaleX,
            bottom: bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleText, style: titleStyle),
              SizedBox(height: spacingBetween),
              Text(
                vacancy['salary'] == "0.00"
                    ? "По договоренности"
                    : "Цена: ${vacancy['salary']} руб",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                  fontSize: 16 * scaleX,
                  color: const Color(0xFF596574),
                  height: 28 / 16,
                  letterSpacing: 0.48 * scaleX,
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
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
        ),
        borderRadius: BorderRadius.circular(16)

      ),
      child: ListView.builder(
        key: const PageStorageKey('vacancies_list'),
        controller: _scrollController,
        padding: EdgeInsets.zero,

        itemCount: vacancies.length + 1,
        itemBuilder: (context, index) {
          if (index < vacancies.length) {
            return Container(
              child: _buildVacancyItem(vacancies[index], scaleX, scaleY),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

}
