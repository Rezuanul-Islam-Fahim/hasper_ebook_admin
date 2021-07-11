import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/screens/all_book_screen/components/body.dart';

class AllBookScreen extends StatelessWidget {
  static const String routeName = '/all-book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Books'),
      ),
      body: AllBookScreenBody(),
    );
  }
}
