import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:hasper_ebook_admin/screens/book_details_screen/book_details_screen.dart';
import 'package:provider/provider.dart';

class RecentBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Book?>? _recentBooks = Provider.of<Books>(context).recentBooks;

    return Container(
      height: 230,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        children: _recentBooks!.map((Book? book) {
          return BookItem(book);
        }).toList(),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  const BookItem(this.book);

  final Book? book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        BookDetailsScreen.routeName,
        arguments: book,
      ),
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                width: 140,
                height: 165,
                decoration: BoxDecoration(
                  color: Color(0xFFd8e0e7),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 95,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500]!,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        book!.coverPhotoUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  book!.title!,
                  style: Theme.of(context).textTheme.headline6!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
