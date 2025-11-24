import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/typedef.dart';

class ApplSupportDetailScreen extends StatelessWidget {
  const ApplSupportDetailScreen({super.key, required this.support});
  final DataMap support;

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
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 24),
                          CustomText(text: support['article'] ?? '' ),
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
