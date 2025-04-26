import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/models/task_type.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/task_view.dart';
import 'package:linearity/widgets/level_card.dart';

class LevelsListView extends StatelessWidget {
  final TaskType taskType;

  const LevelsListView({super.key, required this.taskType});

  // Возвращает заголовок экрана в зависимости от типа задачи.
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

    // Например, 10 уровней (в будущем можно увеличить).
    const int totalLevels = 10;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Кастомный AppBar.
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Кнопка "назад".
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
            // Список уровней.
            Expanded(
              child: ListView.builder(
                itemCount: totalLevels,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final fraction = totalLevels > 1 ? index / (totalLevels - 1) : 0.0;
                  final levelColor = Color.lerp(
                      additionalColors.firstLevel,
                      additionalColors.secondLevel,
                      fraction)!;

                  return LevelCard(
                    levelNumber: levelNumber,
                    backgroundColor: levelColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskView(
                            taskType: taskType,
                            isDarkTheme: theme.brightness == Brightness.dark,
                            onThemeChanged: (isDark) {
                              // Handle theme change logic here
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
