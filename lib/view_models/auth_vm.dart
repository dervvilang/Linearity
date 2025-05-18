import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:linearity/models/user.dart';
import 'package:linearity/services/auth_service.dart';

/// ViewModel для авторизации и работы с текущим пользователем.
class AuthViewModel extends ChangeNotifier {
  final AuthService _service;

  AppUser? user;
  bool isLoading = true;
  String? error;

  late final StreamSubscription<AppUser?> _userSub;

  AuthViewModel({AuthService? service})
      : _service = service ?? AuthService() {
    // Подписываемся на поток, ловим ошибки и отменяем в dispose
    _userSub = _service.user.listen(
      (appUser) {
        user = appUser;
        isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        // Игнорируем ошибки доступа сразу после signOut
        user = null;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
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
    // После signOut поток отдаст null и мы обновим состояние
  }

  /// Обновление полей профиля (username, avatarUrl, description).
  Future<void> updateProfile({
    String? username,
    String? avatarUrl,
    String? description,
  }) async {
    if (user == null) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final uid = user!.id;
      await _service.updateProfileFields(
        uid: uid,
        username: username,
        avatarUrl: avatarUrl,
        description: description,
      );

      // Локально обновляем модель
      user = user!.copyWith(
        username: username,
        avatarUrl: avatarUrl,
        description: description,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
