import 'package:flutter/foundation.dart';

class Book {
  const Book({
    @required this.id,
    @required this.title,
    @required this.pdfUrl,
    @required this.coverPhotoUrl,
    @required this.pages,
    @required this.description,
  });

  final String? id;
  final String? title;
  final String? pdfUrl;
  final String? coverPhotoUrl;
  final int? pages;
  final String? description;
}
