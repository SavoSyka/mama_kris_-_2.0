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

class ArticleTwoPage extends StatefulWidget {
  const ArticleTwoPage({super.key, required this.support});
  final DataMap support;

  @override
  State<ArticleTwoPage> createState() => _ArticleTwoPageState();
}

class _ArticleTwoPageState extends State<ArticleTwoPage> {
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
                            text: "Как защититься от мошенников?",

                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              const SizedBox(height: 24),
                              _normalText(
                                '''Поиск удалённой работы открывает новые возможности, но, к сожалению, может привлечь и недобросовестных людей.
Команда MamaKris тщательно проверяет вакансии, но на 100% исключить риск мошенничества невозможно.
Мы собрали для вас простые, но важные рекомендации, которые помогут сохранить ваши данные и деньги в безопасности.''',
                              ),

                              _boldText("Основные правила безопасности:"),
                              _boldText(
                                "1. Будьте внимательны к слишком выгодным предложениям",
                              ),
                              _normalText(
                                "Если обещают «огромный доход без опыта и вложений» — это повод насторожиться. Мошенники часто используют заманчивые условия, чтобы быстро завоевать доверие.",
                              ),
                              _boldText(
                                "2. Никогда не платите за трудоустройство",
                              ),
                              _normalText(
                                "Настоящие работодатели не берут деньги за вакансии, собеседования или доступ к проектам.",
                              ),
                              _boldText("3. Не передавайте личные данные"),
                              _normalText(
                                "Никому не сообщайте пароли, коды из SMS, данные банковских карт, паспорт или доступ к вашим аккаунтам (iCloud, App Store, почта и т. д.).",
                              ),
                              _boldText("4. Проверяйте работодателя"),
                              _normalText(
                                "Перед тем как отправить документы или приступить к работе, убедитесь, что компания действительно существует. Поищите отзывы, сайт, профили в соцсетях.",
                              ),
                              _boldText(
                                "5. Не участвуйте в сомнительных финансовых операциях",
                              ),
                              _normalText(
                                "Если вас просят «помочь с переводом денег», «дать свой счёт» или «получить оплату за кого-то» — это мошенничество.",
                              ),
                              _boldText(
                                "6. Не отправляйте оригиналы документов",
                              ),
                              _normalText(
                                "Никогда не пересылайте по почте или мессенджеру оригиналы документов. Если требуется подтверждение личности — предоставляйте только копии и только проверенным работодателям.",
                              ),
                              _boldText("Помните"),
                              _normalText(
                                '''Мы делаем всё возможное, чтобы в MamaKris размещались только проверенные вакансии.
 Но даже самые внимательные ИИ-фильтры не способны выявить все обманные схемы.
MamaKris — это агрегатор вакансий, который помогает соискателям и работодателям находить друг друга, но не несёт ответственности за действия сторон вне платформы.
Поэтому, пожалуйста, будьте внимательны, осознанны и осторожны. Берегите себя и свою репутацию онлайн. ''',
                              ),
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

  Widget _boldText(String text) {
    return CustomText(
      text: text,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    );
  }

  Widget _normalText(String text) {
    return CustomText(text: text);
  }

  Future<void> getSubscription() async {
    final isAct = await sl<AuthLocalDataSource>().getSubscription();

    setState(() {
      isActive = isAct;
    });
  }
}
