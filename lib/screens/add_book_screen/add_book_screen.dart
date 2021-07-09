import 'package:flutter/material.dart';

import 'components/description_field.dart';
import 'components/general_text_field.dart';

class AddBookScreen extends StatefulWidget {
  static const String routeName = '/add-book';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

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
            onPressed: () {},
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
                GeneralTextField(
                  title: 'Enter Book Title',
                  placeHolder: 'Book Title',
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  child: Text('Select PDF'),
                  onPressed: () {},
                ),
                SizedBox(height: 15),
                GeneralTextField(
                  title: 'Enter Book Pages',
                  placeHolder: 'Number of Pages',
                  isNumbered: true,
                ),
                SizedBox(height: 15),
                DescriptionField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
