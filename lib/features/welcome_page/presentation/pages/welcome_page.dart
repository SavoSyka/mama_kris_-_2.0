import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/welcome_page/presentation/widgets/welcome_card.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final options = [WelcomeOption.findJob, WelcomeOption.findEmployee];
  final selectedOption = WelcomeOption.findJob;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Example usage of enum

    return CustomScaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: CustomDefaultPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                const Center(
                  child: CustomImageView(
                    imagePath: MediaRes.illustrationWelcome,
                    width: 286,
                    height: 306,
                  ),
                ),

                SizedBox(height: 60.h),
                const WelcomeCard(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum WelcomeOption {
  findJob, // "Ищу удаленную работу"
  findEmployee, // "Ищу сотрудника"
}

extension WelcomeOptionExtension on WelcomeOption {
  String get displayText {
    switch (this) {
      case WelcomeOption.findJob:
        return AppTextContents.welcomeOption1;
      case WelcomeOption.findEmployee:
        return AppTextContents.welcomeOption2;
    }
  }
}
