import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/expanded_scroll_wrapper.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class ApplUpdatePasswordScreen extends StatefulWidget {
  const ApplUpdatePasswordScreen({super.key});

  @override
  State<ApplUpdatePasswordScreen> createState() =>
      _ApplUpdatePasswordScreenState();
}

class _ApplUpdatePasswordScreenState extends State<ApplUpdatePasswordScreen> {
  // final emailController = TextEditingController(text: 'xanawam595@gusronk.com');
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Восстановление пароля'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              ExpandedScrollWrapper(
                child: CustomDefaultPadding(
                  child: SingleChildScrollView(
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthPasswordUpdated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Инструкции отправлены на email'),
                            ),
                          );
                          context.goNamed(RouteName.loginApplicant);
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
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
                                        text: "Восстановление пароля",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomText(
                                        text:
                                            "Введите ваш email для восстановления пароля",
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomInputText(
                                        hintText: 'enter your new password',
                                        labelText: "password",
                                        controller: password,
                                        validator:
                                            FormValidations.validatePassword,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomInputText(
                                        hintText: 'enter your confirm password',
                                        labelText: "Confirm Password",
                                        controller: confirmPassword,
                                        validator: (value) =>
                                            FormValidations.validateConfirmPassword(
                                              value,
                                              password.text,
                                            ),
                                      ),
                                      const SizedBox(height: 42),
                                      CustomButtonApplicant(
                                        btnText: 'Отправить',
                                        isBtnActive: state is! AuthLoading,
                                        isLoading: state is AuthLoading,

                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                              UpdatePasswordEvent(
                                                newPassword: password.text,
                                              ),
                                            );
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
