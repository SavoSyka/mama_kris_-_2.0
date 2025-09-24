import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/config/bottomsheet_config.dart';
import 'package:mama_kris/core/config/form_field_config.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final String buttonText;
  final bool isSecondaryPrimary;
  final VoidCallback? onSubmit;
  final Widget? errorWidget;
  final bool isLoading;
  final List<Widget>? additionalWidgets;
  final GlobalKey<FormState> formKey;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.fields,
    required this.buttonText,
    this.isSecondaryPrimary = false,
    this.onSubmit,
    this.errorWidget,
    this.isLoading = false,
    this.additionalWidgets,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(BottomSheetConfig.borderRadius),
          ),
          child: Container(
            padding: BottomSheetConfig.padding,
            color: Colors.white,
            child: Form(
              key: formKey,
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
                  const SizedBox(height: BottomSheetConfig.fieldSpacing),
                  if (errorWidget != null) ...[
                    errorWidget!,
                    const SizedBox(height: BottomSheetConfig.fieldSpacing),
                  ],
                  ...fields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: BottomSheetConfig.fieldSpacing,
                      ),
                      child:
                          field.customInput ??
                          CustomInputText(
                            hintText: field.hintText,
                            controller: field.controller,
                            validator: field.validator,
                            obscureText: field.obscureText,
                            keyboardType: field.keyboardType,
                          ),
                    ),
                  ),
                  CustomPrimaryButton(
                    btnText: buttonText,
                    isSecondaryPrimary: isSecondaryPrimary,
                    onTap: onSubmit,
                    isLoading: isLoading,
                  ),
                  if (additionalWidgets != null) ...additionalWidgets!,
                  Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: const SizedBox(height: 200),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
