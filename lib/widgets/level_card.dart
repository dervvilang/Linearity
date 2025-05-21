import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LevelCard extends StatelessWidget {
  final int levelNumber;
  final Color backgroundColor;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.levelNumber,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6), // Внешние отступы для разделения карточек.
          padding: const EdgeInsets.all(
              16), // Внутренние отступы для содержимого карточки.
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14), // Скругление углов.
          ),
          child: Text(
            '${loc.levelsTitle} $levelNumber',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
