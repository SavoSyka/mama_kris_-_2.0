import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

class ArticleThreePage extends StatefulWidget {
  const ArticleThreePage({super.key, required this.support});
  final DataMap support;

  @override
  State<ArticleThreePage> createState() => _ArticleThreePageState();
}

class _ArticleThreePageState extends State<ArticleThreePage> {
  @override
  initState() {
    getSubscription();
    super.initState();
  }

  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Статья'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 50),

                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          CustomText(
                            text: "AI (ИИ)- карьерный консультант",

                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomText(
                            text:
                                '''ИИ-карьерный консультант MamaKris — твой умный навигатор в мире удалённой занятости. Он анализирует твои навыки, интересы и рынок труда, чтобы предложить лучшие возможности. Личный подход, точные рекомендации и реальная помощь в поиске онлайн-работы. Всё просто — ты выбираешь, а ИИ направляет. 🌍''',
                          ),

                          const SizedBox(height: 24),

                          CustomButtonSec(
                            btnText: "Запустить консультанцию",

                            onTap: () {
                              if (isActive) {
                                HandleLaunchUrl.launchUrlGeneric(
                                  context,
                                  url: "https://recruiter.mamakris.ru/",
                                );
                              } else {
                                context.pushNamed(RouteName.subscription);
                              }
                            },
                          ),

                          const SizedBox(height: 30),
                        ],
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

  Future<void> getSubscription() async {
    final isAct = await sl<AuthLocalDataSource>().getSubscription();

    setState(() {
      isActive = isAct;
    });
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
