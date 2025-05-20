// lib/view_models/notification_vm.dart
//
// ViewModel хранит флаг в SharedPreferences и
// запускает / останавливает напоминания через NotificationService.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linearity/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  static const _key = 'reminders_enabled';

  final NotificationService _svc;
  final SharedPreferences _prefs;

  NotificationViewModel(this._svc, this._prefs);

  bool get isEnabled => _prefs.getBool(_key) ?? false;

  Future<void> toggle(bool enable) async {
    await _prefs.setBool(_key, enable);

    if (enable) {
      await _svc.scheduleHourly();   // ← включаем ежечасовые
      // await _svc.scheduleTestMinute(); // ← вариант для отладки
    } else {
      await _svc.cancelAll();
    }

    notifyListeners();
  }
}
