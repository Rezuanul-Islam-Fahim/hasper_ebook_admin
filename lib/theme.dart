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
          headline6: TextStyle(fontSize: 18),
          bodyText1: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
  );
}
