import 'package:flutter/material.dart';

import 'screens/add_book_screen/add_book_screen.dart';
import 'screens/all_book_screen/all_book_screen.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    AddBookScreen.routeName: (_) => AddBookScreen(),
    AllBookScreen.routeName: (_) => AllBookScreen(),
  };
}
