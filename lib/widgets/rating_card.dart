// lib/widgets/rating_card.dart

import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

/// Горизонтальная карточка рейтинга или очков
class RatingCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RatingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    /// Фон карточки берётся из AdditionalColors
    return Card(
      color: additionalColors.ratingCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        /// Обрабатывает нажатие
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Column(
                children: [
                  /// Заголовок (например, ранг или сумма очков)
                  Text(title, style: theme.textTheme.titleMedium),
                  /// Подзаголовок (описание метрики)
                  Text(subtitle, style: theme.textTheme.titleSmall),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
