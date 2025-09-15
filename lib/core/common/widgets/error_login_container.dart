import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';

class ErrorLoginContainer extends StatelessWidget {
  const ErrorLoginContainer({super.key, required this.errMessage});

  final String errMessage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.shade100,
              border: const Border(
                left: BorderSide(color: Colors.red, width: 4),

                top: BorderSide(color: Colors.red, width: 1),
                right: BorderSide(color: Colors.red, width: 1),
                bottom: BorderSide(color: Colors.red, width: 1),
              ),
            ),
            child: CustomText(
              text: errMessage,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
