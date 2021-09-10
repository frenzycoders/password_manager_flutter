// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomThemes {
  static String appName = 'ConnectU';
  static Color lightPrimary = const Color(0xfff3f4f9);
  static Color darkPrimary = const Color(0xff2B2B2B);
  static Color lightAccent = const Color(0xfff3f4f9);
  static Color darkAccent = const Color(0xff597ef7);
  static Color lightBG = const Color(0xfff3f4f9);
  static Color darkBG = const Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      titleSpacing: 20,
      elevation: 0,
      color: lightPrimary,
      titleTextStyle: const TextStyle(color: Colors.blueGrey,fontSize: 20,fontWeight: FontWeight.bold),
      textTheme: TextTheme(),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      color: darkPrimary,
      elevation: 0,
      titleTextStyle: const TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.bold),
      // ignore: prefer_const_constructors
      textTheme: TextTheme(),
    ),
  );
}
