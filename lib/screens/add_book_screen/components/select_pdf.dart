import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hasper_ebook_admin/styles.dart';
import 'package:path/path.dart' as path;

class SelectPdf extends StatefulWidget {
  const SelectPdf({super.key, this.handler, this.isPdfSelected});

  final Function? handler;
  final bool? isPdfSelected;

  @override
  SelectPdfState createState() => SelectPdfState();
}

class SelectPdfState extends State<SelectPdf> {
  String? imageName;

  Future<void> _selectPdf() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      File file = File(pickedFile.files.single.path!);
      widget.handler!(file);
      setState(() {
        imageName = path.basename(file.path);
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
              onPressed: _selectPdf,
              child: Text('Select PDF'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                imageName != null ? imageName! : 'No Pdf Selected',
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
