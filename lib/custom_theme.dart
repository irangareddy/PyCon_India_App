import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Color constants
const Color primaryColor = Color(0xFF20928D);
const Color secondaryColor = Color(0xFFE9C124);

// Custom color theme
ThemeData customTheme = ThemeData(
  primaryColor: primaryColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: primaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: secondaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  // Add more customizations as needed
);
