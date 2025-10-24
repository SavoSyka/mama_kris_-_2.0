import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/job_list_item.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_slider.dart';
import 'package:share_plus/share_plus.dart';

class EmpSupportDetailScreen extends StatefulWidget {
  const EmpSupportDetailScreen({super.key});

  @override
  _EmpSupportDetailScreenState createState() =>
      _EmpSupportDetailScreenState();
}

class _EmpSupportDetailScreenState extends State<EmpSupportDetailScreen> {
  String description = '''
Добро пожаловать на платформу для поиска удалённых вакансий! Я, Кристина, автор идеи и руководитель проекта. С более чем 12-летним опытом работы онлайн, я создала эту платформу, чтобы упростить процесс поиска и размещения вакансий.

Роли в приложении:
• Исполнитель (ищет работу)
• Работодатель (размещает вакансии)

Как начать:
1. Нажмите кнопку «Исполнитель» и ответьте на вопросы для доступа к проверенным вакансиям.
2. Или нажмите кнопку «Работодатель», чтобы получить доступ к размещению вакансий
3. После лайка вакансии вы получите контакт работодателя, а вакансия переместится в раздел «Мои заказы» на 10 дней.

Внизу приложения находится панель с разделами:
• Главная: просмотр предложений о работе
• Мои заказы: вакансии с контактами работодателей
• Чат: техподдержка, реклама, полезные статьи, дополнительные услуги
• Профиль: редактирование анкеты, смена роли, управление подпиской

Рекомендуем откликаться на 30-50 вакансий в день для быстрого поиска работы. У нас на платформе собраны лучшие вакансии и задания для онлайн-заработка. Никогда еще поиск онлайн-работы не был таким простым и удобным!

Успехов в поиске!  
С уважением, команда "MamaKris".
''';

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Статья'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    bottom: 16,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: [
                          const CustomText(
                            text: "Как пользоваться приложением?",
                      
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),
                          SizedBox(height: 24,),
                          CustomText(text: description),
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
}

class _AdCards extends StatelessWidget {
  const _AdCards({super.key});

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
