import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_detail_screen.dart';

class EmpSupportScreen extends StatefulWidget {
  const EmpSupportScreen({super.key});

  @override
  _EmpSupportScreenState createState() => _EmpSupportScreenState();
}

class _EmpSupportScreenState extends State<EmpSupportScreen> {
  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1;

  bool isSlider = false;

  final List<Map<String, dynamic>> supports = [
    {
      'title': 'Как пользоваться приложением?',
      'salary': 'Ссылка',
      'isTelegram': false,
    },
    {
      'title': 'Сообщество мам в Telegram',
      'salary': 'Ссылка',
      'isTelegram': true,
      'channel': 'https://t.me/mamakris',
    },

    {
      'title': 'Техподдержка',
      'salary': 'Ссылка',
      'isTelegram': true,
      'channel': 'https://t.me/mamakris',
    },
  ];

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
              decoration: const BoxDecoration(color: AppPalette.empBgColor),

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ApplSupportDetailScreen(),
                                    ),
                                  );
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
