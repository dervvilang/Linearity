import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'package:provider/provider.dart';
import 'auth_vm.dart';

class EditProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final ImagePicker _picker = ImagePicker();

  // Исходные данные
  final String _origUsername;
  final String _origEmail;
  final String? _origAvatarUrl;

  // Поля формы
  String username;
  String email;
  String currentPassword = '';
  String newPassword = '';
  File? avatarFile;
  String? avatarUrl;

  bool _isLoading = false;

  EditProfileViewModel(BuildContext context,
      {AuthService? authService,
      FirestoreService? firestoreService,
      StorageService? storageService})
      : _authService = authService ?? AuthService(),
        _firestoreService = firestoreService ?? FirestoreService(),
        _storageService = storageService ?? StorageService(),
        _origUsername = context.read<AuthViewModel>().user!.username,
        _origEmail = context.read<AuthViewModel>().user!.email,
        _origAvatarUrl = context.read<AuthViewModel>().user!.avatarUrl,
        username = context.read<AuthViewModel>().user!.username,
        email = context.read<AuthViewModel>().user!.email,
        avatarUrl = context.read<AuthViewModel>().user!.avatarUrl;

  bool get isLoading => _isLoading;

  bool get hasChanges {
    return username != _origUsername ||
        email != _origEmail ||
        newPassword.isNotEmpty ||
        avatarFile != null;
  }

  // Сеттеры
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

  Future<void> pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      avatarFile = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> saveChanges() async {
    _setLoading(true);
    final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;

    // Аватар
    if (avatarFile != null) {
      final url = await _storageService.uploadAvatar(avatarFile!, uid);
      await _authService.updateProfileFields(uid: uid, avatarUrl: url);
    }
    // Email
    if (email != _origEmail) {
      await _authService.updateEmail(email, currentPassword);
    }
    // Пароль
    if (newPassword.isNotEmpty) {
      await _authService.updatePassword(newPassword, currentPassword);
    }
    // Никнейм
    if (username != _origUsername) {
      await _authService.updateProfileFields(uid: uid, username: username);
    }

    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;

    await _firestoreService.deleteUserDoc(uid);
    await _storageService.deleteAvatar(uid);
    await _authService.deleteAccount();

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
