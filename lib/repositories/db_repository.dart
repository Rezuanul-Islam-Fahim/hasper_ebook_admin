import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hasper_ebook_admin/models/book.dart';

class DBRepository {
  static Future<void> storeBookGetId(Book book) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    await _fireStore.collection('books').add({
      'title': book.title,
      'pdfUrl': book.pdfUrl,
      'coverPhotoUrl': book.coverPhotoUrl,
      'pages': book.pages,
      'description': book.description,
    });
  }
}
