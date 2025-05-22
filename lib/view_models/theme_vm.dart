// lib/view_models/theme_vm.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер темы приложения
class ThemeViewModel extends ChangeNotifier {
  static const _key = 'isDarkTheme';

  /// Текущее состояние темы
  bool _isDark = false;
  bool get isDark => _isDark;

  /// Конструктор загружает тему из хранилища
  ThemeViewModel() {
    _loadFromPrefs();
  }

  /// Загружает значение темы из SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  /// Меняет тему и сохраняет выбор в SharedPreferences
  Future<void> toggleTheme(bool isDark) async {
    _isDark = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
