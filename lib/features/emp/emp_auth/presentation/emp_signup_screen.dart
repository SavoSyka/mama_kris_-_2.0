import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
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

class EmpSignupScreen extends StatefulWidget {
  const EmpSignupScreen({super.key});

  @override
  State<EmpSignupScreen> createState() => _EmpSignupScreenState();
}

class _EmpSignupScreenState extends State<EmpSignupScreen> {
  bool _acceptPrivacyPolicy = false;
  bool _acceptTermsOfUse = false;

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
            top: 0,
            bottom: 0,
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
                            text: "Регистрация",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 80),
                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Имя",

                            controller: TextEditingController(),

                            // suffixIcon: Icon(Icons.search, color: Colors.red, size: 20,),
                          ),
                          const SizedBox(height: 12),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Почта",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 12),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Пароль",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _acceptPrivacyPolicy =
                                        !_acceptPrivacyPolicy;
                                  });
                                },
                                child: Image.asset(
                                  _acceptPrivacyPolicy
                                      ? MediaRes.markedBox
                                      : MediaRes.unMarkedBox,
                                  width: 28,
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Expanded(
                                child: CustomText(
                                  text:
                                      "Я принимаю условия Политики конфиденциальности и даю согласие на обработку моих персональных данных в соответствии с законодательством",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _acceptTermsOfUse = !_acceptTermsOfUse;
                                  });
                                },
                                child: Image.asset(
                                  _acceptTermsOfUse
                                      ? MediaRes.markedBox
                                      : MediaRes.unMarkedBox,
                                  width: 28,
                                ),
                              ),
                              const SizedBox(width: 8),

                              const Expanded(
                                child: CustomText(
                                  text:
                                      "Я соглашаюсь с Условиями использования",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          CustomButtonApplicant(
                            btnText: 'Зарегистрироваться',
                            isBtnActive:
                                _acceptTermsOfUse && _acceptPrivacyPolicy,

                            onTap: () {
                              context.pushNamed(RouteName.homeApplicant);
                            },
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
