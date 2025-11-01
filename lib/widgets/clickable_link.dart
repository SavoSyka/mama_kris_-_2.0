// lib/widgets/clickable_text.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  final double scaleX;
  final double scaleY;
  final String text;
  final VoidCallback onTap;
  final Color normalColor;
  final Color pressedColor;
  final TextStyle? style;

  const ClickableText({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.text,
    required this.onTap,
    this.normalColor = const Color(0xFF00A80E), // Цвет #00A80E
    this.pressedColor = const Color(0xFF009E0C), // При нажатии чуть темнее
    this.style,
  });

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _isPressed = false;
  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTapDown = (_) {
        setState(() {
          _isPressed = true;
        });
      }
      ..onTapUp = (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      }
      ..onTapCancel = () {
        setState(() {
          _isPressed = false;
        });
      };
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ??
        TextStyle(
          fontFamily: 'Jost',
          fontWeight: FontWeight.w400,
          fontSize: 14 * widget.scaleX,
          height: 20 / 14,
          letterSpacing: -0.1 * widget.scaleX,
          color: Colors.black,
        );
    final clickableStyle = baseStyle.copyWith(
      color: _isPressed ? widget.pressedColor : widget.normalColor,
      decoration: TextDecoration.underline,
    );

    return RichText(
      text: TextSpan(
        text: widget.text,
        style: clickableStyle,
        recognizer: _tapRecognizer,
      ),
    );
  }
}
