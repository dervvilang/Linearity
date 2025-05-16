// lib/view_models/task_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/matrix_task.dart';

/// ViewModel для экрана выполнения заданий:
/// - загружает 3 случайные задачи из Firestore,
/// - хранит состояние (загрузка/ошибка/текущий номер),
/// - проверяет ответы и обновляет очки пользователя.
class TaskViewModel extends ChangeNotifier {
  final FirestoreService _fs;

  /// Список загруженных задач
  List<MatrixTask> tasks = [];

  /// Индекс текущей задачи (0..tasks.length-1)
  int currentIndex = 0;

  /// Флаги состояния
  bool isLoading = false;
  bool hasError = false;

  TaskViewModel(this._fs);

  /// Загружает [count] случайных задач для [category]/[level]
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
    } catch (e) {
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Возвращает true, если текущая задача решена верно.
  /// Если да — увеличивает счёт, переходит к следующей задаче и нотифай.
  bool submitAnswer(List<List<num>> userAnswer, String uid) {
    if (currentIndex >= tasks.length) return false;

    final correctAnswer = tasks[currentIndex].answer;
    final isCorrect = listEquals(userAnswer, correctAnswer);

    if (isCorrect) {
      // Начисляем пользователю, например, 10 очков
      _fs.updateUserScore(uid: uid, delta: 10);
      currentIndex++;
      notifyListeners();
    }

    return isCorrect;
  }

  /// Готовы ли все задачи?
  bool get isComplete => currentIndex >= tasks.length;

  /// Текущая задача
  MatrixTask? get currentTask =>
      currentIndex < tasks.length ? tasks[currentIndex] : null;
}
