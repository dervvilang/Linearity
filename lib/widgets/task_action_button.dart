import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

class TaskActionButton extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
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
    final theme            = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;
    return Card(
      color: additionalColors.firstLevel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
