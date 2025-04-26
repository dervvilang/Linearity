import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';

class TaskActionButton extends StatefulWidget {
  final Widget initialIcon;
  final String initialTitle;
  final Widget confirmedIcon;
  final String confirmedTitle;
  final VoidCallback onTap;
  final Color textColor;
  final bool toggleOnTap; // true – кнопка переключается при нажатии

  const TaskActionButton({
    super.key,
    required this.initialIcon,
    required this.initialTitle,
    required this.confirmedIcon,
    required this.confirmedTitle,
    required this.onTap,
    required this.textColor,
    required this.toggleOnTap,
  });

  @override
  State<TaskActionButton> createState() => _TaskActionButtonState();
}

class _TaskActionButtonState extends State<TaskActionButton> {
  bool toggled = false;
  bool _isNavigating = false; // Флаг предотвращающий повторный вызов навигации

  void _handleTap() {
    if (widget.toggleOnTap) {
      if (!toggled) {
        // Первое нажатие – просто переключаем вид (текст и иконку)
        setState(() {
          toggled = true;
        });
      } else {
        // Повторное нажатие – если переход ещё не начался, вызываем callback навигации
        if (!_isNavigating) {
          _isNavigating = true;
          widget.onTap();
        }
      }
    } else {
      if (!_isNavigating) {
        _isNavigating = true;
        widget.onTap();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;
    return Card(
      color: additionalColors.firstLevel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              toggled ? widget.confirmedIcon : widget.initialIcon,
              const SizedBox(width: 8),
              Text(
                toggled ? widget.confirmedTitle : widget.initialTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
