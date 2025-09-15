import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomInputError extends StatelessWidget {
  const CustomInputError({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: message,
          style: TextStyle(
            color: AppPalette.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
