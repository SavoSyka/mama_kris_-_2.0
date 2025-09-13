import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';

class EmptyPostedJob extends StatelessWidget {
  const EmptyPostedJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),

        CustomText(
          text: AppTextContents.noJob,
          style: GoogleFonts.manrope(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.secondaryColor,
          ),
        ),
        const SizedBox(height: 10),

        CustomText(
          text: AppTextContents.tellOurMoms,
          style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w500, color: AppPalette.greyDark),
        ),
        SizedBox(height: 35.h),

        const Center(
          child: CustomImageView(
            imagePath: MediaRes.illustrationWelcomeEmp,
            width: 286,
          ),
        ),
      ],
    );
  }
}
