import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme buildQuestrialTextTheme(TextTheme base) {
    return GoogleFonts.questrialTextTheme(base).copyWith();
  }

  static ThemeData buildAppTheme({
    required Color primaryColor,
    required Color secondaryColor,
    bool useMaterial3 = false,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
    );

    final base = ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFF070B1E),
    );

    final textTheme = buildQuestrialTextTheme(base.textTheme).apply(
      bodyColor: colorScheme.onPrimary,
      displayColor: colorScheme.onPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      listTileTheme: const ListTileThemeData(),
      appBarTheme: AppBarTheme(
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        centerTitle: false,
        backgroundColor: base.scaffoldBackgroundColor,
        foregroundColor: colorScheme.primary,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme => buildAppTheme(
        primaryColor: const Color(0xFF070B1E),
        secondaryColor: const Color(0xFFd186ff),
      );
}
