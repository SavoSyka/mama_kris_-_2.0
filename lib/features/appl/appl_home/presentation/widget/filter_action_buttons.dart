import 'package:flutter/material.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';

class FilterActionButtons extends StatelessWidget {
  const FilterActionButtons({
    super.key,
    required this.isSelected,
    required this.text,
  });

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AdUi.darkGreen : Colors.transparent,
        ),
        boxShadow: const [AdUi.shadowGreen],
      ),
      child: Text(
        text,
        style: AdUi.manrope(
          12,
          FontWeight.w600,
          color: isSelected ? AdUi.darkGreen : AdUi.grey,
          lineHeight: 15.6,
        ),
      ),
    );
  }
}
