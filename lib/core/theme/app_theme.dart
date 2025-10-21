import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/text_theme.dart';

class AppTheme {
  AppTheme._(); // private constructor

  /// 🌞 Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppPalette.primaryColor,
    scaffoldBackgroundColor: AppPalette.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.white,
      //  AppPalette.primaryColor,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppPalette.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppPalette.primaryColor,

        //  AppPalette.white
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppPalette.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppPalette.whiteGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPalette.whiteGrey, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPalette.whiteGrey, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),

    // textTheme: AppFonts.textTheme,
    textTheme: AppFonts.textTheme(
      const TextTheme(
        bodyLarge: TextStyle(color: AppPalette.black),
        bodyMedium: TextStyle(color: AppPalette.black),
        titleLarge: TextStyle(
          color: AppPalette.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: AppPalette.greyDark),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppPalette.primaryColor,
      foregroundColor: AppPalette.white,
    ),
    cardColor: AppPalette.white,
    dividerColor: AppPalette.greyLight,
    colorScheme: const ColorScheme.light(
      primary: AppPalette.primaryColor,
      secondary: AppPalette.accent,
      surface: AppPalette.background,
      error: AppPalette.error,
    ),
  );

  /// 🌑 Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppPalette.primaryColor,
    scaffoldBackgroundColor: AppPalette.black,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.black,
      foregroundColor: AppPalette.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPalette.white),
    ),
    textTheme: AppFonts.textTheme(
      const TextTheme(
        bodyLarge: TextStyle(color: AppPalette.white),
        bodyMedium: TextStyle(color: AppPalette.white),
        titleLarge: TextStyle(
          color: AppPalette.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppPalette.black.withValues(alpha: 0.5),
      filled: true,
      hintStyle: GoogleFonts.openSans(color: AppPalette.greyLight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppPalette.whiteGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPalette.whiteGrey, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPalette.whiteGrey, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
    iconTheme: const IconThemeData(color: AppPalette.grey),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppPalette.primaryColor,
      foregroundColor: AppPalette.white,
    ),
    cardColor: AppPalette.greyDark,
    dividerColor: AppPalette.grey,
    colorScheme: const ColorScheme.dark(
      primary: AppPalette.primaryColor,
      secondary: AppPalette.accent,
      surface: AppPalette.black,
      error: AppPalette.error,
    ),
  );

  /// 🎨 Gradient Colors for Backgrounds and Buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFfF6FEF7), Color(0xFfCEE5DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFA500)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF56AB2F), Color(0xFFA8E6CF)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration primaryColordecoration = BoxDecoration(
    color: AppPalette.primaryColor,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0xff2e786633),
        offset: Offset(0, 1),
        blurRadius: 4,
      ),
    ],
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppPalette.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0xff2e786633),
        offset: Offset(0, 1),
        blurRadius: 4,
      ),
    ],
  );
}
