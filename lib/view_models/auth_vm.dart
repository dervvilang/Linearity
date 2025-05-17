// lib/view_models/auth_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/models/user.dart';
import 'package:linearity/services/auth_service.dart';

/// ViewModel для авторизации и работы с текущим пользователем.
class AuthViewModel extends ChangeNotifier {
  final AuthService _service;

  /// Текущий авторизованный пользователь или null, если не в системе.
  AppUser? user;

  /// Флаг загрузки (например, запрос к сети).
  bool isLoading = true;

  /// Текст последней ошибки.
  String? error;

  AuthViewModel({AuthService? service})
      : _service = service ?? AuthService() {
    // Слушаем изменения авторизационного состояния
    _service.user.listen((appUser) {
      user = appUser;
      isLoading = false;
      notifyListeners();
    });
  }

  /// Регистрация нового пользователя.
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      user = await _service.signUp(
        email: email,
        password: password,
        username: username,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Вход существующего пользователя.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      user = await _service.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Выход из аккаунта.
  Future<void> logout() async {
    await _service.signOut();
    // После signOut стрим user даст null, слушатель выше обновит user и isLoading
  }

  /// Обновление профиля (ник, аватар, описание, тема и т.д.).
  Future<void> updateProfile(AppUser updated) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _service.updateProfile(updated);
      user = updated;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
