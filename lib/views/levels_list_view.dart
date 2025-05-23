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

class LevelsListView extends StatefulWidget {
  final TaskType taskType;

  const LevelsListView({super.key, required this.taskType});

  @override
  _LevelsListViewState createState() => _LevelsListViewState();
}

class _LevelsListViewState extends State<LevelsListView> {
  late final Future<int> _levelsCountFuture;

  @override
  void initState() {
    super.initState();
    /// Кэширует Future с количеством уровней
    _levelsCountFuture = context
        .read<FirestoreService>()
        .fetchLevelsCount(widget.taskType.firestoreCategory);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    return FutureBuilder<int>(
      future: _levelsCountFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          /// Показывает индикатор загрузки
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          /// Показывает сообщение об ошибке
          return Scaffold(
            body: Center(child: Text('${loc.loadError} ${snapshot.error}')),
          );
        }
        final levelsCount = snapshot.data ?? 0;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                /// AppBar с кнопкой назад и заголовком
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
                            'lib/assets/icons/arrow_left.svg',
                            width: 26,
                            height: 26,
                            colorFilter: ColorFilter.mode(
                              colors.text,
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

                /// Список карточек уровней
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
                                taskType: widget.taskType,
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

  /// Возвращает заголовок экрана в зависимости от типа задачи
  String _getTitle(AppLocalizations loc) {
    switch (widget.taskType) {
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

extension on TaskType {
  /// Категория в Firestore для данного типа задачи
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
