import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/models/task_type.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/widgets/matrix_display.dart';
import 'package:linearity/widgets/matrix_input.dart';
import 'package:linearity/widgets/task_action_button.dart';

class TaskView extends StatelessWidget {
  final TaskType taskType;
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const TaskView({
    super.key,
    required this.taskType,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  String _getTitle(AppLocalizations loc) {
    switch (taskType) {
      case TaskType.simple:
        return loc.inverseMatrixTask;
      case TaskType.medium:
        return loc.addMatrixTask;
      case TaskType.hard:
        return loc.detMatrixTask;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar.
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      shape: const CircleBorder(),
                      color: additionalColors.greetingText,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'lib/assets/icons/arrow_left.svg',
                          width: 26,
                          height: 26,
                          color: additionalColors.text,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _getTitle(loc),
                        style: theme.textTheme.headlineMedium,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Основной контент задания.
              Column(
                children: [
                  Text(
                    'Задание: ${_getTitle(loc)}',
                    style: theme.textTheme.bodyLarge,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InteractiveViewer(
                      constrained: false,
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 0.5,
                      maxScale: 3.0,
                      boundaryMargin: const EdgeInsets.all(100),
                      child: UnconstrainedBox(
                        child: Row(
                          children: [
                            MatrixDisplay(
                              matrix: [
                                [11, 22, 33, 44],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                              ],
                            ),
                            const SizedBox(width: 5),
                            MatrixDisplay(
                              matrix: [
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                                [1, 2, 3, 4],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
              // Виджет для ввода матрицы.
              MatrixInput(
                rows: 4,
                columns: 4,
                cellSize: 30.0,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 14),
                  Expanded(
                    child: TaskActionButton(
                      initialIcon: SvgPicture.asset(
                        'lib/assets/icons/hint.svg',
                        width: 26,
                        height: 26,
                        color: additionalColors.hint,
                      ),
                      initialTitle: loc.hintButton,
                      confirmedIcon: SvgPicture.asset(
                        'lib/assets/icons/hint.svg',
                        width: 26,
                        height: 26,
                        color: additionalColors.hint,
                      ),
                      confirmedTitle: loc.hintButton,
                      textColor: additionalColors.hint,
                      onTap: () {
                        // Логика для кнопки "Подсказка"
                        print("Подсказка нажата");
                      },
                      toggleOnTap: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TaskActionButton(
                      initialIcon: SvgPicture.asset(
                        'lib/assets/icons/tick-circle.svg',
                        width: 26,
                        height: 26,
                        color: additionalColors.successGreen,
                      ),
                      initialTitle: loc.checkButton,
                      confirmedIcon: SvgPicture.asset(
                        'lib/assets/icons/arrow_right_simple.svg',
                        width: 26,
                        height: 26,
                        color: additionalColors.successGreen,
                      ),
                      confirmedTitle: loc.continueBtn,
                      textColor: additionalColors.successGreen,
                      onTap: () {
                        // Отложим выполнение перехода до завершения текущего кадра,
                        // и закроем все маршруты до первого (главного экрана),
                        // чтобы использовать актуальное глобальное состояние.
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        });
                      },
                      toggleOnTap: true,
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
