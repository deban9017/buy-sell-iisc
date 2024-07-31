import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //upload image
  Future uploadImage(String imagePath, String imageName) async {
    try {
      await _storage.ref(imagePath).putFile(File(imageName));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //download image
  Future<String?> downloadURL(String imagePath) async {
    try {
      return await _storage.ref(imagePath).getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //delete image
  Future deleteImage(String imagePath) async {
    try {
      await _storage.ref(imagePath).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
