// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomInputText extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;

  final void Function()? onTap;
  const CustomInputText({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      autofocus: widget.autoFocus,
      style: const TextStyle(fontSize: 14),
      onTapOutside: (val) {
        FocusScope.of(context).unfocus();
      },
      onTap: widget.onTap,
      decoration:  InputDecoration(
        hint: Text(widget.hintText),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ), // balanced padding
      ),
    );
  }
}
