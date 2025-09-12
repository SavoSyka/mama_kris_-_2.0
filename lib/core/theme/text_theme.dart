import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextTheme textTheme([TextTheme? overrides]) {
    final base = GoogleFonts.manropeTextTheme();

    if (overrides == null) return base;

    return base.copyWith(
      bodyLarge: base.bodyLarge?.merge(overrides.bodyLarge),
      bodyMedium: base.bodyMedium?.merge(overrides.bodyMedium),
      titleLarge: base.titleLarge?.merge(overrides.titleLarge),
      // add more if you need
    );
  }
}
