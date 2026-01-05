import 'package:flutter/material.dart';

class AppTheme {
  // Color palette
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFFF6584);
  static const Color accentColor = Color(0xFF4ECDC4);
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color surfaceColor = Colors.white;
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFAB00);
  static const Color errorColor = Color(0xFFFF5252);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D8FF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF9A56)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF44A8A5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        margin: const EdgeInsets.all(8),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
