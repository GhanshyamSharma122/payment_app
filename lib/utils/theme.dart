import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemUiOverlayStyle

class AppTheme {
  // Neo Purple Galaxy Theme Colors (Light Theme)
  static const Color primaryColor = Color(0xFF2A1B3D);  // Deep Purple Base
  static const Color accentColor = Color(0xFF8A2BE2);   // Electric Purple
  static const Color backgroundColor = Color(0xFF1A0B2E); // Dark Galaxy
  static const Color surfaceColor = Color(0xFF44318D);   // Rich Purple
  static const Color highlightColor = Color(0xFFA4508B); // Nebula Pink
  static const Color errorColor = Color(0xFFE94560);     // Cosmic Red
  static final Color greyColor = Colors.grey.shade200;

  // Glass Black Fade Theme Colors (Dark Theme)
  static const Color darkPrimaryColor = Color(0xFF0A0A0A);  // Almost Black
  static const Color darkAccentColor = Color(0xFF444444);   // Dark Gray
  static const Color darkBackgroundColor = Color(0xFF000000); // Pure Black
  static const Color darkSurfaceColor = Color(0xFF111111);   // Very Dark Gray
  static const Color darkHighlightColor = Color(0xFF333333); // Dark Gray Highlight
  
  // Light Theme Gradient
  static const gradientColors = [
    Color(0xFF2A1B3D),  // Deep Purple
    Color(0xFF44318D),  // Rich Purple
    Color(0xFF8A2BE2),  // Electric Purple
  ];

  // Glass Black Fade Gradient - Dark Theme
  static const darkGradientColors = [
    Color(0xFF000000),  // Pure Black
    Color(0xFF0A0A0A),  // Almost Black
    Color(0xFF222222),  // Very Dark Gray
  ];

  static ThemeData getThemeData(bool isDark) {
    return isDark ? _darkTheme : _lightTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3 design
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      background: Colors.white,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
        borderSide: BorderSide(color: accentColor, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true, 
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,  // Using white as primary color in dark mode for better contrast
      secondary: Colors.grey.shade200,  // Light gray as secondary color
      surface: darkSurfaceColor.withOpacity(0.7),  // Semi-transparent for glass effect
      background: darkBackgroundColor,
      error: errorColor,
      onPrimary: darkPrimaryColor,  // Text on primary will be dark
      onSecondary: darkPrimaryColor,  // Text on secondary will be dark
      onSurface: Colors.white,  // Text on surface will be white
      onBackground: Colors.white,  // Text on background will be white
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,  // Transparent app bar
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,  // Light status bar icons
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkSurfaceColor.withOpacity(0.7),  // Semi-transparent for glass effect
      modalBackgroundColor: darkSurfaceColor.withOpacity(0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: darkSurfaceColor.withOpacity(0.8),  // Semi-transparent dialogs
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    cardTheme: CardTheme(
      color: darkSurfaceColor.withOpacity(0.5),  // Semi-transparent cards for glass effect
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),  // Very subtle white for glass effect
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      hintStyle: const TextStyle(color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.15),  // Semi-transparent buttons
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
    ),
  );
}