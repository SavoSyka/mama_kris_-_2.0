import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';

class BuildErrorCard extends StatelessWidget {
  const BuildErrorCard({super.key, required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.blue,

        child: Container(
          color: Colors.red,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: CustomDefaultPadding(
                child: Column(
                  children: [
                    CustomErrorRetry(errorMessage: message, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
