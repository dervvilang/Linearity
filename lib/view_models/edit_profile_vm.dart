// lib/view_models/edit_profile_vm.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../services/auth_service.dart';
import '../services/firestore_service.dart';           // если нужен для удаления
import '../view_models/auth_vm.dart';

class EditProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  /// Список всех предустановленных SVG-аватарок
  final List<String> availableAvatars = [
    'lib/assets/icons/avatar_1.svg',
    'lib/assets/icons/avatar_2.svg',
    // при необходимости добавьте ещё
  ];

  // Оригинальные значения для сравнения
  final String _origUsername;
  final String _origEmail;
  final String _origAvatarAsset;

  // Поля, которыми оперируем в форме
  String username;
  String email;
  String avatarAsset;
  String currentPassword = '';
  String newPassword = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Конструктор, подтягивает текущие данные из AuthViewModel
  EditProfileViewModel(BuildContext context, {
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

  /// Есть ли изменения, чтобы активировать кнопку «Сохранить»
  bool get hasChanges {
    final avatarChanged = avatarAsset != _origAvatarAsset;
    final usernameChanged = username != _origUsername;
    final emailChanged = email != _origEmail && currentPassword.isNotEmpty;
    final passwordChanged = newPassword.isNotEmpty && currentPassword.isNotEmpty;
    return avatarChanged || usernameChanged || emailChanged || passwordChanged;
  }

  /// Установить новый аватар
  void setAvatarAsset(String asset) {
    avatarAsset = asset;
    notifyListeners();
  }

  void setUsername(String v) {
    username = v.trim();
    notifyListeners();
  }

  void setEmail(String v) {
    email = v.trim();
    notifyListeners();
  }

  void setCurrentPassword(String v) {
    currentPassword = v;
    notifyListeners();
  }

  void setNewPassword(String v) {
    newPassword = v;
    notifyListeners();
  }

  Future<void> saveChanges() async {
    _setLoading(true);
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;

      // Аватар
      if (avatarAsset != _origAvatarAsset) {
        await _authService.updateProfileFields(
          uid: uid,
          avatarAsset: avatarAsset,
        );
      }

      // Email (с реаутентификацией)
      if (email != _origEmail) {
        await _authService.updateEmail(email, currentPassword);
      }

      // Пароль
      if (newPassword.isNotEmpty) {
        await _authService.updatePassword(newPassword, currentPassword);
      }

      // Никнейм
      if (username != _origUsername) {
        await _authService.updateProfileFields(
          uid: uid,
          username: username,
        );
      }
    } finally {
      _setLoading(false);
    }
  }

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

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
