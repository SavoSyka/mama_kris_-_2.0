
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class FilterActionButtons extends StatelessWidget {
  const FilterActionButtons({required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isSelected ? Border.all(color: AppPalette.primaryColor) : null,
      ),
      child: CustomText(text: text),
    );
  }
}
