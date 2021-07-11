import 'package:flutter/material.dart';

class AllBookScreen extends StatelessWidget {
  static const String routeName = '/all-book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Books',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}
