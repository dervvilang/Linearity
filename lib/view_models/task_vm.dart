// lib/view_models/task_vm.dart

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/matrix_task.dart';

/// ViewModel для экрана выполнения заданий
class TaskViewModel extends ChangeNotifier {
  final FirestoreService _fs;

  List<MatrixTask> tasks = [];
  int currentIndex = 0;
  bool isLoading = false;
  bool hasError = false;
  List<List<bool>> cellCorrectness = [];
  bool answeredCorrectly = false;

  String? hintText;
  bool isHintLoading = false;

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
      currentIndex = 0;
      answeredCorrectly = false;
      cellCorrectness = [];
    } catch (e, st) {
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Проверка ответа и обновление баллов
  Future<void> submitAnswer(List<List<num>> userAnswer, String uid) async {
    cellCorrectness = List.generate(
      tasks[currentIndex].answer.length,
      (i) => List.generate(
        tasks[currentIndex].answer[i].length,
        (j) => userAnswer[i][j] == tasks[currentIndex].answer[i][j],
      ),
    );
    answeredCorrectly = cellCorrectness.every((row) => row.every((v) => v));

    if (answeredCorrectly) {
      await _fs.updateUserScore(uid: uid, delta: 3);
    }
    notifyListeners();
  }

  /// Загрузка текста подсказки для текущей категории
  Future<void> loadHint(String category) async {
    isHintLoading = true;
    notifyListeners();

    hintText = await _fs.fetchHint(category);

    isHintLoading = false;
    notifyListeners();
  }

  MatrixTask? get currentTask =>
      (currentIndex < tasks.length) ? tasks[currentIndex] : null;

  bool get isComplete => answeredCorrectly;
}
