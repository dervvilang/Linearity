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

  /// Загружает все задачи для [category] и [level].
  Future<List<MatrixTask>> fetchAllTasks({
    required String category,
    required int level,
  }) async {
    // Формируем путь к подколлекции
    final path = 'levels/$category/level$level';
    print('Загружаю задачи из $path');

    final snap = await _db
        .collection('levels')
        .doc(category)
        .collection('level$level')
        .get();

    return snap.docs
        .map((d) => MatrixTask.fromJson(d.id, d.data()))
        .toList();
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

  /// Увеличивает счёт пользователя [uid] на [delta] в Firestore.
  Future<void> updateUserScore({
    required String uid,
    required int delta,
  }) {
    return _db
        .collection('users')
        .doc(uid)
        .update({'score': FieldValue.increment(delta)});
  }

  /// Обновляет профиль пользователя [uid] данными из [data].
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Получить всех пользователей, отсортированных по score (desc).
  Future<List<AppUser>> fetchAllUsersByScore() async {
    final snap = await _db
        .collection('users')
        .orderBy('score', descending: true)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return AppUser(
        id: d.id,
        email: data['email'] as String? ?? '',
        username: data['username'] as String? ?? '',
        avatarAsset: data['avatarAsset'] as String? ?? '',
        description: data['description'] as String? ?? '',
        score: (data['score'] as num?)?.toInt() ?? 0,
        rank: 0,
      );
    }).toList();
  }

  /// Удаляет документ пользователя [uid].
  Future<void> deleteUserDoc(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}
