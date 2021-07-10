import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/repositories/db_repository.dart';
import 'package:hasper_ebook_admin/repositories/upload_file_repository.dart';
import 'package:path/path.dart' as path;

import 'components/description_field.dart';
import 'components/general_field_decoration.dart';
import 'components/select_cover_photo.dart';
import 'components/select_pdf.dart';

class AddBookScreen extends StatefulWidget {
  static const String routeName = '/add-book';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedPdf;
  File? _selectedImage;
  bool? _isImageSelected = true;
  bool? _isPdfSelected = true;
  Book? book = Book(
    id: null,
    title: null,
    pdfUrl: null,
    coverPhotoUrl: null,
    pages: null,
    description: null,
  );

  Future<void> _uploadBook() async {
    setState(() {
      if (_selectedImage == null) {
        _isImageSelected = false;
      } else {
        _isImageSelected = true;
      }
      if (_selectedPdf == null) {
        _isPdfSelected = false;
      } else {
        _isPdfSelected = true;
      }
    });

    if (_formKey.currentState!.validate() &&
        _isImageSelected! &&
        _isPdfSelected!) {
      _formKey.currentState!.save();
      try {
        String? pdfURL = await UploadFileRepository.uploadGetUrl(
          fileType: 'pdf',
          file: _selectedPdf,
          fileExtension: path.extension(_selectedPdf!.path),
        );
        String? imgURL = await UploadFileRepository.uploadGetUrl(
          fileType: 'image',
          file: _selectedImage,
          fileExtension: path.extension(_selectedImage!.path),
        );
        String? bookId = await DBRepository.storeBookGetId(
          Book(
            id: book!.id,
            title: book!.title,
            pdfUrl: pdfURL,
            coverPhotoUrl: imgURL,
            pages: book!.pages,
            description: book!.description,
          ),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An Error Occurred')),
        );
      }

      // book = Book(
      //   if
      // );
      // print(bookId);
      // print(book!.title);
      // print(pdfURL);
      // print(imgURL);
      // print(book!.pages);
      // print(book!.description);
    }
  }

  void _getPdf(File pdf) {
    _selectedPdf = pdf;
    print(_selectedPdf!.path);
  }

  void _getCoverPhoto(File image) {
    _selectedImage = image;
    print(_selectedImage!.path);
  }

  void _getDescription(String? value) {
    book = Book(
      id: book!.id,
      title: book!.title,
      pdfUrl: book!.pdfUrl,
      coverPhotoUrl: book!.coverPhotoUrl,
      pages: book!.pages,
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
            onPressed: _uploadBook,
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
                      id: book!.id,
                      title: value,
                      pdfUrl: book!.pdfUrl,
                      coverPhotoUrl: book!.coverPhotoUrl,
                      pages: book!.pages,
                      description: book!.description,
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
                SelectPdf(handler: _getPdf, isPdfSelected: _isPdfSelected),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Text('Enter Book Cover Photo'),
                ),
                SizedBox(height: 6),
                SelectCoverPhoto(
                  handler: _getCoverPhoto,
                  isImageSelected: _isImageSelected,
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
                      id: book!.id,
                      title: book!.title,
                      pdfUrl: book!.pdfUrl,
                      coverPhotoUrl: book!.coverPhotoUrl,
                      pages: int.parse(value!),
                      description: book!.description,
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
                DescriptionField(_getDescription),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
