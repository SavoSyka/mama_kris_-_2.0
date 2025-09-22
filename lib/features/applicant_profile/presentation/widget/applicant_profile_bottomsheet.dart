import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/error_login_container.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/applicant_welcome/applications/auth_bloc.dart';
import 'package:mama_kris/features/applicant_welcome/applications/auth_event.dart';
import 'package:mama_kris/features/applicant_welcome/applications/auth_state.dart';
import 'package:pinput/pinput.dart';

class ApplicantProfileBottomsheet {
  ApplicantProfileBottomsheet._();
  static Future<String?> nameBottoSheet(
    BuildContext context, {

    required VoidCallback onNext,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) async {
    String? errorMessage;

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
                            text: AppTextContents.edit,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomInputText(
                            controller: controller,
                            hintText: AppTextContents.urName,
                            validator: FormValidations.validateName,
                            autoFocus: true,
                          ),
                          const SizedBox(height: 20),

                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is Authenticated) {
                                context.goNamed(RouteName.applicantHome);
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (state is AuthError)
                                    ErrorLoginContainer(
                                      errMessage: state.message,
                                    ),

                                  CustomPrimaryButton(
                                    btnText: AppTextContents.next,
                                    isLoading: state is AuthLoading,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        onNext(); // your passed callback
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  CustomTextButton(
                                    text: "Cancel",
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
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

  static Future<void> showContactBottomSheet(
    BuildContext context, {
    String? telegram,
    String? vk,
    String? whatsapp,
    required void Function(String telegram, String vk, String whatsapp) onSave,
  }) async {
    final telegramController = TextEditingController(text: telegram ?? '');
    final vkController = TextEditingController(text: vk ?? '');
    final whatsappController = TextEditingController(text: whatsapp ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Update Contact Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomInputText(
                        controller: telegramController,
                        hintText: "Telegram Username / Link",
                        prefixIcon: const Icon(
                          Icons.telegram,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomInputText(
                        controller: vkController,
                        hintText: "VK Profile Link",
                        prefixIcon: const Icon(Icons.link),
                      ),
                      const SizedBox(height: 16),

                      CustomInputText(
                        controller: whatsappController,
                        hintText: "WhatsApp Number",
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(13),
                          child: const CustomImageView(
                            imagePath: MediaRes.whatsapp,
                            width: 8,

                            fit: BoxFit.contain,
                          ),
                        ),

                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: CustomPrimaryButton(
                              btnText: "Save",
                              onTap: () {
                                onSave(
                                  telegramController.text,
                                  vkController.text,
                                  whatsappController.text,
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<String?> emailBottomshet(
    BuildContext context, {

    required VoidCallback onNext,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) async {
    String? errorMessage;

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
                            text: AppTextContents.edit,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomInputText(
                            controller: controller,
                            hintText: AppTextContents.email,
                            validator: FormValidations.validateEmail,
                            autoFocus: true,
                          ),
                          const SizedBox(height: 20),

                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is Authenticated) {
                                context.goNamed(RouteName.applicantHome);
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (state is AuthError)
                                    ErrorLoginContainer(
                                      errMessage: state.message,
                                    ),

                                  CustomPrimaryButton(
                                    btnText: AppTextContents.next,
                                    isLoading: state is AuthLoading,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        onNext(); // your passed callback
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  CustomTextButton(
                                    text: "Cancel",
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
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

  static Future<String?> descriptionBottomSheet(
    BuildContext context, {

    required VoidCallback onNext,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) async {
    String? errorMessage;

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
                            text: AppTextContents.edit,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomInputText(
                            controller: controller,
                            hintText: AppTextContents.urName,
                            validator: FormValidations.validateName,
                            autoFocus: true,
                            maxLines: 12,
                          ),
                          const SizedBox(height: 20),

                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is Authenticated) {
                                context.goNamed(RouteName.applicantHome);
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (state is AuthError)
                                    ErrorLoginContainer(
                                      errMessage: state.message,
                                    ),

                                  CustomPrimaryButton(
                                    btnText: AppTextContents.next,
                                    isLoading: state is AuthLoading,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        onNext(); // your passed callback
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  CustomTextButton(
                                    text: "Cancel",
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
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
}
