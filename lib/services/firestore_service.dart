import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matrix_task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Возвращает количество уровней в категории (поле 'levelsCount' в документе).
  Future<int> fetchLevelsCount(String category) async {
    final doc = await _db.collection('levels').doc(category).get();
    if (!doc.exists) return 0;
    final data = doc.data();
    return (data != null && data['levelsCount'] is int)
        ? data['levelsCount'] as int
        : 0;
  }

  /// Загружает все задачи заданного уровня из коллекции Firestore.
  Future<List<MatrixTask>> fetchAllTasks({
    required String category,
    required int level,
  }) async {
    final snap = await _db
        .collection('levels')
        .doc(category)
        .collection('level$level')
        .get();
    return snap.docs
        .map((d) => MatrixTask.fromJson(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  /// Выбирает [count] случайных и неповторяющихся задач из списка [allTasks].
  List<MatrixTask> pickRandomTasks(List<MatrixTask> allTasks, int count) {
    if (allTasks.length <= count) return List.from(allTasks);
    final rand = Random();
    final picked = <MatrixTask>[];
    final usedIndices = <int>{};
    while (picked.length < count) {
      final idx = rand.nextInt(allTasks.length);
      if (usedIndices.add(idx)) {
        picked.add(allTasks[idx]);
      }
    }
    return picked;
  }

  /// Получает [count] случайных задач для указанной категории и уровня.
  Future<List<MatrixTask>> fetchRandomTasks({
    required String category,
    required int level,
    int count = 3,
  }) async {
    final all = await fetchAllTasks(category: category, level: level);
    return pickRandomTasks(all, count);
  }

  /// Увеличивает (или уменьшает) очки пользователя на [delta].
  Future<void> updateUserScore({
    required String uid,
    required int delta,
  }) {
    return _db
        .collection('users')
        .doc(uid)
        .update({'score': FieldValue.increment(delta)});
  }
}
