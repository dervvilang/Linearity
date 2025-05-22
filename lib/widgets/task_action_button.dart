// lib/widgets/task_action_button.dart

import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

/// Кнопка действия в задаче (проверка, подсказка, продолжение)
class TaskActionButton extends StatelessWidget {
  /// Иконка кнопки
  final Widget icon;
  /// Текст кнопки
  final String title;
  /// Обработка нажатия
  final VoidCallback onTap;
  /// Цвет текста
  final Color textColor;

  const TaskActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    return Card(
      /// Фон кнопки
      color: additionalColors.firstLevel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        /// Обрабатывает тап
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            /// Располагает иконку и текст по центру
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
