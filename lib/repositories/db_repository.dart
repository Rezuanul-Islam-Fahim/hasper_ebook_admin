import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hasper_ebook_admin/models/book.dart';

class DBRepository {
  static Future<String?>? storeBookGetId(Book book) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    DocumentReference reference =
        await fireStore.collection('books').add(book.toMap());

    return reference.id;
  }

  static Future<List<Book>?> fetchBooks({
    String? orderBy,
    bool? desc,
    int? limit,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;

    if (orderBy == null && limit != null) {
      querySnapshot = await fireStore.collection('books').limit(limit).get();
    } else if (orderBy != null && desc != null && limit != null) {
      querySnapshot = await fireStore
          .collection('books')
          .orderBy(orderBy, descending: desc)
          .limit(limit)
          .get();
    }

    List<QueryDocumentSnapshot> docs = querySnapshot!.docs;
    List<Book> recentBooks = docs.map((QueryDocumentSnapshot doc) {
      return Book.fromFirestore(doc);
    }).toList();

    return recentBooks;
  }

  static Future<List<Book>> fetchBooksFromRange({
    int? offset,
    int? limit,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>? querySnapshot =
        await fireStore.collection('books').orderBy('title').get();
    List<QueryDocumentSnapshot> loadedItems = querySnapshot.docs;
    List<Book>? filteredBooks = [];
    int lastIndex = offset! + limit! > loadedItems.length
        ? loadedItems.length
        : offset + limit;

    for (int i = offset; i < lastIndex; i++) {
      filteredBooks.add(
        Book.fromFirestore(loadedItems[i]),
      );
    }

    return filteredBooks;
  }

  static Future<Book?>? findById(String? id) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    DocumentReference reference = fireStore.collection('books').doc(id);
    DocumentSnapshot snapshot = await reference.get();

    return Book.fromFirestore(snapshot);
  }

  static Future<List<Book>?>? searchBooksByKeyword(String? keyword) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await fireStore.collection('books').get();
    List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;
    List<Book> loadedBooks =
        documentSnapshot.map((QueryDocumentSnapshot snapshot) {
      return Book.fromFirestore(snapshot);
    }).toList();

    return keyword!.isNotEmpty
        ? loadedBooks
            .where((Book book) => book.title!.toLowerCase().contains(keyword))
            .toList()
        : [];
  }
}
