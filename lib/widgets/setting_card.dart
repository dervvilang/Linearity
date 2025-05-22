// lib/widgets/setting_card.dart

import 'package:flutter/material.dart';

/// Карточка настройки с заголовком и иконкой или переключателем
class SettingCard extends StatelessWidget {
  /// Иконка справа (если нет trailing)
  final Widget? icon;
  /// Текст заголовка настройки
  final String title;
  /// Действие при тапе
  final VoidCallback onTap;
  /// Цвет текста (по умолчанию Theme)
  final Color? textColor;
  /// Цвет фона карточки
  final Color backColor;
  /// Виджет справа (например, Switch)
  final Widget? trailing;

  const SettingCard({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    required this.backColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      /// Фон карточки
      color: backColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        /// Обработка нажатия
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            /// Выравнивание текста и иконки по краям
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Заголовок настройки
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
              ),
              /// Справа либо виджет trailing, либо icon
              if (trailing != null)
                trailing!
              else if (icon != null)
                icon!,
            ],
          ),
        ),
      ),
    );
  }
}
