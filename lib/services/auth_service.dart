// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linearity/models/user.dart';

/// Сервис для регистрации, входа, выхода и получения текущего пользователя  
class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Поток AppUser? который слушает изменения статуса авторизации и профиль в Firestore  
  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncExpand((fbUser) {
      if (fbUser == null) {
        // при логауте возвращаем null  
        return Stream.value(null);
      }
      // слушаем документ пользователя в Firestore  
      return _firestore
          .collection('users')
          .doc(fbUser.uid)
          .snapshots()
          .handleError((_) {}) 
          .map((snap) =>
              snap.exists ? AppUser.fromMap({...snap.data()!, 'id': snap.id}) : null);
    });
  }

  /// Регистрация нового пользователя и создание его профиля в Firestore  
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    final newUser = AppUser(
      id: uid,
      email: email,
      username: username,
      avatarAsset: 'lib/assets/icons/avatar_2.svg',
      description: '',
      score: 0,
      rank: 0,
    );

    await _firestore.collection('users').doc(uid).set(newUser.toMap());
    return newUser;
  }

  /// Вход в существующий аккаунт  
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Профиль пользователя не найден');
    }
    return AppUser.fromMap({...doc.data()!, 'id': doc.id});
  }

  /// Выход из аккаунта  
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Обновление полей профиля (username, avatarAsset, description)  
  Future<void> updateProfileFields({
    required String uid,
    String? username,
    String? avatarAsset,
    String? description,
  }) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (avatarAsset != null) data['avatarAsset'] = avatarAsset;
    if (description != null) data['description'] = description;
    if (data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(data);
    }
  }

  /// Обновление email пользователя с повторной аутентификацией  
  Future<void> updateEmail(String newEmail, String currentPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
      code: 'no-user', message: 'User not signed in.');
    }

    final cred = fb_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updateEmail(newEmail);
    await user.sendEmailVerification();
    // синхронизируем email в Firestore  
    await _firestore.collection('users').doc(user.uid).update({
      'email': newEmail,
    });
  }

  /// Обновление пароля пользователя с повторной аутентификацией  
  Future<void> updatePassword(String newPassword, String currentPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
      code: 'no-user', message: 'User not signed in.');
    }

    final cred = fb_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  /// Удаление аккаунта из Firebase Auth  
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
      code: 'no-user', message: 'User not signed in.');
    }

    await user.delete();
  }
}
