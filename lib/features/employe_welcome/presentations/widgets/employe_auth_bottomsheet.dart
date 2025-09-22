import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/error_login_container.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/employe_welcome/applications/emp_auth_bloc.dart';
import 'package:mama_kris/features/employe_welcome/applications/emp_auth_event.dart';
import 'package:mama_kris/features/employe_welcome/applications/emp_auth_state.dart';
import 'package:pinput/pinput.dart';

class EmployeAuthBottomsheet {
  EmployeAuthBottomsheet._();

  ///
  /// email bottomshee
  static Future<bool> emailBottomSheet(
    BuildContext context, {
    bool isSecondaryPrimary = false,
    bool isForgotPassord = false,
  }) async {
    final formKey = GlobalKey<FormState>();

    final TextEditingController emailController = TextEditingController(
      text: 'robiy@yopmail.com',
    );

    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.white.withOpacity(0.75), // 🔥 darken background
      backgroundColor: Colors.transparent, // keep your custom container rounded
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: BlocConsumer<EmpAuthBloc, EmpAuthState>(
                        listener: (context, state) {
                          if (state is AuthEmailChecked) {
                            Navigator.pop(context);
                            otpBottomSheet(
                              context,
                              email: emailController.text,
                              isSecondaryPrimary: isSecondaryPrimary,
                              isForgotPassword: isForgotPassord,
                            );
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              if (state is CheckEmailErroState) ...[
                                ErrorLoginContainer(errMessage: state.message),
                              ],
                              const CustomText(
                                text: AppTextContents.whstsUrEmail,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              CustomInputText(
                                hintText: AppTextContents.email,

                                controller: emailController,
                                validator: FormValidations.validateEmail,
                              ),
                              CustomPrimaryButton(
                                btnText: AppTextContents.next,
                                isSecondaryPrimary: true,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    debugPrint("tapped");

                                    if (isForgotPassord) {
                                      context.read<EmpAuthBloc>().add(
                                        ForgotPasswordEvent(
                                          emailController.text,
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<EmpAuthBloc>().add(
                                      CheckEmailEvent(emailController.text),
                                    );
                                    // Navigator.pop(context);
                                  }
                                },
                                isLoading: state is AuthLoading,
                              ),
                              Visibility(
                                visible:
                                    MediaQuery.of(context).viewInsets.bottom ==
                                    0,

                                child: const SizedBox(height: 200),
                              ),
                              // const SizedBox(height: 100),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  static Future<void> otpBottomSheet(
    BuildContext context, {
    required String email,
    required bool isSecondaryPrimary,
    bool isForgotPassword = false,
  }) async {
    final otpController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.white.withOpacity(0.75),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                color: Colors.white,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pinput field
                      Center(
                        child: Pinput(
                          length: 6,
                          controller: otpController,
                          autofocus: true,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            if (value.length < 6) {
                              return 'OTP must be 6 digits';
                            }
                            return null;
                          },
                          onCompleted: (pin) {
                            context.read<EmpAuthBloc>().add(
                              ValidateOtpEvent(email, otpController.text),
                            );
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocConsumer<EmpAuthBloc, EmpAuthState>(
                        listener: (context, state) {
                          debugPrint("state $state");

                          if (state is AuthEmailChecked) {
                            Navigator.pop(context);

                            if (isForgotPassword) {
                              passwordBottomsheet(
                                context,
                                name: '',
                                email: '',
                                isForgotPassword: isForgotPassword,
                              );
                            } else {
                              nameBottomSheet(
                                context,
                                email: email,
                                isSecondaryPrimary: isSecondaryPrimary,
                              );
                            }
                          }
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return CustomPrimaryButton(
                            btnText: AppTextContents.next,
                            isSecondaryPrimary: true,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                debugPrint("tapped");
                                context.read<EmpAuthBloc>().add(
                                  ValidateOtpEvent(email, otpController.text),
                                );
                                // Navigator.pop(context);
                              }
                            },
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),

                      Visibility(
                        visible: MediaQuery.of(context).viewInsets.bottom == 0,

                        child: const SizedBox(height: 200),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<bool> nameBottomSheet(
    BuildContext context, {
    required String email,
    required bool isSecondaryPrimary,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.white.withOpacity(0.75), // 🔥 darken background
      backgroundColor: Colors.transparent, // keep your custom container rounded
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          const CustomText(
                            text: AppTextContents.whatsUrName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          CustomInputText(
                            hintText: AppTextContents.urName,

                            validator: FormValidations.validateName,

                            controller: nameController,
                          ),

                          CustomPrimaryButton(
                            isSecondaryPrimary: true,
                            btnText: AppTextContents.next,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                debugPrint("tapped");
                                passwordBottomsheet(
                                  context,
                                  name: nameController.text,
                                  email: email,
                                  isSecondaryPrimary: isSecondaryPrimary,
                                );
                                // Navigator.pop(context);
                              }
                            },
                          ),

                          Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom == 0,

                            child: const SizedBox(height: 200),
                          ),
                          // const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  static Future<String?> loginBottomSheet(
    BuildContext context, {

    required VoidCallback onNext,
  }) async {
    String? errorMessage;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final result = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        if (AppConstants.isDevelopmentMode) {
          emailController.text = 'yefinec547@fanwn.com';
          passwordController.text = 'strongPassword123!';
        }
        return StatefulBuilder(
          builder: (context, useState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: AppTextContents.login,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomInputText(
                            controller: emailController,
                            hintText: AppTextContents.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: FormValidations.validateEmail,
                          ),
                          const SizedBox(height: 20),

                          CustomInputText(
                            controller: passwordController,
                            obscureText: true,
                            hintText: AppTextContents.password,
                            keyboardType: TextInputType.emailAddress,
                            validator: FormValidations.validatePassword,
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextButton(
                                text: AppTextContents.forgotPassword,
                                textColor: AppPalette.secondaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                  emailBottomSheet(
                                    context,
                                    isForgotPassord: true,
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          BlocConsumer<EmpAuthBloc, EmpAuthState>(
                            listener: (context, state) {
                              debugPrint(" state $state");
                              if (state is Authenticated) {
                                context.goNamed(RouteName.employesHome);
                              }
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return CustomPrimaryButton(
                                btnText: AppTextContents.next,
                                isSecondaryPrimary: true,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<EmpAuthBloc>().add(
                                      LoginEvent(
                                        emailController.text,
                                        passwordController.text,
                                      ),
                                    );
                                    // onNext();

                                    return;
                                  } else {}
                                },

                                isLoading: state is AuthLoading,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom == 0,

                            child: const SizedBox(height: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return result;
  }

  static Future<bool> passwordBottomsheet(
    BuildContext context, {
    required String name,
    required String email,

    bool isSecondaryPrimary = false,
    bool isForgotPassword = false,
  }) async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.white.withOpacity(0.75), // 🔥 darken background
      backgroundColor: Colors.transparent, // keep your custom container rounded
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          const CustomText(
                            text: AppTextContents.createPwd,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          CustomInputText(
                            hintText: AppTextContents.password,
                            validator: FormValidations.validatePassword,
                            controller: passwordController,
                          ),

                          BlocConsumer<EmpAuthBloc, EmpAuthState>(
                            listener: (context, state) {
                              debugPrint(" state $state");
                              if (state is Authenticated) {
                                context.goNamed(RouteName.employesHome);
                              }
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return CustomPrimaryButton(
                                btnText: AppTextContents.next,
                                isSecondaryPrimary: true,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if (isForgotPassword) {
                                      context.read<EmpAuthBloc>().add(
                                        ChangePasswordEvent(
                                          passwordController.text,
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<EmpAuthBloc>().add(
                                      RegisterEvent(
                                        email: email,
                                        name: name,
                                        password: passwordController.text,
                                      ),
                                    );
                                    // onNext();

                                    return;
                                  } else {}
                                },

                                isLoading: state is AuthLoading,
                              );
                            },
                          ),

                          Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom == 0,

                            child: const SizedBox(height: 200),
                          ),
                          // const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}
