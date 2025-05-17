// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linearity/models/user.dart';

/// Сервис для регистрации, входа, выхода и получения текущего пользователя.
class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Поток, выдающий AppUser? при изменении состояния аутентификации.
  /// Если пользователь вышел — возвращает null.
  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(doc.data()!);
    });
  }

  /// Текущий Firebase-пользователь (ниже по необходимости можно доставать .uid)
  fb_auth.User? get currentFirebaseUser => _auth.currentUser;

  /// Регистрирует нового пользователя через email+password,
  /// создаёт документ в Firestore и возвращает модель [AppUser].
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    // создаём в FirebaseAuth
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    // создаём модель с дефолтными значениями
    final user = AppUser(
      id: uid,
      email: email,
      username: username,
      // по умолчанию — локальный SVG из assets
      avatarUrl:
          'file:///Q:/flutter-apps/linearity/lib/assets/icons/avatar_2.svg',
      description: '',
      score: 0,
      rank: 0,
      userTheme: 'light',
    );

    // сохраняем в Firestore
    await _firestore.collection('users').doc(uid).set(user.toMap());

    return user;
  }

  /// Логин по email+password. Возвращает [AppUser], считанный из Firestore.
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
      throw Exception('Профиль пользователя не найден в базе.');
    }
    return AppUser.fromMap(doc.data()!);
  }

  /// Выход из аккаунта
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Обновляет запись пользователя в Firestore по полям модели [AppUser].
  Future<void> updateProfile(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }
}
