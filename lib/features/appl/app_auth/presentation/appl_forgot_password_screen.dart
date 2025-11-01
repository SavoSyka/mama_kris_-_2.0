import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';

class ApplForgotPasswordScreen extends StatefulWidget {
  const ApplForgotPasswordScreen({super.key});

  @override
  State<ApplForgotPasswordScreen> createState() => _ApplForgotPasswordScreenState();
}

class _ApplForgotPasswordScreenState extends State<ApplForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Восстановление пароля'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: CustomDefaultPadding(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthPasswordReset) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Инструкции отправлены на email')),
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
                                    text: "Введите ваш email для восстановления пароля",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomInputText(
                                    hintText: 'example@email.com',
                                    labelText: "Email",
                                    controller: emailController,
                                    validator: FormValidations.validateEmail,
                                  ),
                                  const SizedBox(height: 42),
                                  CustomButtonApplicant(
                                    btnText: 'Отправить',
                                    isBtnActive: state is! AuthLoading,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          ForgotPasswordEvent(email: emailController.text),
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
        ),
      ),
    );
  }
}