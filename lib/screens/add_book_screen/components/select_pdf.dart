import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class SelectPdf extends StatefulWidget {
  const SelectPdf({this.handler});

  final Function? handler;

  @override
  _SelectPdfState createState() => _SelectPdfState();
}

class _SelectPdfState extends State<SelectPdf> {
  String? imageName;

  Future<void> _selectPdf() async {
    FilePickerResult? _pickedFile = await FilePicker.platform.pickFiles();

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
    return Row(
      children: [
        ElevatedButton(
          child: Text('Select PDF'),
          onPressed: _selectPdf,
        ),
        SizedBox(width: 20),
        Text(imageName != null ? imageName! : 'No Pdf Selected'),
      ],
    );
  }
}
