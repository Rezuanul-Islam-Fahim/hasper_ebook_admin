import 'package:flutter/material.dart';

import 'screens/add_book_screen/add_book_screen.dart';
import 'screens/all_book_screen/all_book_screen.dart';
import 'screens/book_details_screen/book_details_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/pdf_screen.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    HomeScreen.routeName: (_) => HomeScreen(),
    AddBookScreen.routeName: (_) => AddBookScreen(),
    AllBookScreen.routeName: (_) => AllBookScreen(),
    BookDetailsScreen.routeName: (_) => BookDetailsScreen(),
    PDFScreen.routeName: (_) => PDFScreen(),
  };
}
