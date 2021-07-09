import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/home_screen/home_screen.dart';
import 'theme.dart';

void main() => runApp(HasperEbook());

class HasperEbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hasper Ebook Admin',
      theme: theme(),
      home: HomeScreen(),
      routes: routes(),
    );
  }
}
