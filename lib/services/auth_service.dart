import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linearity/models/user.dart';

/// Сервис для регистрации, входа, выхода и получения текущего пользователя.
class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Поток AppUser?, который
  /// 1) слушает authStateChanges() для входа/выхода,
  /// 2) при залогине переключается на snapshots() документа Firestore,
  ///    чтобы при любом изменении профиля отдавать новое значение.
  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncExpand((fbUser) {
      // если вышли — сразу кидаем null и завершаем прослушку документа
      if (fbUser == null) return Stream.value(null);

      // иначе слушаем документ, но игнорируем ошибки доступа после signOut
      return _firestore
          .collection('users')
          .doc(fbUser.uid)
          .snapshots()
          .handleError((_) {
            // поглощаем ошибки (PERMISSION_DENIED и т.п.)
          })
          .map((snap) => snap.exists ? AppUser.fromMap(snap.data()!) : null);
    });
  }

  /// Зарегистрировать нового пользователя и создать профиль в Firestore.
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
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      description: '',
      score: 0,
      rank: 0,
      userTheme: 'light',
    );

    await _firestore.collection('users').doc(uid).set(newUser.toMap());
    return newUser;
  }

  /// Войти в существующий аккаунт.
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
    return AppUser.fromMap(doc.data()!);
  }

  /// Выйти из аккаунта.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Обновить любые поля профиля (username, avatarUrl, description).
  /// Если передано null — поле не меняется.
  Future<void> updateProfileFields({
    required String uid,
    String? username,
    String? avatarUrl,
    String? description,
  }) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    if (description != null) data['description'] = description;
    if (data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(data);
    }
  }
}
