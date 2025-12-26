import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007F80);
  static const Color secondaryColor = Color(
    0xFF2D3E50,
  ); // Dark Blue/Grey for text
  static const Color backgroundColor = Color(
    0xFFF5F6F8,
  ); // Light grey background
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: backgroundColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
        bodyLarge: TextStyle(color: secondaryColor),
        bodyMedium: TextStyle(color: secondaryColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: secondaryColor),
        titleTextStyle: GoogleFonts.inter(
          color: secondaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      /* cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        margin: EdgeInsets.zero,
      ), */
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}
