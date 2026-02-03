import 'package:flutter/material.dart';

class CustomStaticInput extends StatelessWidget {
  final String label;
  final String value;
  final bool hasGreyBg;

  const CustomStaticInput({
    super.key,
    required this.label,
    required this.value,
    this.hasGreyBg = false,
  });

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF757575);
    const hintColor = Color(0xFF9E9E9E);
    const borderColor = Color(0xFFF8F8F8);
    const backgroundIdle = Color(0xFFF7F7F7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: hasGreyBg
                      ? Colors.grey.withOpacity(0.08)
                      : backgroundIdle,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Text(
                  value.isEmpty ? "—" : value,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w400,
                    color: value.isEmpty ? hintColor : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
