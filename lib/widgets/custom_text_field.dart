import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final double scaleX;
  final double scaleY;
  final String hintText;
  final bool isPassword;
  final bool enableToggle;
  final TextEditingController controller;
  final double? width; // кастомная ширина
  final double? height; // кастомная высота

  const CustomTextField({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.hintText,
    this.isPassword = false,
    this.enableToggle = false,
    required this.controller,
    this.width, // можно передать кастомную ширину
    this.height, // можно передать кастомную высоту
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Если не передана кастомная ширина, используем 356 * scaleX
    final double fieldWidth = widget.width ?? (356 * widget.scaleX);
    // Если не передана кастомная высота, используем 60 * scaleY
    final double fieldHeight = widget.height ?? (60 * widget.scaleY);
    return Container(
      width: fieldWidth,
      height: fieldHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15 * widget.scaleX),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            25 * widget.scaleX,
            16 * widget.scaleY,
            25 * widget.scaleX,
            16 * widget.scaleY,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w600,
            fontSize: 18 * widget.scaleX,
            height: 28 / 18,
            letterSpacing: -0.18 * widget.scaleX,
            color: const Color(0xFF979AA0),
          ),
          border: InputBorder.none,
          suffixIcon: widget.isPassword && widget.enableToggle
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF979AA0),
                    size: 24 * widget.scaleX,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        style: TextStyle(
          fontFamily: 'Jost',
          fontWeight: FontWeight.w600,
          fontSize: 18 * widget.scaleX,
          height: 28 / 18,
          letterSpacing: -0.18 * widget.scaleX,
          color: const Color(0xFF596574),
        ),
      ),
    );
  }
}
