import 'package:flutter/foundation.dart';

class Book {
  const Book({
    @required this.id,
    @required this.title,
    @required this.pages,
    @required this.description,
  });

  final String? id;
  final String? title;
  final int? pages;
  final String? description;
}
