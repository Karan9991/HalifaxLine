import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadAvatar(String uid, File file) async {
    final ref = _storage.ref().child('avatars/$uid.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
    }

  Future<void> deleteAvatar(String uid) async {
    final ref = _storage.ref().child('avatars/$uid.jpg');
    await ref.delete().catchError((_) {});
  }
}