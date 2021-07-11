import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1d212b),
      elevation: 0,
      brightness: Brightness.dark,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline5: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyText1: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
  );
}
