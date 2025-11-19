import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';
import 'package:pinput/pinput.dart';

class EmpVerifyOtpScreen extends StatefulWidget {
  const EmpVerifyOtpScreen({
    super.key,
    required this.name,
    required this.password,
    required this.email,
    required this.isFrom,
  });
  final String name;
  final String password;
  final String email;
  final String isFrom;

  @override
  State<EmpVerifyOtpScreen> createState() => _EmpVerifyOtpScreenState();
}

class _EmpVerifyOtpScreenState extends State<EmpVerifyOtpScreen> {
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
                child: BlocListener<EmpAuthBloc, EmpAuthState>(
                  listener: (context, state) {
                    if (state is EmpAuthOtpVerified) {
                      // * if email validation passed we have to register user by giiving his PII
                     if(widget.isFrom =='signup') {
                       context.read<EmpAuthBloc>().add(
                        EmpSignupEvent(
                          name: widget.name,
                          email: widget.email,
                          password: widget.password,
                        ),
                      );
                     } else if(widget.isFrom=='forgot') {
                        context.pushNamed(RouteName.updateEmployeePwd);

                     }
                    } else if (state is EmpAuthSuccess) {
                      context.goNamed(RouteName.homeApplicant);
                    } else if (state is EmpAuthOtpResent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP отправлен повторно')),
                      );
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(MediaRes.emailOtp, width: 100),
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
                                        "Мы отправили код подтверждения на вашу электронную почту. Пожалуйста, введите его для подтверждения",
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                    ],
                                    validator: FormValidations.validateOTP,
                                    onCompleted: (pin) {
                                      if (_formKey.currentState!.validate()) {
                                        // TODO: Get email from signup or shared preferences
                                        context.read<EmpAuthBloc>().add(
                                          EmpVerifyOtpEvent(
                                            email: widget.email,
                                            otp: pin,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: InkWell(
                                          onTap: state is AuthLoading
                                              ? null
                                              : () {
                                                  // TODO: Get email from signup or shared preferences
                                                  context
                                                      .read<EmpAuthBloc>()
                                                      .add(
                                                        const EmpResendOtpEvent(
                                                          email:
                                                              'user@example.com',
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  CustomButtonEmployee(
                                    btnText: 'Подтвердить',
                                    isBtnActive: state is! EmpAuthLoading,
                                    isLoading: state is EmpAuthLoading,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        // TODO: Get email from signup or shared preferences
                                        context.read<EmpAuthBloc>().add(
                                          EmpVerifyOtpEvent(
                                            email: 'user@example.com',
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
        ),
      ),
    );
  }
}
