import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/expanded_scroll_wrapper.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/core/utils/get_platform_type.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';

class EmpLoginScreen extends StatefulWidget {
  const EmpLoginScreen({super.key});

  @override
  State<EmpLoginScreen> createState() => _EmpLoginScreenState();
}

class _EmpLoginScreenState extends State<EmpLoginScreen> {
  final emailController = TextEditingController(text: 'emproobbi@yopmail.com');
  final passwordController = TextEditingController(text: '1233211234');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: '',isEmployee: true),
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
                        debugPrint('auth state $state');
                        if (state is EmpAuthSuccess) {
                          // TODO  i have to update employe profile.
                          context.read<EmpUserBloc>().add(
                            EmpGetUserProfileEvent(user: state.user.user),
                          );
                    
                          context.goNamed(RouteName.homeEmploye);
                        } else if (state is EmpAuthFailure) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.message)));
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
                                        text: "Вход",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomInputText(
                                        hintText: 'example@email.com',
                                        labelText: "Почта",
                                        controller: emailController,
                                        validator: FormValidations.validateEmail,
                                      ),
                                      const SizedBox(height: 12),
                                      CustomInputText(
                                        hintText: 'Пароль',
                                        labelText: "Пароль",
                                        controller: passwordController,
                                        obscureText: true,
                                        validator: FormValidations.validatePassword,
                                      ),
                                      const SizedBox(height: 42),
                                      CustomButtonEmployee(
                                        btnText: 'Войти',
                                        isLoading: state is EmpAuthLoading,
                                        isBtnActive: state is! EmpAuthLoading,
                                        onTap: () {
                                          if (_formKey.currentState!.validate()) {
                                            context.read<EmpAuthBloc>().add(
                                              EmpLoginEvent(
                                                email: emailController.text,
                                                password: passwordController.text,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      CustomButtonSec(
                                        btnText: 'Войти',
                                        onTap: () {
                                          // TODO: Implement Google sign in
                                          debugPrint('signInWithGoogle');
                                        },
                                        child: const Row(
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
                    
                                      if(platformType.startsWith('i'))...[
                                      CustomButtonSec(
                                        btnText: 'Войти',
                                        onTap: () {
                                          // TODO: Implement Apple sign in
                                          debugPrint('sign in with apple account');
                                        },
                                        child: const Row(
                                          children: [
                                            CustomImageView(
                                              imagePath: MediaRes.appleIcon,
                                              width: 24,
                                            ),
                                            SizedBox(width: 15),
                                            CustomText(text: 'Войти через Apple'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ],
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomTextButton(
                                            text: "Забыли пароль?",
                                            textColor: AppPalette.empPrimaryColor,
                                            onPressed: () {
                                              // TODO: Navigate to forgot password
                                                context.pushNamed(
                                                RouteName.forgotEmployee,
                                              );
                                              debugPrint('forgot password');
                                            },
                                          ),
                                          CustomTextButton(
                                            text: "Зарегистрироваться",
                                            textColor: AppPalette.empPrimaryColor,
                                            onPressed: () {
                                              context.pushNamed(
                                                RouteName.signupEmploye,
                                              );
                                            },
                                          ),
                                        ],
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
