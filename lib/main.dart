import 'package:flutter/material.dart';

import 'screens/home_screen/home_screen.dart';

void main() => runApp(HasperEbook());

class HasperEbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasper Ebook Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
