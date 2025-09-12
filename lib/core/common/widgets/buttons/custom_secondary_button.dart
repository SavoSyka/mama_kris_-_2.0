import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';

class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    required this.btnText,
    this.isLoading = false,
    super.key,
    this.onTap,
    this.borderRadius = 32,
    this.isBtnActive = true,
    this.borderSide,
  });

  final void Function()? onTap;
  final String btnText;
  final bool isLoading;
  final double borderRadius;

  final bool isBtnActive;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                debugPrint('tap 11');
                if (isLoading) return;
                if (isBtnActive) {
                  debugPrint('tap -----------r');

                  if (onTap != null) onTap!();
                }
              },

              //  onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading) ...[
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    CustomText(
                      text: btnText,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
