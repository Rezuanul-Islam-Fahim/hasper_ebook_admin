import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:hasper_ebook_admin/styles.dart';
import 'package:provider/provider.dart';

import 'components/book_details_header.dart';
import 'components/bottom_sheet.dart';

class BookDetailsScreen extends StatelessWidget {
  static const String routeName = '/book-details';

  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Book book0 = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details', style: appBarTitle()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 22,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<Books>(context).fetchById(book0.id!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          Book book = snapshot.data as Book;

          return SingleChildScrollView(
            child: Column(
              children: [
                BookDetailsHeader(book: book),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 15),
                      Text(book.description!, style: bookDescription()),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: BookBottomSheet(book0.pdfUrl),
    );
  }
}
