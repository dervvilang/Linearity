// lib/view_models/theme_vm.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер, который хранит и переключает тему приложения локально
/// (в SharedPreferences), без участия Firestore.
class ThemeViewModel extends ChangeNotifier {
  static const _key = 'isDarkTheme';
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeViewModel() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  /// Меняет тему и сохраняет выбор
  Future<void> toggleTheme(bool isDark) async {
    _isDark = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
