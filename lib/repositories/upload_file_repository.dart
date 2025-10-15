import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFileRepository {
  static Future<String?>? uploadGetUrl({
    String? fileType,
    File? file,
    String? fileExtension,
  }) async {
    final String rawFolder = fileType == 'pdf' ? 'pdfs' : 'coverImages';
    final String filePrefix = fileType == 'pdf' ? 'pdf' : 'image';
    final DateTime datentime = DateTime.now();
    final FirebaseStorage storage = FirebaseStorage.instance;

    TaskSnapshot uploadTaskSnapshot = await storage
        .ref(rawFolder)
        .child(
          '${filePrefix}_${datentime.millisecondsSinceEpoch}$fileExtension',
        )
        .putFile(file!);

    String fileURL = await uploadTaskSnapshot.ref.getDownloadURL();

    return fileURL;
  }
}
