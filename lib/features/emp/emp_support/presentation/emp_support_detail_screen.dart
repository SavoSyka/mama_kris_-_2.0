import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class EmpSupportDetailScreen extends StatefulWidget {
  const EmpSupportDetailScreen({super.key});

  @override
  _EmpSupportDetailScreenState createState() => _EmpSupportDetailScreenState();
}

class _EmpSupportDetailScreenState extends State<EmpSupportDetailScreen> {
  final String description = """
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
""";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Статья'),
      body: Container(
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Как пользоватьсяприложением?",

                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),
                          const SizedBox(height: 24),
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
