import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

class AppTheme {
  // --- Colors from your Definitions ---

  // Neo Purple Galaxy Theme Colors (Light Theme)
  static const Color primaryColor = Color(0xFF2A1B3D);  // Deep Purple Base
  static const Color accentColor = Color(0xFF8A2BE2);   // Electric Purple
  static const Color backgroundColor = Color(0xFF1A0B2E); // Dark Galaxy
  static const Color surfaceColor = Color(0xFF44318D);   // Rich Purple
  static const Color highlightColor = Color(0xFFA4508B); // Nebula Pink
  static const Color errorColor = Color(0xFFE94560);     // Cosmic Red
  static final Color greyColor = Colors.grey.shade200; // From Old

  // Glass Black Fade Theme Colors (Dark Theme)
  static const Color darkPrimaryColor = Color(0xFF0A0A0A);  // Almost Black
  static const Color darkAccentColor = Color(0xFF444444);   // Dark Gray
  static const Color darkBackgroundColor = Color(0xFF000000); // Pure Black
  static const Color darkSurfaceColor = Color(0xFF111111);   // Very Dark Gray
  static const Color darkHighlightColor = Color(0xFF333333); // Dark Gray Highlight

  // --- Added Text Colors (From "New Code") ---
  // Use these manually where Theme.of(context) doesn't provide the exact shade needed
  static const Color textPrimaryColorLight = Colors.white; // Light text for your dark "light theme" bg/surface
  static const Color textSecondaryColorLight = Colors.white70;
  static const Color textPrimaryColorDark = Color(0xFFE1E1E1); // Primary light text for dark theme
  static const Color textSecondaryColorDark = Color(0xFFB0B0B0); // Secondary light text for dark theme

  // --- Gradients from your Definitions ---
  static const gradientColors = [ // Light Theme Gradient
    Color(0xFF2A1B3D), Color(0xFF44318D), Color(0xFF8A2BE2),
  ];
  static const darkGradientColors = [ // Dark Theme Gradient
    Color(0xFF000000), Color(0xFF0A0A0A), Color(0xFF222222),
  ];

