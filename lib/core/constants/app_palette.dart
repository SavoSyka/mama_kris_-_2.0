import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppPalette {
  AppPalette._(); // private constructor to prevent instantiation

  // 🔵 Primary Colors
  static const Color primaryColor = Color(0xFF12902A); // Facebook blue
  static const Color secondaryColor = Color(0xFF0074BC); // Facebook blue

  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF42A5F5);

  // ⚫ Neutral / Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // 🌑 Shades of Gray
  static const Color whiteGrey = Color(0xFFE3E3E3);

  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF424242);

  // ❤️ Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // 🔵 Facebook Theme Extras
  static const Color storyBorder = Color(0xFF12902A);
  static const Color likeButton = Color(0xFFE53935);
}
