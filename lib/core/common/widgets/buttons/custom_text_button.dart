import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
