import 'package:flutter/material.dart';

InputDecoration generalFieldDecoration(String? placeHolder) {
  return InputDecoration(
    hintText: placeHolder,
    hintStyle: TextStyle(fontSize: 14),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(6),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}
