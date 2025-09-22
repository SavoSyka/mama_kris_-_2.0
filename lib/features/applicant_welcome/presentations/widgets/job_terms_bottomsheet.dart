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
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
Future<bool> jobTermsBottomSheet(
  BuildContext context,
  bool privacyAccepted,
  bool termsAccepted,
  VoidCallback onAgree, [
  bool isSecondaryPrimary = false,
]) async {
  // local state for checkboxes
  privacyAccepted = false;
  termsAccepted = false;

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
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: AppTextContents.privacyACceppt,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const CustomText(
                    text: AppTextContents.privacyDescription,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Privacy Policy checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        activeColor: isSecondaryPrimary
                            ? AppPalette.secondaryColor
                            : AppPalette.primaryColor,
                        onChanged: (val) {
                          setState(() => termsAccepted = val ?? false);
                          if (privacyAccepted && termsAccepted) {
                            debugPrint("s");
                            Navigator.pop(context);
                            onAgree();
                          }
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Я принимаю условия ',
                                style: GoogleFonts.outfit(fontSize: 14.sp),
                              ),
                              TextSpan(
                                text: 'Политики конфиденциальности',
                                style: GoogleFonts.outfit(
                                  color: isSecondaryPrimary
                                      ? AppPalette.secondaryColor
                                      : AppPalette.primaryColor,
                                  fontSize: 14.sp,
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

                              TextSpan(
                                text:
                                    " и даю согласие  на обработку моих персональных данных  в соответствии с законодательством",

                                style: GoogleFonts.outfit(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: isSecondaryPrimary
                            ? AppPalette.secondaryColor
                            : AppPalette.primaryColor,

                        value: privacyAccepted,
                        onChanged: (val) {
                          setState(() => privacyAccepted = val ?? false);

                          if (privacyAccepted && termsAccepted) {
                            debugPrint("s");
                            Navigator.pop(context);
                            onAgree();
                          }
                        },
                      ),

                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Я соглашаюсь с ',
                                style: GoogleFonts.outfit(fontSize: 14.sp),
                              ),
                              TextSpan(
                                text: 'Условиями использования',
                                style: GoogleFonts.outfit(
                                  color: isSecondaryPrimary
                                      ? AppPalette.secondaryColor
                                      : AppPalette.primaryColor,
                                  fontSize: 14.sp,
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
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 70),
                ],
              ),
            );
          },
        ),
      );
    },
  );

  return result ?? false;
}
