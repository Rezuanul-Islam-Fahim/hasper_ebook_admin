import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hasper_ebook_admin/models/book.dart';

class DBRepository {
  static Future<String?>? storeBookGetId(Book book) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    DocumentReference _reference =
        await _fireStore.collection('books').add(book.toMap());

    return _reference.id;
  }

  static Future<List<Book>?> fetchBooks({
    String? orderBy,
    bool? desc,
    int? limit,
  }) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot;

    if (orderBy == null && limit != null) {
      _querySnapshot = await _fireStore.collection('books').limit(limit).get();
    } else if (orderBy != null && desc != null && limit != null) {
      _querySnapshot = await _fireStore
          .collection('books')
          .orderBy(orderBy, descending: desc)
          .limit(limit)
          .get();
    }

    List<QueryDocumentSnapshot> _docs = _querySnapshot!.docs;
    List<Book> _recentBooks = _docs.map((QueryDocumentSnapshot doc) {
      return Book(
        id: doc.id,
        title: doc.get('title'),
        coverPhotoUrl: doc.get('coverPhotoUrl'),
        pdfUrl: doc.get('pdfUrl'),
        pages: doc.get('pages'),
        description: doc.get('description'),
        dateTime: DateTime.parse(doc.get('dateTime')),
      );
    }).toList();

    return _recentBooks;
  }
}
