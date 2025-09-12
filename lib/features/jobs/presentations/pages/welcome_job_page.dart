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

class WelcomeJobPage extends StatefulWidget {
  const WelcomeJobPage({super.key});

  @override
  State<WelcomeJobPage> createState() => _WelcomeJobPageState();
}

class _WelcomeJobPageState extends State<WelcomeJobPage> {
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
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xFFFFF9E3),
            Color(0xFFCEE5DB),
          ],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
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
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20.h),

                Column(
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CustomActionButton(
                        isSecondary: selectedOption != option,
                        onTap: () {
                          // Handle navigation based on option
                          if (option == _WelcomeOption.register) {
                            _onNext(context);
                            // context.pushNamed(RouteName.welcomeJob);
                          } else {
                            _onNext(context);

                            // context.pushNamed(RouteName.welcomeEmploye);
                          }
                        },
                        btnText: option.displayText,
                      ),
                    );
                  }).toList(),
                )

                // Option buttons can be dynamically generated using enum
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onNext(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: "😎 Мы работаем над этим!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const CustomText(
                text:
                    "Эта функция будет доступна в следующем обновлении.\nСледите за новостями!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomTextButton(
                  onPressed: () => Navigator.pop(context, true),
                  text: 'Назад',
                ),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}

enum _WelcomeOption { register, login }

extension _WelcomeOptionExtension on _WelcomeOption {
  String get displayText {
    switch (this) {
      case _WelcomeOption.register:
        return AppTextContents.jobOption1;
      case _WelcomeOption.login:
        return AppTextContents.jobOption2;
    }
  }
}
