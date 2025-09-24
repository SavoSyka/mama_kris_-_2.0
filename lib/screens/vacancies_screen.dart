import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/widgets/vacancies_slider.dart';
import 'package:mama_kris/widgets/vacancies_banner.dart';
import 'package:mama_kris/screens/contacts_sheet.dart';
import 'package:mama_kris/widgets/vacancies_list.dart';
import 'package:mama_kris/utils/vacancy_service.dart';
import 'package:mama_kris/widgets/no_more_vacancies_card.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/screens/first_alert_sheet.dart';

import 'package:mama_kris/utils/share_and_review.dart' as show;

int slideDirection = -1;
int selectedMode = 0; // 0 - Слайдер, 1 - Список
int currentVacancyIndex = 0;
int previousVacancyIndex = 0; // добавляем предыдущий индекс
List<Map<String, dynamic>>? vacancies;

class VacanciesScreen extends StatefulWidget {
  const VacanciesScreen({super.key});

  @override
  _VacanciesScreenState createState() => _VacanciesScreenState();
}

class _VacanciesScreenState extends State<VacanciesScreen> {
  int selectedMode = 0; // 0 - Слайдер, 1 - Список
  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1; // -1 для «Интересно», +1 для «Неинтересно»
  List<Map<String, dynamic>>? vacancies;

  @override
  void initState() {
    super.initState();
    _loadInitialVacancies();
  }

  Future<void> _loadInitialVacancies() async {
    final cached = await VacancyService.loadCachedVacancies();
    if (cached.isNotEmpty) {
      setState(() {
        vacancies = cached;
      });
    } else {
      final fresh = await VacancyService.fetchVacancies();
      setState(() {
        vacancies = fresh;
      });
    }
  }

