// lib/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Сервис для хранения файлов в Firebase Storage.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Загрузка аватарки пользователя.
  Future<String> uploadAvatar(File file, String uid) async {
    final ref = _storage.ref().child('avatars').child('\$uid.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }

  /// Удаление аватарки пользователя.
  Future<void> deleteAvatar(String uid) async {
    final ref = _storage.ref().child('avatars').child('\$uid.jpg');
    try {
      await ref.delete();
    } catch (_) {
      // Игнорируем, если файла нет
    }
  }
}