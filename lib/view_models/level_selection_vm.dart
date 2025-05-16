import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';

/// ViewModel для экрана выбора уровня.
/// Загружает из Firestore количество уровней для заданной категории.
class LevelSelectionViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  /// Всего уровней в данной категории
  int levelsCount = 0;

  /// Флаг загрузки
  bool isLoading = false;

  /// Флаг ошибки при загрузке
  bool hasError = false;

  LevelSelectionViewModel(this._firestoreService);

  /// Загружает поле `levelsCount` из документа `levels/{category}`
  Future<void> loadLevelsCount(String category) async {
    isLoading = true;
    notifyListeners();

    try {
      levelsCount = await _firestoreService.fetchLevelsCount(category);
      hasError = false;
    } catch (e) {
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }
}
