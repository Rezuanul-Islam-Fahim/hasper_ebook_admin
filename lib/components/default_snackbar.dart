import 'package:flutter/material.dart';

SnackBar? defaultSnackbar(String? title) {
  return SnackBar(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    content: Text(title!),
  );
}
