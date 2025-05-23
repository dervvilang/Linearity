// lib/widgets/category_card.dart

import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

/// Карточка категории заданий
class CategoryCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    return Card(
      /// Фон карточки
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        /// Обработка касания
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(16),
          child: Column(
            /// Содержимое по верхнему краю
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,  
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: additionalColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: additionalColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
