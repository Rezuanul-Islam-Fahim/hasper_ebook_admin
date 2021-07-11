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
