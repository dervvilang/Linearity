// lib/view_models/edit_profile_vm.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../view_models/auth_vm.dart';

class EditProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  /// Список доступных SVG-аватарок
  final List<String> availableAvatars = [
    'lib/assets/icons/avatar_1.svg',
    'lib/assets/icons/avatar_2.svg',
    'lib/assets/icons/avatar_3.svg',
    'lib/assets/icons/avatar_4.svg',
    'lib/assets/icons/avatar_5.svg',
    'lib/assets/icons/avatar_6.svg',
    'lib/assets/icons/avatar_7.svg',
    'lib/assets/icons/avatar_8.svg',
    'lib/assets/icons/avatar_9.svg',
  ];

  /// Оригинальные значения для сравнения
  final String _origUsername;
  final String _origEmail;
  final String _origAvatarAsset;

  /// Поля формы
  String username;
  String email;
  String avatarAsset;
  String currentPassword = '';
  String newPassword = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Инициализирует поля из AuthViewModel
  EditProfileViewModel(
    BuildContext context, {
    AuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? AuthService(),
        _firestoreService = firestoreService ?? FirestoreService(),
        _origUsername = context.read<AuthViewModel>().user!.username,
        _origEmail = context.read<AuthViewModel>().user!.email,
        _origAvatarAsset = context.read<AuthViewModel>().user!.avatarAsset,
        username = context.read<AuthViewModel>().user!.username,
        email = context.read<AuthViewModel>().user!.email,
        avatarAsset = context.read<AuthViewModel>().user!.avatarAsset;

  /// Проверяет, есть ли изменения
  bool get hasChanges {
    final avatarChanged = avatarAsset != _origAvatarAsset;
    final usernameChanged = username != _origUsername;
    final emailChanged = email != _origEmail && currentPassword.isNotEmpty;
    final passwordChanged =
        newPassword.isNotEmpty && currentPassword.isNotEmpty;
    return avatarChanged || usernameChanged || emailChanged || passwordChanged;
  }

  /// Устанавливает новый аватар
  void setAvatarAsset(String asset) {
    avatarAsset = asset;
    notifyListeners();
  }

  /// Устанавливает новое имя пользователя
  void setUsername(String v) {
    username = v.trim();
    notifyListeners();
  }

  /// Устанавливает новый email
  void setEmail(String v) {
    email = v.trim();
    notifyListeners();
  }

  /// Устанавливает текущий пароль
  void setCurrentPassword(String v) {
    currentPassword = v;
    notifyListeners();
  }

  /// Устанавливает новый пароль
  void setNewPassword(String v) {
    newPassword = v;
    notifyListeners();
  }

  /// Сохраняет изменения профиля
  Future<void> saveChanges() async {
    _setLoading(true);
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;

      if (avatarAsset != _origAvatarAsset) {
        /// Обновляет avatarAsset
        await _authService.updateProfileFields(
          uid: uid,
          avatarAsset: avatarAsset,
        );
      }

      if (email != _origEmail) {
        /// Обновляет email с повторной аутентификацией
        await _authService.updateEmail(email, currentPassword);
      }

      if (newPassword.isNotEmpty) {
        /// Обновляет пароль с повторной аутентификацией
        await _authService.updatePassword(newPassword, currentPassword);
      }

      if (username != _origUsername) {
        /// Обновляет username
        await _authService.updateProfileFields(
          uid: uid,
          username: username,
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Удаляет аккаунт и документ пользователя
  Future<void> deleteAccount() async {
    _setLoading(true);
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;
      await _firestoreService.deleteUserDoc(uid);
      await _authService.deleteAccount();
    } finally {
      _setLoading(false);
    }
  }

  /// Устанавливает флаг загрузки
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
