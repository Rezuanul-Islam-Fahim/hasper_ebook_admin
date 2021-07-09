import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hasper_ebook_admin/styles.dart';
import 'package:path/path.dart' as path;

class SelectPdf extends StatefulWidget {
  const SelectPdf({this.handler, this.isPdfSelected});

  final Function? handler;
  final bool? isPdfSelected;

  @override
  _SelectPdfState createState() => _SelectPdfState();
}

class _SelectPdfState extends State<SelectPdf> {
  String? imageName;

  Future<void> _selectPdf() async {
    FilePickerResult? _pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (_pickedFile != null) {
      File _file = File(_pickedFile.files.single.path!);
      widget.handler!(_file);
      setState(() {
        imageName = path.basename(_file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              child: Text('Select PDF'),
              onPressed: _selectPdf,
            ),
            SizedBox(width: 20),
            Text(imageName != null ? imageName! : 'No Pdf Selected'),
          ],
        ),
        if (!widget.isPdfSelected!)
          Column(
            children: [
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'Book pdf must not be empty',
                  style: errorTextStyle(context),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
