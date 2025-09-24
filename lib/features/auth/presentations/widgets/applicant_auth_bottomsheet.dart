import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_bottomsheet.dart';
import 'package:mama_kris/core/common/widgets/show_toast.dart';
import 'package:mama_kris/core/config/bottomsheet_config.dart';
import 'package:mama_kris/core/config/form_field_config.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/auth/applications/auth_bloc.dart';
import 'package:mama_kris/features/auth/applications/auth_event.dart';
import 'package:mama_kris/features/auth/applications/auth_state.dart';
import 'package:pinput/pinput.dart';

class ApplicantAuthBottomSheet {
  static Future<bool> showCustomBottomSheet({
    required BuildContext context,
    required String title,
    required List<FormFieldConfig> fields,
    required String buttonText,
    bool isSecondaryPrimary = false,
    VoidCallback? onSubmit,
    Widget? errorWidget,
    bool isLoading = false,
    List<Widget>? additionalWidgets,
    bool boldTitle = true,
    required GlobalKey<FormState> formKey,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: BottomSheetConfig.barrierColor.withOpacity(
        BottomSheetConfig.barrierOpacity,
      ),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BottomSheetConfig.borderRadius),
        ),
      ),
      builder: (context) => CustomBottomSheet(
        title: title,
        fields: fields,
        buttonText: buttonText,
        boldTitle: boldTitle,
        isSecondaryPrimary: isSecondaryPrimary,
        onSubmit: onSubmit,
        errorWidget: errorWidget,
        additionalWidgets: additionalWidgets,
        formKey: formKey,
        isLoading: isLoading,
      ),
    );
    return result ?? false;
  }

  static Future<bool> emailBottomSheet(
    BuildContext context, {
    bool isSecondaryPrimary = false,
    bool isForgotPassword = false,
  }) async {
    final emailController = TextEditingController(
      text: AppConstants.isDevelopmentMode ? 'roobi@yopmail.com' : '',
    );
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State $state");
            if (state is AuthEmailChecked || state is Authenticated) {
              Navigator.pop(context, true);
              otpBottomSheet(
                context,
                email: emailController.text,
                isSecondaryPrimary: isSecondaryPrimary,
                isForgotPassword: isForgotPassword,
              );
            } else if (state is CheckEmailErroState) {
              showToast(context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return CustomBottomSheet(
              title: AppTextContents.whatsUrEmail,
              formKey: formKey,
              fields: [
                FormFieldConfig(
                  hintText: AppTextContents.email,
                  controller: emailController,
                  validator: FormValidations.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
              buttonText: AppTextContents.next,
              isSecondaryPrimary: isSecondaryPrimary,
              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  if (isForgotPassword) {
                    context.read<AuthBloc>().add(
                      ForgotPasswordEvent(emailController.text),
                    );
                  } else {
                    context.read<AuthBloc>().add(
                      CheckEmailEvent(emailController.text),
                    );
                  }
                }
              },
              isLoading: isLoading,
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  static Future<bool> otpBottomSheet(
    BuildContext context, {
    bool isSecondaryPrimary = false,
    bool isForgotPassword = false,
    required String email,
  }) async {
    final otpController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State $state");
            if (state is AuthOtpValidated) {
              Navigator.pop(context, true);
              if (!isForgotPassword) {
                nameBottomSheet(
                  context,
                  email: email,
                  isSecondaryPrimary: isSecondaryPrimary,
                );
              } else {
                passwordBottomSheet(
                  context,
                  name: '',
                  email: email,
                  isSecondaryPrimary: isSecondaryPrimary,
                  isForgotPassword: true,
                );
              }
            } else if (state is AuthError) {
              showToast(context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return CustomBottomSheet(
              title: AppTextContents.vacancies,
              formKey: formKey,
              fields: [
                FormFieldConfig(
                  hintText: 'Enter OTP',
                  controller: otpController,
                  customInput: Center(
                    child: Pinput(
                      length: 6,
                      controller: otpController,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(),
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
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
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      validator: FormValidations.validateOTP,
                      onCompleted: (pin) {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            ValidateOtpEvent(email, pin),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
              buttonText: AppTextContents.next,
              isSecondaryPrimary: isSecondaryPrimary,
              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    ValidateOtpEvent(email, otpController.text),
                  );
                }
              },
              isLoading: isLoading,
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  static Future<bool> nameBottomSheet(
    BuildContext context, {
    required String email,
    bool isSecondaryPrimary = false,
  }) async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State $state");
            if (state is Authenticated) {
              Navigator.pop(context, true);
            } else if (state is AuthError) {
              showToast(context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return CustomBottomSheet(
              title: AppTextContents.whatsUrName,
              formKey: formKey,
              fields: [
                FormFieldConfig(
                  hintText: AppTextContents.urName,
                  controller: nameController,
                  validator: FormValidations.validateName,
                ),
              ],
              buttonText: AppTextContents.next,
              isSecondaryPrimary: isSecondaryPrimary,
              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  passwordBottomSheet(
                    context,
                    name: nameController.text,
                    email: email,
                    isSecondaryPrimary: isSecondaryPrimary,
                  );
                }
              },
              isLoading: isLoading,
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  static Future<bool> passwordBottomSheet(
    BuildContext context, {
    required String name,
    required String email,
    bool isSecondaryPrimary = false,
    bool isForgotPassword = false,
  }) async {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State $state");
            if (state is Authenticated) {
              Navigator.pop(context, true);
              if (isSecondaryPrimary) {
                context.goNamed(RouteName.employesHome);
              } else {
                context.goNamed(RouteName.applicantHome);
              }
            } else if (state is AuthError) {
              showToast(context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return CustomBottomSheet(
              title: isForgotPassword
                  ? AppTextContents.createPwd
                  : AppTextContents.newPassword,
              formKey: formKey,
              fields: [
                FormFieldConfig(
                  hintText: AppTextContents.password,
                  controller: passwordController,
                  validator: FormValidations.validatePassword,
                  obscureText: true,
                ),
                if (!isForgotPassword)
                  FormFieldConfig(
                    hintText: AppTextContents.confirmPassword,
                    controller: confirmPasswordController,
                    validator: (value) =>
                        FormValidations.validateConfirmPassword(
                          value,
                          passwordController.text,
                        ),
                    obscureText: true,
                  ),
              ],
              buttonText: AppTextContents.next,
              isSecondaryPrimary: isSecondaryPrimary,
              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  if (isForgotPassword) {
                    context.read<AuthBloc>().add(
                      ChangePasswordEvent(passwordController.text),
                    );
                  } else {
                    context.read<AuthBloc>().add(
                      RegisterEvent(
                        email: email,
                        name: name,
                        password: passwordController.text,
                        isApplicant: !isSecondaryPrimary,
                      ),
                    );
                  }
                }
              },
              isLoading: isLoading,
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  static Future<bool> loginBottomSheet(
    BuildContext context, {
    required VoidCallback onNext,
    required bool isSecondaryPrimary,
  }) async {
    final emailController = TextEditingController(
      text: AppConstants.isDevelopmentMode ? 'roobi@yopmail.com' : '',
    );
    final passwordController = TextEditingController(
      text: AppConstants.isDevelopmentMode ? '12345678' : '',
    );
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State $state");
            if (state is Authenticated) {
              Navigator.pop(context, true);
              onNext();
            } else if (state is AuthError) {
              showToast(context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return CustomBottomSheet(
              title: AppTextContents.login,
              isSecondaryPrimary: isSecondaryPrimary,
              formKey: formKey,
              fields: [
                FormFieldConfig(
                  hintText: AppTextContents.email,
                  controller: emailController,
                  validator: FormValidations.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                FormFieldConfig(
                  hintText: AppTextContents.password,
                  controller: passwordController,
                  validator: FormValidations.validatePassword,
                  obscureText: true,
                ),
              ],
              buttonText: AppTextContents.next,

              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    LoginEvent(emailController.text, passwordController.text),
                  );
                }
              },
              additionalWidgets: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomTextButton(
                      text: AppTextContents.forgotPassword,
                      textColor: isSecondaryPrimary
                          ? AppPalette.secondaryColor
                          : AppPalette.primaryColor,

                      onPressed: () {
                        Navigator.pop(context);
                        emailBottomSheet(context, isForgotPassword: true);
                      },
                    ),
                  ],
                ),
              ],
              isLoading: isLoading,
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }
}
