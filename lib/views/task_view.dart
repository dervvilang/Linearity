import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:linearity/models/task_type.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/task_vm.dart';
import 'package:linearity/widgets/matrix_display.dart';
import 'package:linearity/widgets/matrix_input.dart';
import 'package:linearity/widgets/task_action_button.dart';

class TaskView extends StatefulWidget {
  final TaskType taskType;
  final int level;

  const TaskView({
    Key? key,
    required this.taskType,
    required this.level,
  }) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final TaskViewModel _vm;
  final _matrixKey = GlobalKey<MatrixInputState>();

  @override
  void initState() {
    super.initState();
    _vm = context.read<TaskViewModel>();
    _vm.loadTasks(
      category: widget.taskType.firestoreCategory,
      level: widget.level,
      count: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    final isLoading = context.watch<TaskViewModel>().isLoading;
    final hasError = context.watch<TaskViewModel>().hasError;
    final vm = context.watch<TaskViewModel>();

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasError) {
      return Scaffold(
        body: Center(child: Text('Ошибка загрузки задач')),
      );
    }

    final task = vm.currentTask!;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
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
                          // deprecated color → use colorFilter
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
                        _getTitle(),
                        style: theme.textTheme.headlineMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Заголовок задачи
              Text(
                'Задание: ${_getTitle()}',
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 16),

              // Отображаем матрицы
              InteractiveViewer(
                constrained: false,
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.5,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MatrixDisplay(matrix: task.matrixA),
                    if (task.matrixB != null && task.matrixB!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      MatrixDisplay(matrix: task.matrixB!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ввод ответа
              MatrixInput(
                key: _matrixKey,
                rows: task.answer.length,
                columns: task.answer.first.length,
                cellSize: 40.0,
              ),

              const SizedBox(height: 24),

              // Кнопки
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TaskActionButton(
                        initialIcon: SvgPicture.asset(
                          'assets/icons/hint.svg',
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            colors.hint!,
                            BlendMode.srcIn,
                          ),
                        ),
                        initialTitle: loc.hintButton,
                        confirmedIcon: SvgPicture.asset(
                          'assets/icons/hint.svg',
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            colors.hint!,
                            BlendMode.srcIn,
                          ),
                        ),
                        confirmedTitle: loc.hintButton,
                        textColor: colors.hint!,
                        onTap: () {
                          // TODO: подсказка
                        },
                        toggleOnTap: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TaskActionButton(
                        initialIcon: SvgPicture.asset(
                          'assets/icons/tick-circle.svg',
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            colors.successGreen!,
                            BlendMode.srcIn,
                          ),
                        ),
                        initialTitle: loc.checkButton,
                        confirmedIcon: SvgPicture.asset(
                          'assets/icons/arrow_right_simple.svg',
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            colors.successGreen!,
                            BlendMode.srcIn,
                          ),
                        ),
                        confirmedTitle: vm.isComplete
                            ? 'Готово'
                            : loc.continueBtn,
                        textColor: colors.successGreen!,
                        onTap: () {
                          if (uid == null) return;
                          // читаем ввод
                          final userAns = _matrixKey.currentState!.getMatrix();
                          final ok = _vm.submitAnswer(userAns, uid);
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Неверный ответ')),
                            );
                          } else if (vm.isComplete) {
                            Navigator.popUntil(context, (r) => r.isFirst);
                          }
                        },
                        toggleOnTap: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.taskType) {
      case TaskType.basic:
        return AppLocalizations.of(context)!.addMatrixTask;
      case TaskType.simple:
        return AppLocalizations.of(context)!.multMatrixTask;
      case TaskType.medium:
        return AppLocalizations.of(context)!.detMatrixTask;
      case TaskType.hard:
        return AppLocalizations.of(context)!.inverseMatrixTask;
    }
  }
}

// TaskType → имя коллекции в Firestore
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
