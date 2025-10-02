import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    required this.btnText,
    this.isLoading = false,
    super.key,
    this.onTap,
    this.borderRadius = 5,
    this.isBtnActive = true,
    this.borderSide,
    this.isSecondaryPrimary = false
  });

  final void Function()? onTap;
  final String btnText;
  final bool isLoading;
  final double borderRadius;
  final bool isSecondaryPrimary;

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

                  if (onTap != null) onTap?.call();
                }
              },

              //  onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side: borderSide ?? BorderSide.none,
                  ),
                  color: isBtnActive
                      ? 
                      isSecondaryPrimary ?
                      AppPalette.secondaryColor:
                      
                      Theme.of(context).primaryColor
                      : const Color(0xFFACACAC),
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
                    Text(
                      btnText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppPalette.white,
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
