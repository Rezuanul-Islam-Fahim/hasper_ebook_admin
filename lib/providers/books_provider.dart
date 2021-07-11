import 'package:flutter/foundation.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/repositories/db_repository.dart';

class Books with ChangeNotifier {
  List<Book?>? _allBook = [];
  List<Book?>? _recentBooks = [];
  List<Book?>? _libraryBooks = [];

  List<Book?>? get allBook {
    return [..._allBook!];
  }

  List<Book?>? get recentBooks {
    return [..._recentBooks!];
  }

  List<Book?>? get libraryBooks {
    return [..._libraryBooks!];
  }

  void addBookRecent(Book? book) {
    _recentBooks!.insert(0, book);
    _recentBooks!.removeLast();
    notifyListeners();
  }

  Future<void> loadRecentBooks() async {
    List<Book>? _loadedBooks = await DBRepository.fetchBooks(
      orderBy: 'dateTime',
      desc: true,
      limit: 6,
    );
    _recentBooks = _loadedBooks;
    notifyListeners();
  }

  Future<void> loadLibraryBooks() async {
    List<Book>? _loadedBooks = await DBRepository.fetchBooks(limit: 10);
    _libraryBooks = _loadedBooks;
    notifyListeners();
  }
}
