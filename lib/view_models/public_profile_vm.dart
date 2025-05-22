/// lib/view_models/public_profile_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/user.dart';

/// ViewModel публичного профиля пользователя
class PublicProfileViewModel extends ChangeNotifier {
  final FirestoreService _fs;
  final String uid;

  PublicProfileViewModel({
    required FirestoreService firestoreService,
    required this.uid,
  }) : _fs = firestoreService;

  AppUser? _user;
  /// Данные пользователя
  AppUser? get user => _user;

  bool _isLoading = true;
  /// Флаг загрузки
  bool get isLoading => _isLoading;

  bool _hasError = false;
  /// Флаг ошибки при загрузке
  bool get hasError => _hasError;

  /// Загружает данные пользователя из Firestore
  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final fetched = await _fs.getUserById(uid);
      if (fetched == null) {
        _hasError = true;
      } else {
        _user = fetched;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Повторно загружает данные пользователя
  Future<void> retry() async => await load();
}
