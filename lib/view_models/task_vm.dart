// lib/view_models/task_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/matrix_task.dart';

/// ViewModel для экрана выполнения заданий
class TaskViewModel extends ChangeNotifier {
  final FirestoreService _fs;

  /// Список текущих задач
  List<MatrixTask> tasks = [];
  /// Индекс текущей задачи
  int currentIndex = 0;
  /// Флаг загрузки задач
  bool isLoading = false;
  /// Флаг ошибки при загрузке
  bool hasError = false;
  /// Матрица правильности введённых ответов
  List<List<bool>> cellCorrectness = [];
  /// Флаг, что ответ верный
  bool answeredCorrectly = false;

  /// Текст подсказки
  String? hintText;
  /// Флаг загрузки подсказки
  bool isHintLoading = false;

  /// Конструктор с FirestoreService
  TaskViewModel(this._fs);

  /// Загружает случайные задачи
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
    } catch (e) {
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Проверяет ответ пользователя и обновляет очки
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

  /// Загружает подсказку для категории
  Future<void> loadHint(String category) async {
    isHintLoading = true;
    notifyListeners();

    hintText = await _fs.fetchHint(category);

    isHintLoading = false;
    notifyListeners();
  }

  /// Текущая задача или null
  MatrixTask? get currentTask =>
      (currentIndex < tasks.length) ? tasks[currentIndex] : null;

  /// true, если задача решена
  bool get isComplete => answeredCorrectly;
}
