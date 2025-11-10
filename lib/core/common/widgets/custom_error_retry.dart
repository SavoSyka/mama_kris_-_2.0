import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorRetry extends StatelessWidget {
  const CustomErrorRetry({
    required this.onTap,
    super.key,
    this.errorMessage,
    this.isLoading = false,
    this.hasDefaultMargin = true,
  });
  final VoidCallback onTap;
  final String? errorMessage;
  final bool isLoading;
  final bool hasDefaultMargin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: hasDefaultMargin
            ? EdgeInsets.symmetric(horizontal: 16.w)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Color(0xFFE0F2FE), // very light sky-blue
              Colors.white,
            ],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: const Color(0xFFADADAD),
            ),
            Text(
              'Ooops!',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: const Color(0xFFADADAD),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Opacity(
              opacity: 0.60,
              child: Text(
                errorMessage ?? 'Something went wrong, Please try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: const Color(0xFFADADAD),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Try Again',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
