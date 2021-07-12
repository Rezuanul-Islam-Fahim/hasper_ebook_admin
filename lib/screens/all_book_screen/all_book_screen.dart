import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hasper_ebook_admin/screens/all_book_screen/components/body.dart';
import 'package:hasper_ebook_admin/utils/search.dart';

class AllBookScreen extends StatelessWidget {
  static const String routeName = '/all-book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Books'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.white,
            ),
            splashRadius: 22,
            onPressed: () => showSearch(
              context: context,
              delegate: Search(),
            ),
          ),
        ],
      ),
      body: AllBookScreenBody(),
    );
  }
}
