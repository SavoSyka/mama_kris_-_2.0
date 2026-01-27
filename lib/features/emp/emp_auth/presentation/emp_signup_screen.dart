import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/expanded_scroll_wrapper.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class EmpSignupScreen extends StatefulWidget {
  const EmpSignupScreen({super.key});

  @override
  State<EmpSignupScreen> createState() => _EmpSignupScreenState();
}

class _EmpSignupScreenState extends State<EmpSignupScreen> {
  bool _acceptPrivacyPolicy = false;
  bool _acceptTermsOfUse = false;

  bool _subscribeEmail = false;

  final emailController = TextEditingController(
    text: kDebugMode ? "" : "",
  );
  final nameController = TextEditingController(text: kDebugMode ? "" : "");

  final passwordController = TextEditingController(
    text: kDebugMode ? '' : "",
  );
  final confirmPasswordController = TextEditingController(
    text: kDebugMode ? '' : "",
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    //
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "", isEmployee: true),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ExpandedScrollWrapper(
                child: CustomDefaultPadding(
                  bottom: 0,
                  top: 0,
                  child: SingleChildScrollView(
                    child: BlocListener<EmpAuthBloc, EmpAuthState>(
                      listener: (context, state) {
                        if (state is EmpAuthCheckEmailVerified) {
                          context.pushNamed(
                            RouteName.verifyOtpEmployee,
                            extra: {
                              'email': emailController.text,
                              'name': nameController.text,
                              'password': passwordController.text,
                              'source': 'signup',
                            },
                          );
                        } else if (state is EmpAuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      child: BlocBuilder<EmpAuthBloc, EmpAuthState>(
                        builder: (context, state) {
                          return Form(
                            key: _formKey,
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
                                      const SizedBox(height: 40),
                                      CustomInputText(
                                        hintText: 'Иванов Иван',
                                        labelText: "Полное имя",
                                        controller: nameController,
                                        validator: FormValidations.validateName,
                                      ),
                                      const SizedBox(height: 12),
                                      CustomInputText(
                                        hintText: 'example@email.com',
                                        labelText: "Email",
                                        controller: emailController,
                                        validator:
                                            FormValidations.validateEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 12),
                                      CustomInputText(
                                        hintText: 'Пароль',
                                        labelText: "Пароль",
                                        obscureText: true,
                                        controller: passwordController,
                                        validator:
                                            FormValidations.validatePassword,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomInputText(
                                        hintText: 'Подтвердите пароль',
                                        labelText: "Подтвердите пароль",
                                        controller: confirmPasswordController,
                                        obscureText: true,
                                        validator: (value) =>
                                            FormValidations.validateConfirmPassword(
                                              value,
                                              passwordController.text,
                                            ),
                                      ),

                                      const SizedBox(height: 20),
                                      // * Terms and conditions
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  ? MediaRes.empMarkedBox
                                                  : MediaRes.empUnmarkedBox,
                                              width: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                HandleLaunchUrl.launchUrls(
                                                  context,
                                                  url: AppConstants
                                                      .privacyAgreement,
                                                );
                                              },
                                              child: const CustomText(
                                                text:
                                                    "Я принимаю условия Политики конфиденциальности и даю согласие на обработку моих персональных данных в соответствии с законодательством",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppPalette
                                                      .empPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _acceptTermsOfUse =
                                                    !_acceptTermsOfUse;
                                              });
                                            },
                                            child: Image.asset(
                                              _acceptTermsOfUse
                                                  ? MediaRes.empMarkedBox
                                                  : MediaRes.empUnmarkedBox,
                                              width: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                HandleLaunchUrl.launchUrls(
                                                  context,
                                                  url: AppConstants
                                                      .termsAgreement,
                                                );
                                              },

                                              child: const CustomText(
                                                text:
                                                    "Я соглашаюсь с Условиями использования",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppPalette
                                                      .empPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (state is! AuthLoading) {
                                                setState(() {
                                                  _subscribeEmail =
                                                      !_subscribeEmail;
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              _subscribeEmail
                                                  ? MediaRes.markedBox
                                                  : MediaRes.unMarkedBox,
                                              width: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _subscribeEmail =
                                                      !_subscribeEmail;
                                                });
                                              },

                                              child: const CustomText(
                                                text:
                                                    "Согласен на получение рассылки по электронной почте",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppPalette.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),
                                      CustomButtonEmployee(
                                        btnText: 'Зарегистрироваться',
                                        isLoading: state is EmpAuthLoading,
                                        isBtnActive:
                                            _acceptTermsOfUse &&
                                            _acceptPrivacyPolicy &&
                                            state is! EmpAuthLoading,
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<EmpAuthBloc>().add(
                                              EmpCheckEmailEvent(
                                                email: emailController.text,
                                                isSubscribe: _subscribeEmail,
                                              ),
                                            );

                                            // context.read<AuthBloc>().add(
                                            //   SignupEvent(
                                            //     name: nameController.text,
                                            //     email: emailController.text,
                                            //     password: passwordController.text,
                                            //   ),
                                            // );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
