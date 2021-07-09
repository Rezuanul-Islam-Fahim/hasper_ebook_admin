import 'package:flutter/material.dart';

import 'screens/add_book_screen/add_book_screen.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    AddBookScreen.routeName: (_) => AddBookScreen(),
  };
}
