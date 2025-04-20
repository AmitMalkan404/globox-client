import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0B1C2C),
  primaryColor: Color(0xFF00B8D9),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00B8D9),
    secondary: Color(0xFF1FC195),
    background: Color(0xFF0B1C2C),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFFAAB8C2)),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0B1C2C),
    iconTheme: IconThemeData(color: Color(0xFF00B8D9)),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF00B8D9),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
