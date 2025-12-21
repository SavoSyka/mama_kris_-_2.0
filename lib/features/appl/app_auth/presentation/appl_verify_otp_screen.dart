import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/expanded_scroll_wrapper.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/lifecycle/bloc/life_cycle_manager_bloc.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_bloc.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_event.dart';
import 'package:pinput/pinput.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class ApplVerifyOtpScreen extends StatefulWidget {
  const ApplVerifyOtpScreen({
    super.key,
    required this.name,
    required this.password,
    required this.email,
    required this.isFrom,
    this.subscribeEmail = false,
  });
  final String name;
  final String password;
  final String email;
  final String isFrom;
  final bool subscribeEmail;

  @override
  State<ApplVerifyOtpScreen> createState() => _ApplVerifyOtpScreenState();
}

class _ApplVerifyOtpScreenState extends State<ApplVerifyOtpScreen> {
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Верификация', showLeading: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              ExpandedScrollWrapper(
                child: CustomDefaultPadding(
                  top: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.read<UserBloc>().add(
                            GetUserProfileEvent(user: state.user.user),
                          );
                          context.read<LifeCycleManagerBloc>().add(
                            StartUserSessionEvent(
                              startDate: DateTime.now()
                                  .toUtc()
                                  .toIso8601String(),
                            ),
                          );

                          context.goNamed(RouteName.homeApplicant);

                          if (widget.isFrom == 'signup' &&
                              widget.subscribeEmail) {
                            context.read<EmailSubscriptionBloc>().add(
                              SubscribeEmailEvent(email: widget.email),
                            );
                          }
                        } else if (state is AuthOtpVerified) {
                          // * if email validation passed we have to register user by giiving his PII

                          if (widget.isFrom == 'signup') {
                            context.read<AuthBloc>().add(
                              SignupEvent(
                                name: widget.name,
                                email: widget.email,
                                password: widget.password,
                              ),
                            );
                          } else if (widget.isFrom == 'forgot') {
                            context.pushNamed(RouteName.updateApplicantPwd);
                          }
                          // context.goNamed(RouteName.homeApplicant);
                        } else if (state is AuthOtpResent) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OTP отправлен повторно'),
                            ),
                          );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        MediaRes.emailOtp,
                                        width: 100,
                                      ),
                                      const CustomText(
                                        text: "Введите код OTP",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const CustomText(
                                        text:
                                            "Мы отправили код подтверждения на вашу электронную почту. Пожалуйста, Если не получили письмо, то проверьте папку «Спам». Возможно оно упало туда.",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      Pinput(
                                        length: 6,
                                        controller: otpController,
                                        autofocus: true,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(),
                                        defaultPinTheme: PinTheme(
                                          width: 56,
                                          height: 48,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'),
                                          ),
                                        ],
                                        validator: FormValidations.validateOTP,
                                        onCompleted: (pin) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // TODO: Get email from signup or shared preferences
                                            context.read<AuthBloc>().add(
                                              VerifyOtpEvent(
                                                email: widget.email,
                                                otp: pin,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CustomText(
                                            text: "Не получили код?",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          InkWell(
                                            onTap: state is AuthLoading
                                                ? null
                                                : () {
                                                    // TODO: Get email from signup or shared preferences
                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                          ResendOtpEvent(
                                                            email: widget.email,
                                                          ),
                                                        );
                                                  },
                                            child: const CustomText(
                                              text: "Отправить OTP повторно",
                                              style: TextStyle(
                                                color: AppPalette.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      CustomButtonApplicant(
                                        btnText: 'Подтвердить',
                                        isBtnActive: state is! AuthLoading,
                                        isLoading: state is AuthLoading,

                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                              VerifyOtpEvent(
                                                email: widget.email,
                                                otp: otpController.text,
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
