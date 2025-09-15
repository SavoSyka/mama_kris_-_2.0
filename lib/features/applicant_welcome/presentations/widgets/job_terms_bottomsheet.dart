import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
Future<bool> jobTermsBottomSheet(BuildContext context, bool privacyAccepted,
    bool termsAccepted, VoidCallback onAgree,
    
    [bool isSecondaryPrimary = false] 
    ) async {
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
                  top: 40, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: AppTextContents.privacyACceppt,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                        activeColor: isSecondaryPrimary ? AppPalette.secondaryColor: AppPalette.primaryColor,
                        onChanged: (val) {
                          setState(() => termsAccepted = val ?? false);
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("chec");
                            setState(() => termsAccepted = !termsAccepted);
                          },
                          child: const CustomText(
                            text: AppTextContents.privacyACceppt,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: isSecondaryPrimary ? AppPalette.secondaryColor: AppPalette.primaryColor,

                        value: privacyAccepted,
                        onChanged: (val) {
                          if(termsAccepted)
                          setState(() => privacyAccepted = val ?? false);
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            debugPrint("chec");
                            setState(() => privacyAccepted = !privacyAccepted);

                            if (privacyAccepted && termsAccepted) {
                              debugPrint("s");
                              Navigator.pop(context);
                              onAgree();
                            }
                          },
                          child: const CustomText(
                            text: AppTextContents.privacyAgree,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 70,
                  )
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
