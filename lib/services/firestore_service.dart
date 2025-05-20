// lib/services/firestore_service.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matrix_task.dart';

/// Сервис для работы с задачами и пользовательскими данными в Firestore.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> fetchLevelsCount(String category) async {
    final doc = await _db.collection('levels').doc(category).get();
    if (!doc.exists) return 0;
    final data = doc.data();
    return (data != null && data['levelsCount'] is int) ? data['levelsCount'] as int : 0;
  }

  Future<List<MatrixTask>> fetchAllTasks({required String category, required int level}) async {
    final snap = await _db
        .collection('levels')
        .doc(category)
        .collection('level\$level')
        .get();
    return snap.docs.map((d) => MatrixTask.fromJson(d.id, d.data())).toList();
  }

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

  Future<List<MatrixTask>> fetchRandomTasks({
    required String category,
    required int level,
    int count = 3,
  }) async {
    final all = await fetchAllTasks(category: category, level: level);
    return pickRandomTasks(all, count);
  }

  Future<void> updateUserScore({required String uid, required int delta}) {
    return _db.collection('users').doc(uid).update({'score': FieldValue.increment(delta)});
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUserDoc(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}