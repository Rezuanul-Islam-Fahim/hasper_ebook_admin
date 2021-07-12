import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hasper_ebook_admin/components/default_snackbar.dart';
import 'package:hasper_ebook_admin/models/book.dart';
import 'package:hasper_ebook_admin/providers/books_provider.dart';
import 'package:hasper_ebook_admin/repositories/db_repository.dart';
import 'package:hasper_ebook_admin/repositories/upload_file_repository.dart';
import 'package:hasper_ebook_admin/styles.dart';
import 'package:hasper_ebook_admin/utils/connectivity.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

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
  bool? _isLoading = false;
  Book? book = Book(
    id: null,
    title: null,
    pdfUrl: null,
    coverPhotoUrl: null,
    language: null,
    pages: null,
    description: null,
    dateTime: DateTime.now(),
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
        await NetworkStatus.checkStatus();

        setState(() {
          _isLoading = true;
        });

        String? pdfURL = await UploadFileRepository.uploadGetUrl(
          fileType: 'pdf',
          file: _selectedPdf,
          fileExtension: path.extension(_selectedPdf!.path),
        );
        String? coverPhotoUrl = await UploadFileRepository.uploadGetUrl(
          fileType: 'image',
          file: _selectedImage,
          fileExtension: path.extension(_selectedImage!.path),
        );
        String? bookId = await DBRepository.storeBookGetId(
          Book(
            id: book!.id,
            title: book!.title,
            pdfUrl: pdfURL,
            coverPhotoUrl: coverPhotoUrl,
            language: book!.language,
            pages: book!.pages,
            description: book!.description,
            dateTime: book!.dateTime,
          ),
        );

        book = Book(
          id: bookId,
          title: book!.title,
          pdfUrl: pdfURL,
          coverPhotoUrl: coverPhotoUrl,
          language: book!.language,
          pages: book!.pages,
          description: book!.description,
          dateTime: book!.dateTime,
        );

        Provider.of<Books>(context, listen: false).addBookRecent(book!);
        Provider.of<Books>(context, listen: false).addBookLibrary(book!);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          defaultSnackbar('Successfully Uploaded New Book')!,
        );
      } on ConnectivityException catch (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          defaultSnackbar('No Internet Connection Available')!,
        );
      } catch (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          defaultSnackbar('An Error Occurred')!,
        );
      }
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
      language: book!.language,
      pages: book!.pages,
      description: value,
      dateTime: book!.dateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          splashRadius: 22,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Book', style: appBarTitle()),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.upload_rounded, color: Colors.white),
            label: Text(
              'Upload',
              style: actionButtonText(),
            ),
            onPressed: _uploadBook,
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
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
                          language: book!.language,
                          pages: book!.pages,
                          description: book!.description,
                          dateTime: book!.dateTime,
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
                          language: book!.language,
                          pages: int.parse(value!),
                          description: book!.description,
                          dateTime: book!.dateTime,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Text('Enter Book Language'),
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      decoration: generalFieldDecoration('Language'),
                      onSaved: (String? value) {
                        book = Book(
                          id: book!.id,
                          title: book!.title,
                          pdfUrl: book!.pdfUrl,
                          coverPhotoUrl: book!.coverPhotoUrl,
                          language: value,
                          pages: book!.pages,
                          description: book!.description,
                          dateTime: book!.dateTime,
                        );
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Book language must not be empty';
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
          if (_isLoading!)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white70,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Uploading New Book...',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