  Future<void> _handleVacancyReaction({required bool isLiked}) async {
    if (vacancies == null || vacancies!.isEmpty) return;

    final job = vacancies![currentVacancyIndex];
    final jobID = job['jobID'];
    final contactsID = job['contactsID']; // Сохраняем ДО удаления
    final prefs = await SharedPreferences.getInstance();

    // 1. Увеличиваем счетчик просмотров
    int currentViewed = prefs.getInt('viewed_count') ?? 0;
    int newViewed = currentViewed + 1;
    await prefs.setInt('viewed_count', newViewed);
    // print("Просмотров: $newViewed");
    // Если достигнут один из порогов: 20, 120, 220, выполняем нужное действие
    if (newViewed % 100 == 20) {
      // print("Достигнут порог просмотренных вакансий: $newViewed");
      // Здесь можно, например, вызвать функцию показа уведомления о том, что можно поделиться приложением:
      show.showShareAppNotification(context, newViewed);
    }
    if (newViewed == 0) {
      // print("Достигнут порог лайков: $newLiked");
      // Здесь можно вызвать функцию для запроса отзыва:
      await showFirstAlertSheet(context);
    }

    // 2. Отправляем реакцию
    final success = isLiked
        ? await VacancyService.likeVacancy(jobID)
        : await VacancyService.dislikeVacancy(jobID);

    if (!success) {
      final error =
          VacancyService.getLastErrorMessage() ?? 'Неизвестная ошибка';
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❗ $error')));
      return;
    }

    // 3. Если поставлен лайк, увеличиваем счетчик лайков и, если достигнут порог 7, выполняем действие
    if (isLiked && mounted) {
      int currentLiked = prefs.getInt('liked_count') ?? 0;
      int newLiked = currentLiked + 1;
      await prefs.setInt('liked_count', newLiked);
      // print("Лайков: $newLiked");
      if (newLiked % 100 == 7) {
        // print("Достигнут порог лайков: $newLiked");
        // Здесь можно вызвать функцию для запроса отзыва:
        await show.requestReview();
      }

      // Показываем контакты работодателя
      await showContactsSheet(context, contactsID);
    }

    // Выводим текущие значения счетчиков
    // print("Просмотров после реакции: ${prefs.getInt('viewed_count')}");
    // print("Лайков после реакции: ${prefs.getInt('liked_count')}");

    // 4. Удаляем вакансию из кэша
    await VacancyService.removeFromCache(jobID);

    // 5. Загружаем обновленный кэш вакансий и, если вакансий мало, запрашиваем новый пакет
    final updated = await VacancyService.loadCachedVacancies();
    if (updated.length <= 2) {
      final appended = await VacancyService.fetchVacancies(append: true);
      vacancies = appended;
    } else {
      vacancies = updated;
    }

    // 6. Обновляем индексы для показа следующей вакансии
    if (!mounted) return;
    setState(() {
      previousVacancyIndex = currentVacancyIndex;
      slideDirection = isLiked ? -1 : 1;

      if (vacancies!.isEmpty) {
        currentVacancyIndex = 0;
      } else {
        currentVacancyIndex = (currentVacancyIndex + 1) % vacancies!.length;
      }

      // print(
      // "Updated indexes: previousVacancyIndex = $previousVacancyIndex, "
      // "new currentJobIndex = $currentVacancyIndex, "
      // "slideDirection = $slideDirection",
      // );
    });

    // debugPrint(
    // '[${isLiked ? 'LIKE' : 'DISLIKE'}] Remaining jobIDs in cache: '
    // '${vacancies!.map((e) => e['jobID']).toList()}',
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Если вакансии ещё не загружены, показываем индикатор загрузки
    if (vacancies == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    // Безопасно проверяем индекс
    if (currentVacancyIndex >= vacancies!.length && vacancies!.isNotEmpty) {
      currentVacancyIndex = 0;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Заголовок (title.svg)
          Positioned(
            top: 75 * scaleY,
            left: 16 * scaleX,
            child: SvgPicture.asset(
              'assets/vacancies_screen/title.svg',
              width: 121 * scaleX,
              height: 25 * scaleY,
              fit: BoxFit.contain,
            ),
          ),

          // Зеленый блюр (фон)
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

          // Переключатель режимов "Слайдер" и "Список"
          Positioned(
            top: 136 * scaleY,
            left: 16 * scaleX,
            child: Container(
              width: 108 * scaleX,
              height: 40 * scaleY,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: selectedMode == 0
                        ? const Color(0xFFCFFFD1)
                        : const Color(0x78E7E7E7),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                  ),
                ],
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMode = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMode == 0
                      ? const Color(0xFF00A80E)
                      : const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    vertical: 6 * scaleY,
                    horizontal: 8 * scaleX,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      selectedMode == 0
                          ? 'assets/vacancies_screen/active.png'
                          : 'assets/vacancies_screen/inactive.png',
                      width: 16 * scaleX,
                      height: 16 * scaleY,
                    ),
                    SizedBox(width: 6 * scaleX),
                    Expanded(
                      child: Text(
                        'Слайдер',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w700,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          color: selectedMode == 0
                              ? Colors.white
                              : const Color(0xFF596574),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 136 * scaleY,
            left: 141 * scaleX,
            child: Container(
              width: 108 * scaleX,
              height: 40 * scaleY,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: selectedMode == 1
                        ? const Color(0xFFCFFFD1)
                        : const Color(0x78E7E7E7),
                    offset: Offset(0, 4 * scaleY),
                    blurRadius: 19 * scaleX,
                  ),
                ],
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMode = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMode == 1
                      ? const Color(0xFF00A80E)
                      : const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    vertical: 6 * scaleY,
                    horizontal: 8 * scaleX,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      selectedMode == 1
                          ? 'assets/vacancies_screen/active.png'
                          : 'assets/vacancies_screen/inactive.png',
                      width: 16 * scaleX,
                      height: 16 * scaleY,
                    ),
                    SizedBox(width: 6 * scaleX),
                    Expanded(
                      child: Text(
                        'Список',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w700,
                          fontSize: 14 * scaleX,
                          height: 20 / 14,
                          color: selectedMode == 1
                              ? Colors.white
                              : const Color(0xFF596574),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======= Режим "Слайдер" =======
          if (selectedMode == 0)
            Positioned(
              top: 196 * scaleY,
              left: 16 * scaleX,
              child: SizedBox(
                width: 395 * scaleX,
                height: 540 * scaleY,
                // Без AnimatedSwitcher здесь — карточка не пересоздаётся
                child: vacancies!.isEmpty
                    ? NoMoreVacanciesCard(
                        onGoToProfile: () {
                          debugPrint("pressed");
                          context.goNamed(
                            RouteName.applicantHome,
                            extra: {'page': 3},
                          );
                          debugPrint("pressed after");


                          // Navigator.of(context).pushAndRemoveUntil(
                          //   PageRouteBuilder(
                          //     transitionDuration: const Duration(
                          //       milliseconds: 300,
                          //     ),
                          //     pageBuilder: (_, animation, __) =>
                          //         const MainScreen(initialIndex: 3),
                          //     transitionsBuilder: (_, animation, __, child) {
                          //       final tween = Tween(
                          //         begin: const Offset(1.0, 0.0),
                          //         end: Offset.zero,
                          //       ).chain(CurveTween(curve: Curves.easeInOut));
                          //       return SlideTransition(
                          //         position: animation.drive(tween),
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          //   (_) => false,
                          // );
                        },
                      )
                    : VacanciesSlider(
                        vacancy: vacancies![currentVacancyIndex],
                        vacancyIndex: currentVacancyIndex,
                        previousVacancyIndex: previousVacancyIndex,
                        slideDirection: slideDirection,
                        onInterestedPressed: () {
                          // print(
                          // "onInterestedPressed pressed. currentVacancyIndex = $currentVacancyIndex",
                          // );
                          _handleVacancyReaction(isLiked: true);
                        },
                        onNotInterestedPressed: () {
                          // print(
                          // "onNotInterestedPressed pressed. currentVacancyIndex = $currentVacancyIndex",
                          // );
                          _handleVacancyReaction(isLiked: false);
                        },
                      ),
              ),
            ),

          // ======= Режим "Список" =======
          /*
          else


            Positioned(
              top: 196 * scaleY,
              left: 16 * scaleX,
              right: 16 * scaleX,
              bottom: 0, // гарантируем ограниченную высоту
              child: Container(child: const VacanciesList()),
            ),

          // Рекламный баннер (показывается только в режиме "Слайдер")
          if (selectedMode == 0)
            Positioned(
              top: (196 + 540 + 20) * scaleY,
              // top: 688 * scaleY,
              left: 16 * scaleX,
              child: const VacanciesBanner(),
            ),
    */
        ],
      ),
    );
  }
}
