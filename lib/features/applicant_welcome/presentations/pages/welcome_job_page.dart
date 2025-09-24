import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/applicant_welcome/presentations/widgets/applicant_auth_bottomsheet.dart';
import 'package:mama_kris/features/applicant_welcome/presentations/widgets/job_terms_bottomsheet.dart';

class WelcomeJobPage extends StatefulWidget {
  const WelcomeJobPage({super.key});

  @override
  State<WelcomeJobPage> createState() => _WelcomeJobPageState();
}

class _WelcomeJobPageState extends State<WelcomeJobPage> {
  final options = [WelcomeOption.register, WelcomeOption.login];
  WelcomeOption selectedOption = WelcomeOption.register;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                  ),
                ),
                SizedBox(height: 60.h),
                CustomText(
                  text: AppTextContents.welcomeJob,
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CustomActionButton(
                        isSecondary: selectedOption != option,
                        onTap: () {
                          setState(() {
                            selectedOption = option;
                          });
                          WelcomeOptionHandler.handleWelcomeOption(
                            context: context,
                            option: option,
                            showTerms: option == WelcomeOption.register,
                          );
                        },
                        btnText: option.displayText,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum WelcomeOption { register, login }

class WelcomeOptionHandler {
  static void handleWelcomeOption({
    required BuildContext context,
    required WelcomeOption option,
    bool showTerms = true,
  }) {
    if (showTerms) {
      // Show terms and conditions before proceeding
      JobTermsBottomSheet.showJobTermsBottomSheet(
        context,
        isSecondaryPrimary: false,
        onAgree: () {
          _navigateToAuthBottomSheet(context, option);
        },
      );
    } else {
      // Skip terms and go directly to auth bottom sheet
      _navigateToAuthBottomSheet(context, option);
    }
  }

  static void _navigateToAuthBottomSheet(
    BuildContext context,
    WelcomeOption option,
  ) {
    if (option == WelcomeOption.register) {
      ApplicantAuthBottomSheet.emailBottomSheet(
        context,
        isSecondaryPrimary: false,
        isForgotPassword: false,
      );
    } else {
      ApplicantAuthBottomSheet.loginBottomSheet(
        context,
        onNext: () {
          context.goNamed(RouteName.applicantHome);
          // Navigation to applicantHome is handled by AuthBottomSheetListener
        },
      );
    }
  }
}

extension WelcomeOptionExtension on WelcomeOption {
  String get displayText {
    switch (this) {
      case WelcomeOption.register:
        return AppTextContents.register;
      case WelcomeOption.login:
        return AppTextContents.login;
    }
  }
}
