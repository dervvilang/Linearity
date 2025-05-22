// lib/themes/app_colors.dart

import 'package:flutter/material.dart';

/// Хранит базовые цвета приложения для светлой и тёмной тем.
class AppColors {
  /// ==== Светлая тема ====
  static const Color scaffoldLight = Colors.white;
  static const Color textForLight = Colors.black;

  static const Color primaryBlue = Color(0xFF3297DA);
  static const Color secondBlue = Color(0xFF85C1E9);
  static const Color thirdBlue = Color(0xFFAED6F1);
  static const Color fourthBlue = Color(0xFFEAF2F8);
  static const Color fifthBlue = Color(0xFF5DADE2);

  /// Дополнительные акценты в светлой теме
  static const Color primaryGreenLight = Color(0xFF4FD1C5);
  static const Color errorRedLight = Color(0xFFE74C3C);
  static const Color alertRedLight = Color(0xFFFFBABA);
  static const Color goldLight = Color(0xFFE8AA27);

  /// Цвета для нижней навигации (светлая)
  static const Color primaryGrey = Color(0xFFF3F3F3);
  static const Color secondGrey = Color.fromARGB(255, 109, 109, 109);

  /// ==== Тёмная тема ====
  static const Color scaffoldDark = Color(0xFF12101C);
  static const Color textForDark = Color.fromARGB(255, 232, 232, 250);

  /// Для вертикальных карточек и нижней панели в тёмной теме
  static const Color primaryPurple = Color(0xFF2a2343);
  static const Color secondPurple = Color(0xFF554785); 
  static const Color thirdPurple = Color(0xFF7f6eba);
  static const Color fourthPurple = Color(0xFF8c7dc1);
  static const Color fifthPurple = Color(0xFF403564); 

  /// Дополнительные акценты в тёмной теме
  static const Color successGreenDark = Color(0xFF43D9A0);
  static const Color errorRedDark = Color.fromARGB(255, 245, 226, 228);
  static const Color alertRedDark = Color(0xFFE15C7A);
  static const Color goldDark = Color(0xFFF7C768);

  static const Color inactiveButtons = Color(0xFF67617C);
}
