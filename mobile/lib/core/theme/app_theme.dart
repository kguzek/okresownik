import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color fertileGreen = Color(0xFF4CAF50);
  static const Color fertileLight = Color(0xFFE8F5E9);
  static const Color intercourseAmber = Color(0xFFFFA000);
  static const Color periodRed = Color(0xFFD32F2F);
  static const Color predictionBlue = Color(0xFF1976D2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryPink,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
