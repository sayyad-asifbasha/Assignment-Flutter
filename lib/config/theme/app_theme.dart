import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,

    // Main colors
    primaryColor: Color(0xFF124C2F),
    scaffoldBackgroundColor: Color(0xFFE0E0E0),
    cardColor: Colors.white,
    canvasColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    hintColor: Colors.grey,

    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF124C2F),
      secondary: Color(0xFFC7DED3),
      background: Colors.white,
    ),

    // AppBar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF00341A),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Text theme
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xED3D451A),
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xED3D451A),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
      selectedColor: Color(0xFF124C2F),
      disabledColor: Colors.grey.shade300,
      padding: const EdgeInsets.all(6),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Colors.blue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade300, // background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // removes default line
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xED3D451A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xED3D451A), width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
      labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
  );
}
