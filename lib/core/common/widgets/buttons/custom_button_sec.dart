import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomButtonSec extends StatelessWidget {
  const CustomButtonSec({
    required this.btnText,
    this.isLoading = false,
    super.key,
    this.onTap,
    this.isBtnActive = true,
    this.isSecondaryPrimary = false,
    this.child,
  });

  final void Function()? onTap;
  final String btnText;
  final bool isLoading;
  final bool isSecondaryPrimary;

  final bool isBtnActive;
  final Widget? child;

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
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    // side: const BorderSide(color: Color(0xFF2E7866)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x332E7866),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    ),
                  ],
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
                    child ??
                        Text(
                          btnText,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppPalette.primaryColor,
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
