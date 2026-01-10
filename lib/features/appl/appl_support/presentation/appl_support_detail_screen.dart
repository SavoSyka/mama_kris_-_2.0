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

class ApplSupportDetailScreen extends StatefulWidget {
  const ApplSupportDetailScreen({super.key, required this.support});
  final DataMap support;

  @override
  State<ApplSupportDetailScreen> createState() =>
      _ApplSupportDetailScreenState();
}

class _ApplSupportDetailScreenState extends State<ApplSupportDetailScreen> {
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
                            text: widget.support['title'],

                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.30,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildFormattedArticle(widget.support['article'] ?? ''),

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

  Widget _buildFormattedArticle(String article) {
    const headings = [
      'Почему пользователи выбирают MamaKris',
      'Как это работает',
      '1. Для исполнителей',
      '2. Для работодателей',
      'Поддержка',
      'Основные правила безопасности',
      'Помните',
    ];
    
    final List<TextSpan> spans = [];
    int currentIndex = 0;
    
    // Find all headings and format them
    for (final heading in headings) {
      int headingIndex = article.indexOf(heading, currentIndex);
      if (headingIndex != -1) {
        // Add text before heading
        if (headingIndex > currentIndex) {
          spans.add(TextSpan(text: article.substring(currentIndex, headingIndex)));
        }
        // Add formatted heading
        spans.add(TextSpan(
          text: heading,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
          ),
        ));
        currentIndex = headingIndex + heading.length;
      }
    }
    
    // Add remaining text
    if (currentIndex < article.length) {
      spans.add(TextSpan(text: article.substring(currentIndex)));
    }
    
    if (spans.isEmpty) {
      return CustomText(text: article);
    }
    
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: spans,
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
