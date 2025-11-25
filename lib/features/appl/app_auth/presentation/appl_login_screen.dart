import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/auth/auth_service.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/core/utils/get_platform_type.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';

class ApplLoginScreen extends StatefulWidget {
  const ApplLoginScreen({super.key});

  @override
  State<ApplLoginScreen> createState() => _ApplLoginScreenState();
}

class _ApplLoginScreenState extends State<ApplLoginScreen> {
  // final emailController = TextEditingController(text: 'emproobbi@yopmail.com');

  // final emailController = TextEditingController(text: 'toli@yopmail.com');

  final emailController = TextEditingController(
  ); // subscription with one year
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: ''),
      body: Container(
        decoration: 
        const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Center(
                    child: CustomDefaultPadding(
                      child: SingleChildScrollView(
                        child: BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            debugPrint('auth state $state');
                            if (state is AuthSuccess) {
                              context.read<UserBloc>().add(
                                GetUserProfileEvent(user: state.user.user),
                              );

                              if (state.user.subscription.active) {
                                context.goNamed(RouteName.homeApplicant);
                              } else {
                                context.goNamed(RouteName.homeApplicant);
                              }
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
                                            validator:
                                                FormValidations.validateEmail,
                                          ),
                                          const SizedBox(height: 12),
                                          CustomInputText(
                                            hintText: 'Пароль',
                                            labelText: "Пароль",
                                            controller: passwordController,
                                            obscureText: true,
                                            validator: FormValidations
                                                .validatePassword,
                                          ),
                                          const SizedBox(height: 42),
                                          CustomButtonApplicant(
                                            btnText: 'Войти',
                                            isLoading: state is AuthLoading,
                                            isBtnActive: state is! AuthLoading,
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<AuthBloc>().add(
                                                  LoginEvent(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          // const SizedBox(height: 20),
                                          // CustomButtonSec(
                                          //   btnText: 'Войти',
                                          //   onTap: () {
                                          //     // TODO: Implement Google sign in
                                          //     debugPrint('signInWithGoogle');
                                          //     signInWithGoogle();
                                          //   },
                                          //   child: const Row(
                                          //     children: [
                                          //       CustomImageView(
                                          //         imagePath:
                                          //             MediaRes.googleIcon,
                                          //         width: 24,
                                          //       ),
                                          //       SizedBox(width: 15),
                                          //       CustomText(
                                          //         text: 'Войти через Google',
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                          const SizedBox(height: 20),
                                          if (platformType.startsWith('i')) ...[
                                            CustomButtonSec(
                                              btnText: 'Войти',
                                              onTap: () {
                                                // TODO: Implement Apple sign in
                                                debugPrint(
                                                  'sign in with apple account',
                                                );
                                                signInWithApple();
                                              },
                                              child: const Row(
                                                children: [
                                                  CustomImageView(
                                                    imagePath:
                                                        MediaRes.appleIcon,
                                                    width: 24,
                                                  ),
                                                  SizedBox(width: 15),
                                                  CustomText(
                                                    text: 'Войти через Apple',
                                                  ),
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
                                                onPressed: () {
                                                  // TODO: Navigate to forgot password
                                                  debugPrint('forgot password');
                                                  context.pushNamed(
                                                    RouteName.forgotApplicant,
                                                  );
                                                },
                                              ),
                                              CustomTextButton(
                                                text: "Зарегистрироваться",
                                                onPressed: () {
                                                  context.pushNamed(
                                                    RouteName.signupApplicant,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // * 1. ────────────── Helper functions started ───────────────────────

  // * 1. ────────────── Google login called here started ───────────────────────

  Future<void> signInWithGoogle() async {
    await AuthService().signOut();
    final user = await AuthService().signInWithGoogle();

    if (user != null) {
      final idToken = user['idToken'];
      debugPrint("Id tokhen $idToken");
      context.read<AuthBloc>().add(LoginWithGoogleEvent(idToken: idToken));
    }

    debugPrint("user data $user");

    debugPrint('');
  }

  Future<void> signInWithApple() async {
    await AuthService().signOut();
    final user = await AuthService().signInWithApple();

    if (user != null) {
      final identityToken = user['identityToken'];
      final userData = user['userData'] as DataMap;

      debugPrint("Id tokhen $identityToken");

      context.read<AuthBloc>().add(
        LoginWithAppleEvent(identityToken: identityToken, userData: userData),
      );
    }

    debugPrint("user data $user");

    debugPrint('');
  }

}
