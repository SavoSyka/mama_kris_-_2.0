import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_detail_screen.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

final List<Map<String, dynamic>> supports = [
  {
    'title': 'Как пользоваться приложением?',
    'salary': 'Ссылка',
    'isTelegram': false,
    'routeName': RouteName.articleOne,
  },
  {
    'title': 'Как защититься от мошенников',
    'salary': 'Ссылка',
    'isTelegram': false,
    'routeName': RouteName.articleTwo,
  },
  {
    'title': 'AI (ИИ)- карьерный консультант',
    'salary': 'Ссылка',
    'isTelegram': false,
    'hasButton': true,
    'routeName': RouteName.articleThree,

    "buttonText": "Запустить консультанцию",
    "buttonLink": "https://recruiter.mamakris.ru/",
  },
  /*
  {
    'title': 'Психологическая поддержка',
    'salary': 'Ссылка',
    'isTelegram': false,
    'hasButton': true,
    "buttonText": "Оставить заявку",
    "buttonLink": "https://t.me/mamakrisSupport_bot",

    "article": '''
Платформой «MamaKris» чаще всего пользуются женщины в декрете, люди с ограниченными возможностями, пенсионеры, студенты и фрилансеры. Поэтому мы внедрили эту услугу. Психологическая сессия будет полезна:

Мамам в декрете (или после декрета): Помощь в определении целей, преодолении чувства одиночества и снижении самооценки, связанных с ограниченным кругом общения и фокусом на ребенке.

Новичкам в мире онлайна (фрилансерам): Поддержка в преодолении страха перед переходом в онлайн

Пенсионерам: Помощь в адаптации к новой роли после выхода на пенсию, поиске новых смыслов жизни и освоении возможностей онлайн-мира.

Лицам с ограниченными возможностями: Поддержка в преодолении дискриминации при поиске работы, развитии уверенности в себе и противостоянии предрассудкам работодателей.

''',
  },
*/
  {
    'title': 'Сообщество мам в Telegram',
    'salary': 'Ссылка',
    'isTelegram': true,
    'channel': 'https://t.me/it_mamakris',
  },

  {
    'title': 'Техподдержка',
    'salary': 'Ссылка',
    'isTelegram': true,
    'channel': 'https://t.me/mamakrisSupport_bot',
  },
];

class ApplSupportScreen extends StatefulWidget {
  const ApplSupportScreen({super.key});

  @override
  _ApplSupportScreenState createState() => _ApplSupportScreenState();
}

class _ApplSupportScreenState extends State<ApplSupportScreen> {
  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1;

  bool isSlider = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Поддержка',
        showLeading: false,
        alignTitleToEnd: false,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final support = supports[index];
                            return InkWell(
                              onTap: () {
                                debugPrint("Support item tapped");

                                if (support['isTelegram']) {
                                  debugPrint("launch telgram channel");
                                  HandleLaunchUrl.launchUrls(
                                    context,
                                    url: support['channel'],
                                  );
                                } else {
                                  context.pushNamed(
                                    support['routeName'],
                                    // RouteName.supportDetail,
                                    extra: {'support': support},
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const ApplSupportDetailScreen(),
                                  //   ),
                                  // );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                decoration: AppTheme.cardDecoration,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: support['title'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w600,
                                            height: 1.30,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Ссылка",
                                          style: TextStyle(
                                            color: Color(0xFF596574),
                                            fontSize: 12,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w500,
                                            height: 1.30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CustomImageView(
                                      imagePath: support['isTelegram']
                                          ? MediaRes.telegramIcon
                                          : MediaRes.linkSupport,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: supports.length,
                        ),
                      ],
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
}

class _AdCards extends StatelessWidget {
  const _AdCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: AppTheme.cardDecoration,
      child: const Column(
        children: [
          CustomText(
            text: 'Место для рекламы',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF12902A),
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          CustomText(
            text: 'Нажмите, чтобы оставить заявку',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF596574),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
