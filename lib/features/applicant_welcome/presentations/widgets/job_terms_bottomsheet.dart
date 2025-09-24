import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/config/bottomsheet_config.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/applicant_welcome/presentations/widgets/applicant_auth_bottomsheet.dart';

class JobTermsBottomSheet {
  static Future<bool> showJobTermsBottomSheet(
    BuildContext context, {
    bool isSecondaryPrimary = false,
    required VoidCallback onAgree,
  }) async {
    final formKey = GlobalKey<FormState>();
    bool privacyAccepted = false;
    bool termsAccepted = false;

    return ApplicantAuthBottomSheet.showCustomBottomSheet(
      context: context,
      title: AppTextContents.privacyACceppt,
      formKey: formKey,
      fields: [], // No input fields, using custom widgets for checkboxes
      buttonText: AppTextContents.accept,
      isSecondaryPrimary: isSecondaryPrimary,
      onSubmit: () {
        // if (formKey.currentState!.validate()) {
        Navigator.pop(context, true);
        onAgree();
        // }
      },
      additionalWidgets: [
        const CustomText(
          text: AppTextContents.privacyDescription,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: BottomSheetConfig.fieldSpacing),
        // Privacy Policy checkbox
        CheckboxField(
          value: termsAccepted,
          isSecondaryPrimary: isSecondaryPrimary,
          onChanged: (val) {
            termsAccepted = val ?? false;
            // Update state in CustomBottomSheet
            (context as StatefulElement).markNeedsBuild();
          },
          textSpans: [
            const TextSpan(
              text: 'Я принимаю условия ',
              style: TextStyle(fontSize: 14),
            ),
            TextSpan(
              text: 'Политики конфиденциальности',
              style: TextStyle(
                color: isSecondaryPrimary
                    ? AppPalette.secondaryColor
                    : AppPalette.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  HandleLaunchUrl.launchUrls(
                    context,
                    url: AppConstants.privacyAgreement,
                  );
                },
            ),
            const TextSpan(
              text:
                  ' и даю согласие на обработку моих персональных данных в соответствии с законодательством',
              style: TextStyle(fontSize: 14),
            ),
          ],
          validator: (value) =>
              value == true ? null : AppTextContents.privacyPolicyRequired,
        ),
        const SizedBox(height: 10),
        // Terms of Use checkbox
        CheckboxField(
          value: privacyAccepted,
          isSecondaryPrimary: isSecondaryPrimary,
          onChanged: (val) {
            privacyAccepted = val ?? false;
            // Update state in CustomBottomSheet
            (context as StatefulElement).markNeedsBuild();
          },
          textSpans: [
            const TextSpan(
              text: 'Я соглашаюсь с ',
              style: TextStyle(fontSize: 14),
            ),
            TextSpan(
              text: 'Условиями использования',
              style: TextStyle(
                color: isSecondaryPrimary
                    ? AppPalette.secondaryColor
                    : AppPalette.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  HandleLaunchUrl.launchUrls(
                    context,
                    url: AppConstants.termsAgreement,
                  );
                },
            ),
          ],
          validator: (value) =>
              value == true ? null : AppTextContents.termsRequired,
        ),
      ],
    );
  }
}

// Reusable CheckboxField widget for consistency
class CheckboxField extends FormField<bool> {
  CheckboxField({
    super.key,
    required bool value,
    required bool isSecondaryPrimary,
    required ValueChanged<bool?> onChanged,
    required List<TextSpan> textSpans,
    super.validator,
  }) : super(
         initialValue: value,
         builder: (FormFieldState<bool> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Checkbox(
                     value: state.value,
                     activeColor: isSecondaryPrimary
                         ? AppPalette.secondaryColor
                         : AppPalette.primaryColor,
                     onChanged: (val) {
                       state.didChange(val);
                       onChanged(val);
                     },
                   ),
                   Expanded(child: Text.rich(TextSpan(children: textSpans))),
                 ],
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(left: 16, top: 4),
                   child: CustomText(
                     text: state.errorText!,
                     style: const TextStyle(color: Colors.red, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
