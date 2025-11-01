import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomProgressBar extends StatelessWidget {
  final double totalProgress;
  final double filledProgress;

  const CustomProgressBar({
    super.key,
    required this.totalProgress,
    required this.filledProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent division by zero and clamp progress between 0 and 1
    final double progress = totalProgress <= 0
        ? 0
        : (filledProgress / totalProgress).clamp(0.0, 1.0);

    return Semantics(
      label: 'Progress bar',
      value: '${(progress * 100).round()}%',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: 8.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppPalette.grey,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: AppPalette.empPrimaryColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
