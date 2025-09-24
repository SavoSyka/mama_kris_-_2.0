import 'package:flutter/material.dart';

class FormFieldConfig {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? customInput; // For custom inputs like Pinput

  FormFieldConfig({
    required this.hintText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.customInput,
  });
}
