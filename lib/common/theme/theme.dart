// lib/common/theme/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.yellow;// Replace with your primary color
  static const Color accentColor = Colors.pink;  // Replace with your accent color
  static const Color backgroundColor = Color(0xFFFFFFFF);       // White background
  static const Color textColorPrimary = Color(0xFF000000);      // Black primary text
  static const Color textColorSecondary = Colors.grey;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    hintColor: Colors.grey.shade400,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: textColorPrimary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: textColorPrimary,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColorPrimary),
      headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColorPrimary),
      headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColorPrimary),
      bodyLarge: TextStyle(fontSize: 16.0, color: textColorPrimary),
      bodyMedium: TextStyle(fontSize: 14.0, color: textColorPrimary),
      bodySmall: TextStyle(fontSize: 12.0, color: textColorSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentColor),
      ),
      labelStyle: TextStyle(color: textColorPrimary),
      hintStyle: TextStyle(color: textColorSecondary),
    ),
  );

  // You can also define a darkTheme if needed
  // static ThemeData darkTheme = ThemeData(...);
}