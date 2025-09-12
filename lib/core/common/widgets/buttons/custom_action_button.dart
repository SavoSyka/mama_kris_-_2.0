import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    required this.btnText,
    this.isLoading = false,
    super.key,
    this.onTap,
    this.borderRadius = 5,
    this.isSecondary = true,
    this.isSecondaryPrimary = false,
    this.borderSide,
  });

  final void Function()? onTap;
  final String btnText;
  final bool isLoading;
  final double borderRadius;

  /// if true → white with shadow
  /// if false → primary without shadow
  final bool isSecondary;
  final bool isSecondaryPrimary;

  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (isLoading) return;
                onTap?.call();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: ShapeDecoration(
                  shadows: isSecondary
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFC9C9C9).withValues(alpha: 0.25),
                            blurRadius: 10,
                          )
                        ]
                      : [],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side: borderSide ?? BorderSide.none,
                  ),
                  color: isSecondary
                      ? AppPalette.white
                      : isSecondaryPrimary
                          ? AppPalette.secondaryColor
                          : Theme.of(context).primaryColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSecondary
                                      ? isSecondaryPrimary
                                          ? AppPalette.secondaryColor
                                          : AppPalette.primaryColor
                                      : AppPalette.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CustomImageView(
                      imagePath: MediaRes.nextIcon,
                      color: isSecondary
                          ? isSecondaryPrimary
                              ? AppPalette.secondaryColor
                              : AppPalette.primaryColor
                          : AppPalette.white,
                      width: 24,
                    )
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
