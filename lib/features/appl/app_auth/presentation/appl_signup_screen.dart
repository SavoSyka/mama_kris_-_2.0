import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';

class ApplSignupScreen extends StatefulWidget {
  const ApplSignupScreen({super.key});

  @override
  State<ApplSignupScreen> createState() => _ApplSignupScreenState();
}

class _ApplSignupScreenState extends State<ApplSignupScreen> {
  bool _acceptPrivacyPolicy = false;
  bool _acceptTermsOfUse = false;

  // final emailController = TextEditingController(text: 'mowerem676@dwakm.com');

  final emailController = TextEditingController(text: 'xanawam595@gusronk.com');

  final nameController = TextEditingController(text: 'robby one');

  final passwordController = TextEditingController(text: '123321123');
  final confirmPasswordController = TextEditingController(text: '123321123');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Signup"),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          bottom: false,
          child: CustomDefaultPadding(
            top: 16,
            bottom: 0,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthCheckEmailVerified) {
                      context.pushNamed(
                        RouteName.verifyOptApplicant,
                        extra: {
                          'email': emailController.text,
                          'name': nameController.text,
                          'password': passwordController.text,
                        },
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
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
                                    keyboardType: TextInputType.name,
                                  ),
                                  const SizedBox(height: 12),
                                  CustomInputText(
                                    hintText: 'example@email.com',
                                    labelText: "Email",
                                    controller: emailController,
                                    validator: FormValidations.validateEmail,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 12),
                                  CustomInputText(
                                    hintText: 'Пароль',
                                    labelText: "Пароль",
                                    obscureText: true,
                                    controller: passwordController,
                                    validator: FormValidations.validatePassword,
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
                                          style: TextStyle(fontSize: 12),
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
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  CustomButtonApplicant(
                                    btnText: 'Зарегистрироваться',
                                    isBtnActive:
                                        _acceptTermsOfUse &&
                                        _acceptPrivacyPolicy &&
                                        state is! AuthLoading,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          CheckEmailEvent(
                                            email: emailController.text,
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
        ),
      ),
    );
  }
}
