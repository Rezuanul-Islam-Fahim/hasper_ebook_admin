import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:provider/provider.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Book?>? _libraryBooks = Provider.of<Books>(context).libraryBooks;

    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
        mainAxisExtent: 240,
      ),
      padding: EdgeInsets.all(15),
      physics: NeverScrollableScrollPhysics(),
      children: _libraryBooks!.map((Book? book) {
        return BookItem(book);
      }).toList(),
    );
  }
}

class BookItem extends StatelessWidget {
  const BookItem(this.book);

  final Book? book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(25),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFFd8e0e7),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 110,
                height: 145,
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
          SizedBox(height: 5),
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
    );
  }
}
