// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class CustomInputText extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final void Function()? onTap;
  final int minLines;
  final int maxLines;

  const CustomInputText({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.readOnly = false,
    this.autoFocus = false,
    this.keyboardType,
    this.onTap,
    this.validator,
    this.prefixIcon, 
     this.minLines=1,
     this.maxLines=1,

  });

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  @override
  void initState() {
    super.initState();
  }

  bool _showPassword = false;

  void _handleShow() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  // all gredient,
  // nature

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && !_showPassword,
      readOnly: widget.readOnly,
      autofocus: widget.autoFocus,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: const TextStyle(fontSize: 14),
      onTapOutside: (val) {
        FocusScope.of(context).unfocus();
      },
      minLines: widget.minLines,
      maxLines: widget.maxLines,

      onTap: widget.onTap,
      decoration: InputDecoration(
        
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: AppPalette.grey,
                ),
                onPressed: _handleShow,
              )
            : null,

        hint: Text(widget.hintText),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ), // balanced padding
      ),
    );
  }
}
