import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFunction {
  Future<String> uploadFile(File x, String destination) async {
    File file = x;

    try {
      await FirebaseStorage.instance.ref(destination).putFile(file);
      return FirebaseStorage.instance.ref(destination).getDownloadURL();
    } on FirebaseException catch (e) {
      return "Error: " + e.message;
    }
  }
}
