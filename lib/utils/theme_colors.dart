import 'package:flutter/material.dart';

class AppTheme {
  // ------------------------------------------------------------
  // 🎨 BASE COLORS
  // ------------------------------------------------------------
  static const Color primary = Color(0xFF00C853); // Purple/Blue
  static const Color userGreen = Color(0xFF38EF7D);// Time share green
  static const Color userOrange = Color(0xFF00E676);
  //static const Color hostBlue = Color(0xFF4E54C8);
  static const Color useBlack = Color(0xFF000000);// Host button
  static const Color sheetBackground = Colors.white;
  static const Color sheetHandle = Colors.grey;

  // ------------------------------------------------------------
  // ✍️ TEXT STYLES
  // ------------------------------------------------------------

  // Big Headings
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // General body text
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Bold button text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ------------------------------------------------------------
  // 🎯 FULL THEME DATA (Colors, Fonts, etc)
  // ------------------------------------------------------------
  static final ThemeData themeData = ThemeData(
    fontFamily: 'Poppins', // optional: remove if not using poppins
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        textStyle: WidgetStateProperty.all(buttonText),
      ),
    ),
  );
}
