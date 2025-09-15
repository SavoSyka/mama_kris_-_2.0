import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';

class HomeBottomsheet {
  /// Profession bottom sheet
  static Future<String?> profession(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onNext,
  ) async {
    return _professionBottomSheet(
      context,
      title: AppTextContents.whoAreULooking,
      hintText: AppTextContents.profession,
      controller: controller,
      onNext: onNext,
    );
  }

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

  static Future<String?> _professionBottomSheet(
    BuildContext context, {
    required String title,
    required String hintText,
    required TextEditingController controller,
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

                        InkWell(
                          onTap: () async {
                            final selected = await showModalBottomSheet<String>(
                              context: context,
                              builder: (context) {
                                final professions = [
                                  "Developer",
                                  "Designer",
                                  "Manager",
                                  "Other",
                                ];
                                return SafeArea(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(professions[index]),
                                      onTap: () => Navigator.pop(
                                        context,
                                        professions[index],
                                      ),
                                    ),
                                    separatorBuilder: (_, __) => const Divider(color: AppPalette.greyLight,),
                                    itemCount: professions.length,
                                  ),
                                );
                              },
                            );

                            if (selected != null) {
                              useState(() {
                                controller.text = selected;
                              });
                            }
                          },
                          child: CustomShadowContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: controller.text.isEmpty
                                      ? hintText
                                      : controller.text,
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: AppPalette.secondaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        CustomPrimaryButton(
                          isSecondaryPrimary: true,
                          btnText: AppTextContents.next,
                          onTap: () {
                            onNext();
                            Navigator.pop(context, controller.text);
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
            );
          },
        );
      },
    );

    return result;
  }
}
