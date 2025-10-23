import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/welcome_page/presentation/widgets/welcome_card.dart';

class EmpLoginScreen extends StatefulWidget {
  const EmpLoginScreen({super.key});

  @override
  State<EmpLoginScreen> createState() => _EmpLoginScreenState();
}

class _EmpLoginScreenState extends State<EmpLoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Example usage of enum

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: ''),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: CustomDefaultPadding(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: [
                          const CustomText(
                            text: "Вход",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Почта",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 12),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Почта",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 42),

                          const CustomButtonApplicant(btnText: 'Войти'),
                          const SizedBox(height: 20),

                          const CustomButtonSec(
                            btnText: 'Войти',

                            child: Row(
                              children: [
                                CustomImageView(
                                  imagePath: MediaRes.googleIcon,
                                  width: 24,
                                ),
                                SizedBox(width: 15),

                                CustomText(text: 'Войти через Google'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const CustomButtonSec(
                            btnText: 'Войти',
                            child: Row(
                              children: [
                                CustomImageView(
                                  imagePath: MediaRes.appleIcon,
                                  width: 24,
                                ),

                                SizedBox(width: 15),

                                CustomText(text: 'Войти через Google'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(text: "Нет аккаунта?"),
                              CustomTextButton(
                                text: "Зарегистрироваться",
                                onPressed: () {
                                  context.pushNamed(RouteName.signupApplicant);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
