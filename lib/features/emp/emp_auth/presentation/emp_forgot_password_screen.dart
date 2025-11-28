import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/expanded_scroll_wrapper.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';

class EmpForgotPasswordScreen extends StatefulWidget {
  const EmpForgotPasswordScreen({super.key});

  @override
  State<EmpForgotPasswordScreen> createState() =>
      _EmpForgotPasswordScreenState();
}

class _EmpForgotPasswordScreenState extends State<EmpForgotPasswordScreen> {
  // final emailController = TextEditingController(text: 'xanawam595@gusronk.com');
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Восстановление пароля', isEmployee: true),
      body: Container(
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          child: Column(
            children: [
              ExpandedScrollWrapper(
                child: CustomDefaultPadding(
                  child: SingleChildScrollView(
                    child: BlocListener<EmpAuthBloc, EmpAuthState>(
                      listener: (context, state) {
                        if (state is EmpAuthPasswordReset) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Инструкции отправлены на email'),
                            ),
                          );
                          context.goNamed(
                            RouteName.verifyOtpEmployee,
                            extra: {
                              "email": emailController.text,
                              'source': 'forgot',
                              'name': '',
                              'password': "",
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
                                        hintText: 'example@email.com',
                                        labelText: "Email",
                                        controller: emailController,
                                        validator:
                                            FormValidations.validateEmail,
                                                   keyboardType:
                                                TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 42),
                                      CustomButtonEmployee(
                                        btnText: 'Отправить',
                                        isBtnActive: state is! EmpAuthLoading,
                                        isLoading: state is EmpAuthLoading,

                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<EmpAuthBloc>().add(
                                              EmpForgotPasswordEvent(
                                                email: emailController.text,
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
