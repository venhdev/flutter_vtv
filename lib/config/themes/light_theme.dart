import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFDF5),
    primary: Colors.black87,
    primaryContainer: Color(0xFFFFC600),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      primaryContainer: Color(0xFFFFC600),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF0DF9E),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
);
