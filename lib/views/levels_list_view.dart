// lib/views/levels_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:linearity/models/task_type.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/widgets/level_card.dart';
import 'package:linearity/views/task_view.dart';

class LevelsListView extends StatelessWidget {
  final TaskType taskType;

  const LevelsListView({Key? key, required this.taskType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    // Тут мы сразу запускаем Future для количества уровней
    return FutureBuilder<int>(
      future: context
          .read<FirestoreService>()
          .fetchLevelsCount(taskType.firestoreCategory),
      builder: (context, snapshot) {
        // 1) Пока ждём — индикатор
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 2) Если ошибка — сообщение
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(loc.exitButton)),
          );
        }
        // 3) Успех — получили число уровней
        final levelsCount = snapshot.data ?? 0;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color:
                      theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                  child: Row(
                    children: [
                      Material(
                        shape: const CircleBorder(),
                        color: colors.greetingText,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/arrow_left.svg',
                            width: 26,
                            height: 26,
                            colorFilter: ColorFilter.mode(
                              colors.text!,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _getTitle(loc),
                          style: theme.textTheme.headlineMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Список уровней
                Expanded(
                  child: ListView.builder(
                    itemCount: levelsCount,
                    itemBuilder: (ctx, index) {
                      final levelNum = index + 1;
                      final frac = levelsCount > 1
                          ? index / (levelsCount - 1)
                          : 0.0;
                      final bg = Color.lerp(
                        colors.firstLevel,
                        colors.secondLevel,
                        frac,
                      )!;

                      return LevelCard(
                        levelNumber: levelNum,
                        backgroundColor: bg,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskView(
                                taskType: taskType,
                                level: levelNum,
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
      },
    );
  }

  String _getTitle(AppLocalizations loc) {
    switch (taskType) {
      case TaskType.basic:
        return loc.addMatrixTask;
      case TaskType.simple:
        return loc.multMatrixTask;
      case TaskType.medium:
        return loc.detMatrixTask;
      case TaskType.hard:
        return loc.inverseMatrixTask;
    }
  }
}

// Чтобы не дублировать логику маппинга
extension on TaskType {
  String get firestoreCategory {
    switch (this) {
      case TaskType.medium:
        return 'determinant';
      case TaskType.hard:
        return 'inverse';
      case TaskType.simple:
        return 'multiplication';
      case TaskType.basic:
        return 'addition_subtraction';
    }
  }
}