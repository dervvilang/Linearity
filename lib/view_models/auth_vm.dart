// lib/view_models/auth_vm.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:linearity/models/user.dart';
import 'package:linearity/services/auth_service.dart';

/// ViewModel для авторизации и работы с текущим пользователем.
class AuthViewModel extends ChangeNotifier {
  final AuthService _service;

  AppUser? user;
  bool isLoading = true;
  String? error;

  late final StreamSubscription<AppUser?> _userSub;

  AuthViewModel({AuthService? service}) : _service = service ?? AuthService() {
    // Подписываемся на поток, ловим ошибки и отменяем в dispose
    _userSub = _service.user.listen(
      (appUser) {
        user = appUser;
        isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        // При ошибках (например, после signOut) просто сбрасываем состояние
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

  /// Преобразует код FirebaseAuthException в понятное пользователю сообщение.
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
      case 'invalid-credential': // ← ловим и эту ошибку
        return 'Неверный пароль';
      default:
        return 'Ошибка: $code';
    }
  }

  /// Сбрасывает текущее сообщение об ошибке.
  void clearError() {
    error = null;
    notifyListeners();
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
    } on fb_auth.FirebaseAuthException catch (e) {
      error = _mapFirebaseError(e.code);
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
    } on fb_auth.FirebaseAuthException catch (e) {
      error = _mapFirebaseError(e.code);
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
    // По authStateChanges получим null и обновим состояние
  }

  /// Обновление полей профиля (username, avatarAsset, description).
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

      // Локально обновляем модель
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
