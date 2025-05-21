/// -----------------------------------------------------------------------------
/// lib/view_models/public_profile_vm.dart
/// -----------------------------------------------------------------------------
/// ViewModel для публичного профиля любого пользователя.
/// Используется в сочетании с FirestoreService.getUserById(uid).
/// При загрузке запрашивает данные пользователя по uid, хранит состояние
/// загрузки и возможной ошибки.
/// -----------------------------------------------------------------------------

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/user.dart';

/// ViewModel публичного профиля пользователя.
///
/// Получает uid пользователя, загружает его данные и
/// предоставляет поля для UI: [user], [isLoading], [hasError].
class PublicProfileViewModel extends ChangeNotifier {
  /// Конструктор ViewModel.
  ///
  /// [firestoreService] — сервис для работы с Firestore,
  /// [uid] — идентификатор пользователя.
  PublicProfileViewModel({
    required FirestoreService firestoreService,
    required this.uid,
  }) : _fs = firestoreService;

  final FirestoreService _fs;
  final String           uid;

  AppUser? _user;
  /// Данные пользователя. Будут доступны после успешной загрузки.
  AppUser? get user => _user;

  bool _isLoading = true;
  /// Флаг, указывающий, что идёт загрузка.
  bool get isLoading => _isLoading;

  bool _hasError = false;
  /// Флаг, указывающий, что при загрузке произошла ошибка
  /// (например, пользователь не найден или сбой сети).
  bool get hasError => _hasError;

  /// Загружает данные пользователя из Firestore.
  /// Устанавливает [_isLoading] = true перед запросом,
  /// затем обновляет [_user] или [_hasError], и в любом случае
  /// в конце делает [_isLoading] = false и уведомляет слушателей.
  Future<void> load() async {
    // Начинаем загрузку
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final fetched = await _fs.getUserById(uid);
      if (fetched == null) {
        // Пользователь не найден
        _hasError = true;
      } else {
        // Успешно получили данные
        _user = fetched;
      }
    } catch (e) {
      // При возникновении исключений отмечаем ошибку
      _hasError = true;
    } finally {
      // Завершаем загрузку и уведомляем UI о новом состоянии
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Позволяет повторно выполнить загрузку (например, по нажатию кнопки "повторить").
  Future<void> retry() async => await load();
}
