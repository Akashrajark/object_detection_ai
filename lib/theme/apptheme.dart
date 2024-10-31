import 'package:flutter/material.dart';
import 'package:object_detection_ai/value/color.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    surface: backgroundColor,
    secondary: secondaryColor,
    shadow: shadowColor,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColorDarkMode,
    surface: backgroundColorDarkMode,
    secondary: secondaryColorDarkMode,
    shadow: shadowColorDarkMode,
  ),
);
