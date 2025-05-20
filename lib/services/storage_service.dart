// lib/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Сервис для хранения файлов в Firebase Storage.
class StorageService {
  // Инициализируем именно тот bucket, где у вас хранятся аватарки:
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://linearity-d5051.appspot.com',
  );

  /// Загрузка (и замена) аватарки пользователя.
  Future<String> uploadAvatar(File file, String uid) async {
    // ➊ маячок: точно ли новый код?
    print('[StorageService] uploadAvatar   uid=$uid');

    // читаем файл в память, чтобы отключить резюме-загрузку
    final bytes = await file.readAsBytes();
    print('[StorageService]   bytes.length=${bytes.length}');

    final ref = _storage.ref().child('avatars').child('$uid.jpg');
    print('[StorageService]   fullPath=${ref.fullPath}  bucket=${ref.bucket}');

    // пытаемся удалить старый аватар, если есть
    try {
      await ref.delete();
    } catch (e) {
      print('[StorageService]   delete old -> $e');
    }

    // загружаем данные одним запросом
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    final snap = await ref.putData(bytes, metadata);
    print('[StorageService]   upload done  size=${snap.totalBytes}');

    final url = await snap.ref.getDownloadURL();
    print('[StorageService]   url=$url');
    return url;
  }

  /// Удаление аватарки пользователя при удалении аккаунта.
  Future<void> deleteAvatar(String uid) async {
    final ref = _storage.ref().child('avatars').child('$uid.jpg');
    try {
      await ref.delete();
    } catch (_) {
      // игнорируем, если файла нет
    }
  }
}
