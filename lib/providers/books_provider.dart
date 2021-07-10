import 'package:flutter/foundation.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/repositories/db_repository.dart';

class Books with ChangeNotifier {
  List<Book?>? _books = [];
  List<Book?>? _recentBooks = [];

  List<Book?>? get books {
    return [..._books!];
  }

  List<Book?>? get recentBooks {
    return [..._recentBooks!];
  }

  void addBookRecent(Book? book) {
    _recentBooks!.insert(0, book);
    _recentBooks!.removeLast();
    notifyListeners();
  }

  Future<void> loadRecentBooks() async {
    List<Book>? _loadedBooks = await DBRepository.getRecentBooks();
    _recentBooks = _loadedBooks;
    notifyListeners();
  }
}
