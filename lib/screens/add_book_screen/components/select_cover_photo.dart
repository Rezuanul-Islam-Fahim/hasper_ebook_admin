import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectCoverPhoto extends StatefulWidget {
  const SelectCoverPhoto({this.handler});

  final Function? handler;

  @override
  _SelectCoverPhotoState createState() => _SelectCoverPhotoState();
}

class _SelectCoverPhotoState extends State<SelectCoverPhoto> {
  File? _imageFile;

  Future<void> _selectImage() async {
    PickedFile? _pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
      widget.handler!(_imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: _imageFile != null
              ? Image.file(_imageFile!, fit: BoxFit.cover)
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'No Image Selected',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 60),
        TextButton.icon(
          icon: Icon(Icons.photo_rounded),
          label: Text('Select Photo'),
          onPressed: _selectImage,
        ),
      ],
    );
  }
}
