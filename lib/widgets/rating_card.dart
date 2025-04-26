import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

/// Виджет для горизонтальной карточки рейтинга/баллов.
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
    // Получаем текущую тему приложения.
    final theme = Theme.of(context);
    // Получаем дополнительное расширение для цветов.
    final additionalColors = theme.extension<AdditionalColors>()!;

    return Card(
      color: additionalColors.ratingCard, // Например, добавьте поле ratingCard в AdditionalColors.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
