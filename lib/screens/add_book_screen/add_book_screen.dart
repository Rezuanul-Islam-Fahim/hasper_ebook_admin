import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/books.dart';

import 'components/description_field.dart';
import 'components/general_field_decoration.dart';

class AddBookScreen extends StatefulWidget {
  static const String routeName = '/add-book';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Book book = Book(
    id: null,
    title: null,
    pages: null,
    description: null,
  );

  void uploadBook() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(book.id);
      print(book.title);
      print(book.pages);
      print(book.description);
    }
  }

  void getDescription(String? value) {
    book = Book(
      id: book.id,
      title: book.title,
      pages: book.pages,
      description: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              splashRadius: 22,
              onPressed: () => Navigator.of(context).pop(),
            );
          },
        ),
        title: Text(
          'Add Book',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.upload_rounded, color: Colors.black87),
            label: Text(
              'Upload',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: uploadBook,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Text('Enter Book Title'),
                ),
                SizedBox(height: 6),
                TextFormField(
                  decoration: generalFieldDecoration('Book Title'),
                  onSaved: (String? value) {
                    book = Book(
                      id: book.id,
                      title: value,
                      pages: book.pages,
                      description: book.description,
                    );
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Title must not be empty';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  child: Text('Select PDF'),
                  onPressed: () {},
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Text('Enter Book Pages'),
                ),
                SizedBox(height: 6),
                TextFormField(
                  decoration: generalFieldDecoration('Number of Pages'),
                  keyboardType: TextInputType.number,
                  onSaved: (String? value) {
                    book = Book(
                      id: book.id,
                      title: book.title,
                      pages: int.parse(value!),
                      description: book.description,
                    );
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Number of pages must not be empty';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    } else if (int.parse(value) <= 0) {
                      return 'Please enter a number greater than zero(0)';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 15),
                DescriptionField(getDescription),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
