// lib/view_models/task_vm.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/matrix_task.dart';

/// ViewModel для экрана выполнения заданий
class TaskViewModel extends ChangeNotifier {
  final FirestoreService _fs;

  List<MatrixTask> tasks = [];
  int currentIndex = 0;
  bool isLoading = false;
  bool hasError = false;

  TaskViewModel(this._fs);

  Future<void> loadTasks({
    required String category,
    required int level,
    int count = 3,
  }) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      tasks = await _fs.fetchRandomTasks(
        category: category,
        level: level,
        count: count,
      );
      print('✅ loaded ${tasks.length} tasks');
      currentIndex = 0;
    } catch (e, st) {
      hasError = true;
      print('❌ Error in loadTasks: $e\n$st');
    }

    isLoading = false;
    notifyListeners();
  }

  bool submitAnswer(List<List<num>> userAnswer, String uid) {
    if (currentIndex >= tasks.length || tasks.isEmpty)
      return false; // Добавить проверку на пустоту
    final correct = tasks[currentIndex].answer;
    final ok = listEquals(userAnswer, correct);

    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Обновлять после кадра
        _fs.updateUserScore(uid: uid, delta: 10);
        currentIndex++;
        notifyListeners();
      });
    }
    return ok;
  }

  bool get isComplete => currentIndex >= tasks.length;
  MatrixTask? get currentTask =>
      currentIndex < tasks.length ? tasks[currentIndex] : null;
}
