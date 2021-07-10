import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadRepository {
  static Future<String?>? uploadGetUrl({
    String? fileType,
    File? file,
    String? fileExtension,
  }) async {
    final String? _rawFolder = fileType == 'pdf' ? 'pdfs' : 'coverImages';
    final String? _filePrefix = fileType == 'pdf' ? 'pdf' : 'image';
    final DateTime _datentime = DateTime.now();
    final FirebaseStorage _storage = FirebaseStorage.instance;

    TaskSnapshot _uploadTaskSnapshot = await _storage
        .ref('$_rawFolder')
        .child(
          '${_filePrefix}_${_datentime.millisecondsSinceEpoch}$fileExtension',
        )
        .putFile(file!);

    String _fileURL = await _uploadTaskSnapshot.ref.getDownloadURL();

    return _fileURL;
  }
}
