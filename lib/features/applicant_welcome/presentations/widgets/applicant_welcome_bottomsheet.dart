import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/error_login_container.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/utils/form_validations.dart';

class ApplicantWelcomeBottomsheet {
  /// Price bottom sheet
  static Future<String?> price(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onNext,
  ) async {
    return _inputBottomSheet(
      context,
      title: "Set Price",
      hintText: "Enter price",
      controller: controller,
      keyboardType: TextInputType.number,
      onNext: onNext,
    );
  }

  /// Description bottom sheet
  static Future<String?> description(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onNext,
  ) async {
    return _inputBottomSheet(
      context,
      title: "Description",
      hintText: "Describe your service",
      controller: controller,
      maxLines: 4,
      onNext: onNext,
    );
  }

  /// Contact method bottom sheet
  static Future<String?> contact(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onNext,
  ) async {
    return _inputBottomSheet(
      context,
      title: "How can we contact you?",
      hintText: "Enter phone/email",
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onNext: onNext,
    );
  }

  /// Publish confirmation bottom sheet
  static Future<bool> publish(
    BuildContext context,
    VoidCallback onConfirm, [
    String? message,
  ]) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: message ?? "Are you sure you want to publish?",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomPrimaryButton(
                  btnText: "Confirm",
                  onTap: () {
                    onConfirm();
                    Navigator.pop(context, true);
                  },
                ),
                const SizedBox(height: 10),
                CustomPrimaryButton(
                  btnText: "Cancel",
                  onTap: () => Navigator.pop(context, false),
                  isSecondaryPrimary: true,
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  /// Private helper for text input bottom sheets
  static Future<String?> _inputBottomSheet(
    BuildContext context, {
    required String title,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required VoidCallback onNext,
  }) async {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInputText(
                      controller: controller,
                      hintText: hintText,
                      keyboardType: keyboardType,
                    ),
                    const SizedBox(height: 20),
                    CustomPrimaryButton(
                      btnText: AppTextContents.next,
                      onTap: () {
                        onNext();
                        Navigator.pop(context, controller.text);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return result;
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
          emailController.text = 'roba@gmail.com';
          passwordController.text = 'roba@123';
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
                          const SizedBox(height: 20),
                          CustomPrimaryButton(
                            btnText: AppTextContents.next,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                onNext();

                                return;
                              } else {}
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
