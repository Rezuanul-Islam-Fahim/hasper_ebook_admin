import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:provider/provider.dart';

class RecentBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Book?>? _recentBooks = Provider.of<Books>(context).recentBooks;

    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _recentBooks!.map((Book? book) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Text(book!.title!),
          );
        }).toList(),
      ),
    );
  }
}
