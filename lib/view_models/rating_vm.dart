// lib/view_models/rating_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/user.dart';

class RatingViewModel extends ChangeNotifier {
  /// Сервис для работы с Firestore
  final FirestoreService _fs;

  /// Флаг загрузки
  bool isLoading = false;

  /// Флаг ошибки
  bool hasError = false;

  /// Список пользователей для рейтинга
  List<AppUser> users = [];

  /// Конструктор принимает FirestoreService
  RatingViewModel(this._fs);

  /// Загружает топ-100 пользователей из Firestore
  Future<void> loadUsers() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      users = await _fs.fetchUsers(limit: 100);
    } catch (e) {
      hasError = true;
      debugPrint('Error loading users for rating: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
