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
        language: doc.get('language'),
        pdfUrl: doc.get('pdfUrl'),
        pages: doc.get('pages'),
        description: doc.get('description'),
        dateTime: DateTime.parse(doc.get('dateTime')),
      );
    }).toList();

    return _recentBooks;
  }

  static Future<List<Book>> fetchBooksFromRange({
    int? offset,
    int? limit,
  }) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>? _querySnapshot =
        await _fireStore.collection('books').orderBy('title').get();
    List<QueryDocumentSnapshot> _loadedItems = _querySnapshot.docs;
    List<Book>? _filteredBooks = [];
    int _lastIndex = offset! + limit! > _loadedItems.length
        ? _loadedItems.length
        : offset + limit;

    for (int i = offset; i < _lastIndex; i++) {
      _filteredBooks.add(
        Book(
          id: _loadedItems[i].id,
          title: _loadedItems[i].get('title'),
          coverPhotoUrl: _loadedItems[i].get('coverPhotoUrl'),
          language: _loadedItems[i].get('language'),
          pdfUrl: _loadedItems[i].get('pdfUrl'),
          pages: _loadedItems[i].get('pages'),
          description: _loadedItems[i].get('description'),
          dateTime: DateTime.parse(_loadedItems[i].get('dateTime')),
        ),
      );
    }

    return _filteredBooks;
  }

  static Future<Book?>? findById(String? id) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    DocumentReference _reference = _fireStore.collection('books').doc(id);
    DocumentSnapshot _snapshot = await _reference.get();

    return Book(
      id: _reference.id,
      title: _snapshot.get('title'),
      coverPhotoUrl: _snapshot.get('coverPhotoUrl'),
      pdfUrl: _snapshot.get('pdfUrl'),
      language: _snapshot.get('language'),
      pages: _snapshot.get('pages'),
      description: _snapshot.get('description'),
      dateTime: DateTime.parse(_snapshot.get('dateTime')),
    );
  }
}