  // --- Static InputDecoration (From "New Code") ---
  // This defines the style when you *explicitly* call AppTheme.inputDecoration(...)
  static InputDecoration inputDecoration({
    required String hintText,
    String? labelText,
    required bool isDarkMode,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    // Using the top-level AppTheme constants directly here as defined in the "New Code" version
    final Color currentAccent = isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor;
    final Color currentHintColor = isDarkMode ? AppTheme.textSecondaryColorDark.withOpacity(0.7) : AppTheme.textSecondaryColorLight.withOpacity(0.7);
    final Color currentPrefixIconColor = isDarkMode ? AppTheme.textSecondaryColorDark : AppTheme.accentColor;
    final Color currentFillColor = isDarkMode ? Colors.white.withOpacity(0.05) : AppTheme.surfaceColor.withOpacity(0.1); // Matches "New Code" version
    final Color currentEnabledBorderColor = isDarkMode ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.3);
    final Color currentFocusedBorderColor = currentAccent;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: currentHintColor),
      hintStyle: TextStyle(color: currentHintColor),
      filled: true,
      fillColor: currentFillColor,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: currentPrefixIconColor) : null,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: currentEnabledBorderColor.withOpacity(0.5), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: currentEnabledBorderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: currentFocusedBorderColor, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 1.2),
        ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.errorColor, width: 1.8),
      ),
      errorStyle: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.w500),
    );
  }

  // Method to get ThemeData (Same as before)
  static ThemeData getThemeData(bool isDark) {
    return isDark ? _darkTheme : _lightTheme;
  }

  // --- Light Theme Definition (FROM "OLD CODE") ---
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor, // Uses top-level constant
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white, // Old definition used white background
      error: errorColor,
      // Add on... colors based on the above standard light scheme
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black, // Text on white background
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white, // Old definition used white
    appBarTheme: const AppBarTheme( // Old definition
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins', // Replace font
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
       systemOverlayStyle: SystemUiOverlayStyle.dark, // Dark icons for light status bar
    ),
    bottomSheetTheme: const BottomSheetThemeData( // Old definition
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardTheme: CardTheme( // Old definition
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dialogTheme: DialogTheme( // Added default light dialog theme
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
      contentTextStyle: TextStyle(color: Colors.black87, fontSize: 16, fontFamily: 'Poppins'),
    ),
    inputDecorationTheme: InputDecorationTheme( // Old definition
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
        borderSide: BorderSide(color: accentColor, width: 1), // Uses accentColor constant
      ),
      hintStyle: TextStyle(color: Colors.grey.shade600), // Default hint
      labelStyle: TextStyle(color: Colors.black54), // Default label
      errorStyle: TextStyle(color: errorColor), // Use errorColor constant
    ),
    elevatedButtonTheme: ElevatedButtonThemeData( // Old definition
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor, // Use primaryColor constant
        foregroundColor: Colors.white, // Text on button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
         textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600) // Replace font
      ),
    ),
     textButtonTheme: TextButtonThemeData( // Added default light TextButtonTheme
        style: TextButton.styleFrom(
      foregroundColor: accentColor, // Use accentColor constant
      textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600), // Replace font
    )),
    iconTheme: const IconThemeData( // Added default light IconTheme
      color: Colors.black54, // Default icon color
    ),
    dividerTheme: DividerThemeData( // Added default light DividerTheme
      color: Colors.grey.shade300,
    ),
    // It's still recommended to define a TextTheme
    textTheme: const TextTheme().apply(fontFamily: 'Poppins', bodyColor: Colors.black87, displayColor: Colors.black), // Replace font
  );

  // --- Dark Theme Definition (FROM "OLD CODE") ---
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor, // Your top-level constant
    colorScheme: ColorScheme.dark( // Old definition
      primary: Colors.white,
      secondary: Colors.grey.shade200,
      surface: darkSurfaceColor.withOpacity(0.7), // Uses darkBackgroundColor constant
      error: errorColor, // Uses errorColor constant
      onPrimary: darkPrimaryColor,
      onSecondary: darkPrimaryColor,
      onSurface: Colors.white,
      onError: Colors.black, // Text on error
    ),
    scaffoldBackgroundColor: darkBackgroundColor, // Uses darkBackgroundColor constant
    appBarTheme: AppBarTheme( // Old definition
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins', // Replace font
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomSheetTheme: BottomSheetThemeData( // Old definition
      backgroundColor: darkSurfaceColor.withOpacity(0.7), // Uses darkSurfaceColor constant
      modalBackgroundColor: darkSurfaceColor.withOpacity(0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogTheme( // Old definition
      backgroundColor: darkSurfaceColor.withOpacity(0.8), // Uses darkSurfaceColor constant
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       titleTextStyle: TextStyle(color: textPrimaryColorDark, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'), // Use new text color
      contentTextStyle: TextStyle(color: textSecondaryColorDark, fontSize: 16, fontFamily: 'Poppins'), // Use new text color
    ),
    cardTheme: CardTheme( // Old definition
      color: darkSurfaceColor.withOpacity(0.5), // Uses darkSurfaceColor constant
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme( // Old definition
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
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
       errorStyle: TextStyle(color: errorColor), // Use errorColor constant
    ),
    elevatedButtonTheme: ElevatedButtonThemeData( // Old definition
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.15),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600) // Replace font
      ),
    ),
    textButtonTheme: TextButtonThemeData( // Old definition
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600), // Replace font
      ),
    ),
    iconTheme: const IconThemeData( // Old definition
      color: Colors.white,
    ),
    dividerTheme: DividerThemeData( // Old definition
      color: Colors.white.withOpacity(0.1),
    ),
    // It's still recommended to define a TextTheme
     textTheme: const TextTheme().apply(fontFamily: 'Poppins', bodyColor: Colors.white, displayColor: Colors.white), // Replace font
  );
}