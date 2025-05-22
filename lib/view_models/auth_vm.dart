// lib/view_models/auth_vm.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:linearity/models/user.dart';
import 'package:linearity/services/auth_service.dart';

/// ViewModel для авторизации и текущего пользователя
class AuthViewModel extends ChangeNotifier {
  /// Сервис авторизации
  final AuthService _service;
  /// Текущий пользователь
  AppUser? user;
  /// Флаг загрузки
  bool isLoading = true;
  /// Текст ошибки
  String? error;

  late final StreamSubscription<AppUser?> _userSub;

  /// Подписывается на поток пользователя
  AuthViewModel({AuthService? service}) : _service = service ?? AuthService() {
    _userSub = _service.user.listen(
      (appUser) {
        user = appUser;
        isLoading = false;
        notifyListeners();
      },
      onError: (_) {
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

  /// Преобразует код ошибки Firebase в сообщение
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Неверный формат e-mail';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Такой e-mail уже зарегистрирован';
      case 'weak-password':
        return 'Пароль слишком короткий';
      case 'invalid-credential':
        return 'Неверный пароль';
      default:
        return 'Ошибка: $code';
    }
  }

  /// Сбрасывает текст ошибки
  void clearError() {
    error = null;
    notifyListeners();
  }

  /// Регистрирует нового пользователя
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
    } on fb_auth.FirebaseAuthException catch (e) {
      error = _mapFirebaseError(e.code);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Входит в существующий аккаунт
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
    } on fb_auth.FirebaseAuthException catch (e) {
      error = _mapFirebaseError(e.code);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Выходит из аккаунта
  Future<void> logout() async {
    await _service.signOut();
  }

  /// Обновляет поля профиля
  Future<void> updateProfile({
    String? username,
    String? avatarAsset,
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
        avatarAsset: avatarAsset,
        description: description,
      );

      user = user!.copyWith(
        username: username,
        avatarAsset: avatarAsset,
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
