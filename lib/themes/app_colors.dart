import 'package:flutter/material.dart';

/// Хранит базовые цвета приложения для светлой и тёмной тем.
class AppColors {
  // ==== Светлая тема ====
  static const Color scaffoldLight = Colors.white; // Фон приложения
  static const Color textForLight = Colors.black;    // Основной цвет текста

  static const Color primaryBlue = Color(0xFF5DADE2); // Для приветствия, нижней панели и т.д.
  static const Color secondBlue = Color(0xFF85C1E9);  // Для вертикальных карточек (средний цвет)
  static const Color thirdBlue = Color(0xFFAED6F1);   // Для вертикальных карточек (низкий цвет)
  static const Color fourthBlue = Color(0xFFEAF2F8);  // Для нижней навигационной панели

  // Дополнительные акценты в светлой теме
  static const Color primaryGreenLight = Color(0xFF4FD1C5);
  static const Color errorRedLight = Color(0xFFE74C3C);
  static const Color alertRedLight = Color(0xFFFFBABA);
  static const Color goldLight = Color(0xFFE8AA27);

  // Цвета для нижней навигации (светлая)
  static const Color primaryGrey = Color(0xFFF3F3F3);
  static const Color secondGrey = Color.fromARGB(255, 109, 109, 109);

  // ==== Тёмная тема ====
  static const Color scaffoldDark = Color(0xFF12101C);
  static const Color textForDark = Color.fromARGB(255, 232, 232, 250);

  // Для вертикальных карточек и нижней панели в тёмной теме
  static const Color primaryPurple = Color(0xFF2a2343); // Используется как базовый (фон нижней панели)
  static const Color secondPurple = Color(0xFF554785);  // Средний оттенок для вертикальных карточек
  static const Color thirdPurple = Color(0xFF7f6eba);   // Акцентный – для активных элементов (например, нижней панели)
  static const Color fourthPurple = Color(0xFF8c7dc1); // Низкий оттенок для вертикальных карточек

  // Дополнительные акценты в тёмной теме
  static const Color successGreenDark = Color(0xFF43D9A0);
  static const Color errorRedDark = Color.fromARGB(255, 245, 226, 228);
  static const Color alertRedDark = Color(0xFFE15C7A);
  static const Color goldDark = Color(0xFFF7C768);

  static const Color inactiveButtons = Color(0xFF67617C);
}
