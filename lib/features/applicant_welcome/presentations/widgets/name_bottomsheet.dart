import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';

import 'package:mama_kris/core/constants/app_text_contents.dart';

/// Returns true if user accepts both Privacy & Terms, otherwise false.
Future<bool> nameBottomSheet(BuildContext context,  VoidCallback onNext , [bool isSecondaryPrimary = false] ) async {
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  color: Colors.white,
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

                        controller: TextEditingController(),
                      ),

                      CustomPrimaryButton(
                        isSecondaryPrimary: isSecondaryPrimary,
                        btnText: AppTextContents.next,
                        onTap: () {
                          onNext();
                        },
                      ),

                      Visibility(
                        visible: MediaQuery.of(context).viewInsets.bottom == 0,

                        child: const SizedBox(height: 200),
                      ),
                      // const SizedBox(height: 100),
                    ],
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
