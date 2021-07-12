import 'package:flutter/material.dart';

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: 12,
    color: Theme.of(context).errorColor,
  );
}

TextStyle dataPanelTitle() {
  return TextStyle(color: Colors.white, fontSize: 15);
}

TextStyle dataPanelValue() {
  return TextStyle(color: Colors.white60, fontSize: 12);
}

TextStyle searchBookItem() {
  return TextStyle(
    fontSize: 15,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  );
}
