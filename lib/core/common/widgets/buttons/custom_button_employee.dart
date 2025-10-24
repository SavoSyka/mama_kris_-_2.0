import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomButtonEmployee extends StatelessWidget {
  const CustomButtonEmployee({
    required this.btnText,
    this.isLoading = false,
    super.key,
    this.onTap,
    this.isBtnActive = true,
    this.isSecondaryPrimary = false,
  });

  final void Function()? onTap;
  final String btnText;
  final bool isLoading;
  final bool isSecondaryPrimary;

  final bool isBtnActive;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: !isBtnActive ?AppPalette.grey: AppPalette.empPrimaryColor,
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
                        fontSize: 16,
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
