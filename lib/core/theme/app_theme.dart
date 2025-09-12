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
      backgroundColor: AppPalette.background,
      //  AppPalette.primaryColor,
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
}
