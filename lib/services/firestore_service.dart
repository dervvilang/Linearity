// lib/services/firestore_service.dart

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linearity/models/user.dart';
import '../models/matrix_task.dart';

/// Сервис для работы с задачами и пользовательскими данными в Firestore.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Получает количество уровней для заданной категории задач.
  Future<int> fetchLevelsCount(String category) async {
    final doc = await _db.collection('levels').doc(category).get();
    if (!doc.exists) return 0;
    final data = doc.data();
    return (data != null && data['levelsCount'] is int)
        ? data['levelsCount'] as int
        : 0;
  }

  /// Получает текст подсказки для заданной категории задач.
  Future<String> fetchHint(String category) async {
    final doc = await _db.collection('levels').doc(category).get();
    if (!doc.exists) return 'Подсказка не найдена.';
    final data = doc.data();
    return (data != null && data['hint'] is String)
        ? data['hint'] as String
        : 'Подсказка не найдена.';
  }

  /// Загружает все задачи для [category] и [level].
  Future<List<MatrixTask>> fetchAllTasks({
    required String category,
    required int level,
  }) async {
    final path = 'levels/$category/level$level';
    print('Загружаю задачи из $path');

    final snap = await _db
        .collection('levels')
        .doc(category)
        .collection('level$level')
        .get();

    return snap.docs.map((d) => MatrixTask.fromJson(d.id, d.data())).toList();
  }

  /// Выбирает случайные [count] задач из переданного списка.
  List<MatrixTask> pickRandomTasks(List<MatrixTask> allTasks, int count) {
    if (allTasks.length <= count) return List.from(allTasks);
    final rand = Random();
    final picked = <MatrixTask>[];
    final used = <int>{};
    while (picked.length < count) {
      final idx = rand.nextInt(allTasks.length);
      if (used.add(idx)) picked.add(allTasks[idx]);
    }
    return picked;
  }

  /// Загружает [count] случайных задач для [category]/[level].
  Future<List<MatrixTask>> fetchRandomTasks({
    required String category,
    required int level,
    int count = 1,
  }) async {
    final all = await fetchAllTasks(category: category, level: level);
    return pickRandomTasks(all, count);
  }

  /* ───────────── очки + ранги ───────────── */

  /// Увеличивает счёт пользователя на [delta] и пересчитывает ранги.
  Future<void> updateUserScore({
    required String uid,
    required int delta,
  }) async {
    // Шаг 1: увеличить счёт
    await _db.collection('users').doc(uid).update({
      'score': FieldValue.increment(delta),
    });

    // Шаг 2: пересчитать ранги для всех пользователей
    await _recalculateRanks();
  }

  /// Пересчитывает ранги всех пользователей и записывает их в поле `rank`.
  Future<void> _recalculateRanks() async {
    final snap =
        await _db.collection('users').orderBy('score', descending: true).get();

    final batch = _db.batch();
    for (var i = 0; i < snap.docs.length; i++) {
      final doc = snap.docs[i];
      batch.update(doc.reference, {'rank': i + 1});
    }
    await batch.commit();
  }

  /// Читает пользователей с уже сохранёнными полями `rank` (Top-100 по умолчанию).
  Future<List<AppUser>> fetchUsers({int limit = 100}) async {
    final snap = await _db
        .collection('users')
        .orderBy('score', descending: true)
        .limit(limit)
        .get();

    return snap.docs
        .map((d) => AppUser.fromMap({...d.data(), 'id': d.id}))
        .toList();
  }

  /* ───────────── профиль ───────────── */

  /// Обновляет профиль пользователя [uid] данными из [data].
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<AppUser?> getUserById(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return AppUser.fromJson(snap.data()!..['id'] = uid);
  }

  /// Удаляет документ пользователя [uid].
  Future<void> deleteUserDoc(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}
