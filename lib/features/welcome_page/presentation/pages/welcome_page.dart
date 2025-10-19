import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
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

                // CustomText(
                //   text: AppTextContents.welcomeDescription,
                //   style: GoogleFonts.manrope(
                //     fontSize: 22,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // SizedBox(height: 20.h),

                // Column(
                //   children: options.map((option) {
                //     return Padding(
                //       padding: const EdgeInsets.only(bottom: 10.0),
                //       child: CustomActionButton(
                //         isSecondary: selectedOption != option,
                //         onTap: () {
                //           // Handle navigation based on option
                //           if (option == WelcomeOption.findJob) {
                //             context.pushNamed(
                //               RouteName.authPage,
                //               extra: {'isApplicant': true},
                //             );
                //           } else {
                //             context.pushNamed(
                //               RouteName.authPage,
                //               extra: {'isApplicant': false},
                //             );
                //           }
                //         },
                //         btnText: option.displayText,
                //       ),
                //     );
                //   }).toList(),
                // ),

                // Option buttons can be dynamically generated using enum
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
