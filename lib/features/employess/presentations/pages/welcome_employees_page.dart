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
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/auth/presentations/widgets/job_terms_bottomsheet.dart';

class WelcomeEmployeesPage extends StatefulWidget {
  const WelcomeEmployeesPage({super.key});

  @override
  State<WelcomeEmployeesPage> createState() => _WelcomeEmployeesPageState();
}

class _WelcomeEmployeesPageState extends State<WelcomeEmployeesPage> {
  final options = [_WelcomeOption.register, _WelcomeOption.login];
  final selectedOption = _WelcomeOption.register;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Example usage of enum

    return CustomScaffold(
      body: SafeArea(
        child: CustomDefaultPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Center(
                child: CustomImageView(
                  imagePath: MediaRes.illustrationWelcomeEmp,
                  width: 286,
                ),
              ),
              SizedBox(height: 60.h),
              CustomText(
                text: AppTextContents.welcomEemploye,
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
                      isSecondaryPrimary: true,
                      onTap: () {
                        // Handle navigation based on option
                        if (option == _WelcomeOption.register) {
                          // jobTermsBottomSheet(context, false, false, () {
                          //   // nameBottomSheet(context, () {
                          //   //   Navigator.pop(context);
                          //   //   emailBottomSheet(context, () {
                          //   //     Navigator.pop(context);
                          //   //     passwordBottomsheet(context, () {
                          //   //       Navigator.pop(context);
                          //   //       context.goNamed(RouteName.employesHome);
                          //   //     },true);
                          //   //   },true);
                          //   // }, true);
                          // }, true);
                        } else {
                          // jobTermsBottomSheet(context, false, false, () {});

                          // context.pushNamed(RouteName.welcomeEmploye);
                        }
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
    );
  }
}

enum _WelcomeOption { register, login }

extension _WelcomeOptionExtension on _WelcomeOption {
  String get displayText {
    switch (this) {
      case _WelcomeOption.register:
        return AppTextContents.employeOption1;
      case _WelcomeOption.login:
        return AppTextContents.employeOption2;
    }
  }
}
