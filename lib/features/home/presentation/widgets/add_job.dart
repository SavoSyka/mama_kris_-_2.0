import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';

class AddJob extends StatelessWidget {
  const AddJob({super.key, this.onTap});

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.secondaryColor,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: CustomImageView(imagePath: MediaRes.plusCircle, width: 16),
        ),
      ),
    );
  }
}
