import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Токены из макета Figma «При» (экран «С рекламой предложение» и
/// «Забронировать рекламное место»). Размеры — логические px макета 393×852.
class AdUi {
  AdUi._();

  static const green = Color(0xFF12902A);
  static const darkGreen = Color(0xFF2E7866);
  static const grey = Color(0xFF596574);
  static const greyStroke = Color(0x33596574); // #596574 @ 20%
  static const cardStroke = Color(0xFFDEE0E3);
  static const formBg = Color(0xFFF0FAF2);

  static const shadowGreen = BoxShadow(
    color: Color(0x332E7866),
    offset: Offset(0, 1),
    blurRadius: 4,
  );
  static const shadowSoft = BoxShadow(color: Color(0x1A434343), blurRadius: 4);

  static TextStyle manrope(
    double size,
    FontWeight weight, {
    Color color = Colors.black,
    double? lineHeight,
  }) => GoogleFonts.manrope(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeight == null ? null : lineHeight / size,
    letterSpacing: 0,
  );
}

/// Квадратная кнопка 40×40 (назад / закрыть) из макета.
class AdSmallButton extends StatelessWidget {
  const AdSmallButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AdUi.greyStroke),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330074BC),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AdUi.grey),
      ),
    );
  }
}
