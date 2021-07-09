import 'package:flutter/material.dart';

class AddBookScreen extends StatelessWidget {
  static const String routeName = '/add-book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              splashRadius: 22,
              onPressed: () => Navigator.of(context).pop(),
            );
          },
        ),
        title: Text(
          'Add Book',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Upload',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
