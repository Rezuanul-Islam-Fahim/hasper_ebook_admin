import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
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
