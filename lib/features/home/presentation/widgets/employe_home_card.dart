// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class EmployeHomeCard extends StatelessWidget {
  const EmployeHomeCard({
    super.key,
    required this.text,
    this.isPrimary = false,
    required this.isSelected,
    this.isTextCenter = false,
    this.onTap,
  });
  final String text;
  final bool isSelected;
  final void Function()? onTap;
  final bool isTextCenter;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? isPrimary ? AppPalette.primaryColor : AppPalette.secondaryColor : Color(0xFFF9F9F9),

      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            text: text,
            textAlign: isTextCenter ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: !isSelected ? Color(0xFF596574) : AppPalette.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
