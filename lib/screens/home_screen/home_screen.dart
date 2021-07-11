import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:provider/provider.dart';

import '../../components/drawer.dart';
import '../../screens/add_book_screen/add_book_screen.dart';
import 'components/recent_books.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? _isinit = false;
  bool? _isLoading = true;

  @override
  void didChangeDependencies() {
    if (!_isinit!) {
      Provider.of<Books>(context, listen: false)
          .loadRecentBooks()
          .then((_) => setState(() {
                _isLoading = false;
              }));
      _isinit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.black87,
              ),
              splashRadius: 22,
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Upload Book',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              AddBookScreen.routeName,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading!
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Recently Uploaded',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 20),
                  RecentBooks(),
                ],
              ),
            ),
    );
  }
}
