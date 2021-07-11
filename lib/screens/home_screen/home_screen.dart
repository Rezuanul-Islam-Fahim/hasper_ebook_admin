import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/drawer.dart';
import '../../screens/add_book_screen/add_book_screen.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset('assets/icons/menu.svg',
                  color: Colors.white),
              splashRadius: 22,
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Upload Book',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              AddBookScreen.routeName,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: HomeScreenBody(),
    );
  }
}
