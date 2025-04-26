import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final Widget? icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color backColor;
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
      color: backColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
              ),
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
