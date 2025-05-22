// lib/view_models/notification_vm.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linearity/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  static const _key = 'reminders_enabled';

  final NotificationService _svc;
  final SharedPreferences _prefs;

  /// Конструктор ViewModel для уведомлений
  NotificationViewModel(this._svc, this._prefs);

  /// Проверяет, включены ли напоминания
  bool get isEnabled => _prefs.getBool(_key) ?? false;

  /// Включает или выключает напоминания
  Future<void> toggle(bool enable) async {
    await _prefs.setBool(_key, enable);
    if (enable) {
      await _svc.scheduleHourly();  
    } else {
      await _svc.cancelAll();
    }
    notifyListeners();
  }
}
