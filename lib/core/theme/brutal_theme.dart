import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrutalTheme {
  // Brutalism Color Palette
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color accentRed = Color(0xFFFF0000);
  static const Color warningYellow = Color(0xFFFFFF00);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF333333);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBlack,
      primaryColor: primaryWhite,
      colorScheme: const ColorScheme.dark(
        primary: primaryWhite,
        secondary: accentRed,
        surface: darkGray,
        error: accentRed,
      ),

      // Брутальная типографика
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 96,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.bebasNeue(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.bebasNeue(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
        ),
        headlineLarge: GoogleFonts.robotoCondensed(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: primaryWhite,
          letterSpacing: 0.5,
        ),
        headlineMedium: GoogleFonts.robotoCondensed(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: primaryWhite,
        ),
        titleLarge: GoogleFonts.robotoCondensed(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryWhite,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: primaryWhite,
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
          letterSpacing: 1.2,
        ),
      ),

      // Кнопки в брутальном стиле
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryWhite,
          foregroundColor: primaryBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Острые углы
          ),
          elevation: 0,
          textStyle: GoogleFonts.robotoCondensed(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryWhite,
          side: const BorderSide(color: primaryWhite, width: 3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: GoogleFonts.robotoCondensed(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: primaryWhite, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: primaryWhite, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: accentRed, width: 3),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: accentRed, width: 2),
        ),
        labelStyle: GoogleFonts.robotoCondensed(
          color: primaryWhite,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: GoogleFonts.roboto(
          color: mediumGray,
        ),
      ),

      // SnackBar для ошибок
      snackBarTheme: SnackBarThemeData(
        backgroundColor: accentRed,
        contentTextStyle: GoogleFonts.robotoCondensed(
          color: primaryWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: darkGray,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: primaryWhite, width: 2),
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlack,
        foregroundColor: primaryWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
