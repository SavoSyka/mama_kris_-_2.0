import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class ArticleOnePage extends StatefulWidget {
  const ArticleOnePage({super.key, required this.support});
  final DataMap support;

  @override
  State<ArticleOnePage> createState() => _ArticleOnePageState();
}

class _ArticleOnePageState extends State<ArticleOnePage> {
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
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.only(bottom: 50),

                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          CustomText(
                            text: "Как пользоваться приложением?",

                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),
                          const SizedBox(height: 24),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20.h,
                            children: [
                              CustomText(
                                text:
                                    "Добро пожаловать в MamaKris — удобный сервис для поиска удалённой работы и сотрудников!",
                              ),

                              CustomText(
                                text:
                                    "Меня зовут Кристина, я — создатель и руководитель IT-проекта MamaKris, а также многодетная мама с 12-летним опытом работы онлайн. Я знаю, как непросто найти проверенные вакансии и надёжных исполнителей.",
                              ),

                              CustomText(
                                text:
                                    "Биржи фриланса берут большие комиссии, а Telegram-чаты завалены спамом. Поэтому я создала MamaKris — платформу, где всё просто, безопасно и честно.",
                              ),

                              CustomText(
                                text: "Почему пользователи выбирают MamaKris:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              CustomText(
                                text:
                                    "Только проверенные вакансии — наш ИИ-HR собирает предложения более чем из 500 000 групп в Telegram и VK.",
                              ),

                              CustomText(
                                text:
                                    "Удобство и простота — в ленте только актуальные вакансии, без лишней информации.",
                              ),

                              CustomText(
                                text:
                                    "Безопасность — минимум сомнительных заказов и максимум прозрачности.",
                              ),

                              CustomText(
                                text: "Как это работает",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              CustomText(
                                text:
                                    "В приложении можно выбрать одну из двух ролей:",
                              ),

                              CustomText(
                                text:
                                    "👩‍💻 Исполнитель — ищет удалённую работу.",
                              ),

                              CustomText(
                                text:
                                    "💼 Работодатель — ищет сотрудников или исполнителей.",
                              ),

                              CustomText(
                                text: "1. Для исполнителей",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomText(
                                text: "Шаг 1. Нажмите «Ищу удалённую работу».",
                              ),
                              CustomText(
                                text:
                                    "Шаг 2. В разделе Поддержка воспользуйтесь помощью ИИ-карьерного консультанта — он подскажет, с чего начать и какие направления подойдут именно вам.",
                              ),
                              CustomText(
                                text:
                                    "Шаг 3. В разделе Главная лайкайте понравившиеся предложения — контакты работодателя откроются автоматически. Свяжитесь с ним напрямую через мессенджер и обсудите детали сотрудничества.",
                              ),
                              CustomText(
                                text:
                                    "Шаг 4. Все понравившиеся вакансии сохраняются в разделе «Мои заказы» на 10 дней — успейте откликнуться!",
                              ),
                              CustomText(
                                text:
                                    "💡 Совет\nОткликайтесь примерно на 30–50 вакансий в день и активно общайтесь с работодателями — так вы быстрее найдёте работу мечты из дома!",
                              ),
                              CustomText(
                                text:
                                    "💡 Важно:\nИИ-парсер подбирает вакансии из открытых источников, но не несёт ответственности за договорённости с работодателями.Перед началом работы обязательно прочитайте статью «Как защититься от мошенников» в разделе Поддержка.",
                              ),
                              CustomText(
                                text: "2. Для работодателей",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // CustomText(text: "text"),
                              CustomText(
                                text: "Шаг 1. Нажмите «Ищу сотрудника».",
                              ),
                              CustomText(
                                text:
                                    "Шаг 2. Разместите вакансию с описанием задачи и условий сотрудничества.",
                              ),
                              CustomText(
                                text:
                                    "Шаг 3. После проверки модератором ваше объявление появится в ленте исполнителей. Ожидайте отклики и выбирайте подходящих кандидатов!",
                              ),
                              CustomText(
                                text: "💬 Поддержка",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomText(
                                text:
                                    "Если у вас возникли вопросы — напишите в службу поддержки. Мы всегда рядом и готовы помочь 💖",
                              ),

                              // CustomText(text: widget.support['article'] ?? ''),
                              if (widget.support['hasButton'] != null &&
                                  widget.support['hasButton']) ...[
                                const SizedBox(height: 24),

                                CustomButtonSec(
                                  btnText: widget.support['buttonText'],
                                  onTap: () {
                                    if (isActive) {
                                      HandleLaunchUrl.launchUrlGeneric(
                                        context,
                                        url: widget.support['buttonLink'],
                                      );
                                    } else {
                                      context.pushNamed(RouteName.subscription);
                                    }
                                  },
                                ),
                              ],

                              const SizedBox(height: 30),
                            ],
                          ),
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
