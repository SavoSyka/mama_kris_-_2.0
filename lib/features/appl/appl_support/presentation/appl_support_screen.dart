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
    "article": """
Добро пожаловать в MamaKris — удобный сервис для поиска удалённой работы и сотрудников!
\nМеня зовут Кристина, я — создатель и руководитель IT-проекта MamaKris, а также многодетная мама с 12-летним опытом работы онлайн. Я знаю, как непросто найти проверенные вакансии и надёжных исполнителей.
\nБиржи фриланса берут большие комиссии, а Telegram-чаты завалены спамом.
Поэтому я создала MamaKris — платформу, где всё просто, безопасно и честно.

Почему пользователи выбирают MamaKris
\n Только проверенные вакансии — наш ИИ-HR собирает предложения более чем из 500 000 групп в Telegram и VK.
\n Удобство и простота — в ленте только актуальные вакансии, без лишней информации.
\n Безопасность — минимум сомнительных заказов и максимум прозрачности.

Как это работает
\n В приложении можно выбрать одну из двух ролей:
\n\t Исполнитель — ищет удалённую работу.
\n\t Работодатель — ищет сотрудников или исполнителей.

1. Для исполнителей
\nШаг 1. Нажмите «Ищу удалённую работу».
\nШаг 2. В разделе Поддержка воспользуйтесь помощью ИИ-карьерного консультанта — он подскажет, с чего начать и какие направления подойдут именно вам.
\nШаг 3. В разделе Главная лайкайте понравившиеся предложения — контакты работодателя откроются автоматически. Свяжитесь с ним напрямую через мессенджер и обсудите детали сотрудничества.
\nШаг 4. Все понравившиеся вакансии сохраняются в разделе «Мои заказы» на 10 дней — успейте откликнуться!

  Совет:
Откликайтесь примерно на 30–50 вакансий в день и активно общайтесь с работодателями — так вы быстрее найдёте работу мечты из дома!

  Важно:
ИИ-парсер подбирает вакансии из открытых источников, но не несёт ответственности за договорённости с работодателями.
Перед началом работы обязательно прочитайте статью «Как защититься от мошенников» в разделе Поддержка.

2. Для работодателей
\nШаг 1. Нажмите «Ищу сотрудника».
\nШаг 2. Разместите вакансию с описанием задачи и условий сотрудничества.
\nШаг 3. После проверки модератором ваше объявление появится в ленте исполнителей.
Ожидайте отклики и выбирайте подходящих кандидатов!

  Поддержка
Если у вас возникли вопросы — напишите в службу поддержки.
Мы всегда рядом и готовы помочь 
""",
  },
  {
    'title': 'Как защититься от мошенников',
    'salary': 'Ссылка',
    'isTelegram': false,
    "article": """
Поиск удалённой работы открывает новые возможности, но, к сожалению, может привлечь и недобросовестных людей.
Команда MamaKris тщательно проверяет вакансии, но на 100% исключить риск мошенничества невозможно.
Мы собрали для вас простые, но важные рекомендации, которые помогут сохранить ваши данные и деньги в безопасности.

\nОсновные правила безопасности
\n1. Будьте внимательны к слишком выгодным предложениям.
Если обещают «огромный доход без опыта и вложений» — это повод насторожиться.
Мошенники часто используют заманчивые условия, чтобы быстро завоевать доверие.

\n2. Никогда не платите за трудоустройство.
Настоящие работодатели не берут деньги за вакансии, собеседования или доступ к проектам.

\n3. Не передавайте личные данные.
Никому не сообщайте пароли, коды из SMS, данные банковских карт, паспорт или доступ к вашим аккаунтам (iCloud, App Store, почта и т. д.).

\n4. Проверяйте работодателя.
Перед тем как отправить документы или приступить к работе, убедитесь, что компания действительно существует. Поищите отзывы, сайт, профили в соцсетях.

\n5. Не участвуйте в сомнительных финансовых операциях.
Если вас просят «помочь с переводом денег», «дать свой счёт» или «получить оплату за кого-то» — это мошенничество.

\n6. Не отправляйте оригиналы документов.
Никогда не пересылайте по почте или мессенджеру оригиналы документов.
Если требуется подтверждение личности — предоставляйте только копии и только проверенным работодателям.

\n7. Никому не сообщайте никаких паролей от почт, кодов в смс уведомления, не давайте доступ к своему iCloud.

\nПомните
Мы делаем всё возможное, чтобы в MamaKris размещались только проверенные вакансии.
Но даже самые внимательные ИИ-фильтры не способны выявить все обманные схемы.
MamaKris — это агрегатор вакансий, который помогает соискателям и работодателям находить друг друга, но не несёт ответственности за действия сторон вне платформы.

Поэтому, пожалуйста, будьте внимательны, осознанны и осторожны.
Берегите себя и свою репутацию онлайн.
""",
  },
  {
    'title': 'AI (ИИ)- карьерный консультант',
    'salary': 'Ссылка',
    'isTelegram': false,
    'hasButton': true,
    "buttonText": "Запустить консультанцию",
    "buttonLink": "https://recruiter.mamakris.ru/",
    "article":
        "ИИ-карьерный консультант MamaKris — твой умный навигатор в мире удалённой занятости. Он анализирует твои навыки, интересы и рынок труда, чтобы предложить лучшие возможности. Личный подход, точные рекомендации и реальная помощь в поиске онлайн-работы. Всё просто — ты выбираешь, а ИИ направляет.",
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
                                    RouteName.supportDetail,
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
                                        // const SizedBox(height: 8),
                                        // const Text(
                                        //   "Ссылка",
                                        //   style: TextStyle(
                                        //     color: Color(0xFF596574),
                                        //     fontSize: 12,
                                        //     fontFamily: 'Manrope',
                                        //     fontWeight: FontWeight.w500,
                                        //     height: 1.30,
                                        //   ),
                                        // ),
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
