// lib/views/task_view.dart
//
// Экран выполнения одной из трёх случайно-выбранных задач уровня.
// Кнопка всегда "Проверить" до верного ответа, после — "Продолжить".

import 'package:flutter/material.dart';
import 'package:linearity/models/matrix_task.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:linearity/models/task_type.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/task_vm.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/widgets/matrix_display.dart';
import 'package:linearity/widgets/matrix_input.dart';
import 'package:linearity/widgets/task_action_button.dart';

class TaskView extends StatefulWidget {
  final TaskType taskType;
  final int level;

  const TaskView({
    super.key,
    required this.taskType,
    required this.level,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final TaskViewModel _vm;
  final _matrixKey = GlobalKey<MatrixInputState>();

  bool _answeredCorrectly = false;
  List<List<bool>> _cellCorrectness = [];

  @override
  void initState() {
    super.initState();
    _vm = context.read<TaskViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.loadTasks(
        category: widget.taskType.firestoreCategory,
        level: widget.level,
        count: 1,
      );
    });
  }

  String _getTaskSubtitle(AppLocalizations loc, MatrixTask task) {
    switch (task.type) {
      case OperationType.addition:
        return loc.taskAddition;
      case OperationType.subtraction:
        return loc.taskSubtraction;
      case OperationType.multiplication:
        return loc.taskMultiplication;
      case OperationType.determinant:
        return loc.taskDeterminant;
      case OperationType.inverse:
        return loc.taskInverse;
    }
  }

  /// Проверка ответа
  void _onCheck() {
    FocusScope.of(context).unfocus();

    final task = _vm.currentTask!;
    final user = _matrixKey.currentState!.getMatrix();
    final correct = task.answer;

    _cellCorrectness = List.generate(
      correct.length,
      (i) => List.generate(
        correct[i].length,
        (j) => user[i][j] == correct[i][j],
      ),
    );

    final allOk = _cellCorrectness.every((row) => row.every((v) => v));
    setState(() {
      _answeredCorrectly = allOk;
    });

    if (allOk) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        context.read<FirestoreService>().updateUserScore(uid: uid, delta: 3);
      }
    }
  }

  /// Переход дальше после верного ответа
  void _onContinue() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    final vm = context.watch<TaskViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (vm.hasError) {
      return const Scaffold(body: Center(child: Text('Ошибка загрузки задач')));
    }
    final task = vm.currentTask;
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(_getTitle(context))),
        body: const Center(child: Text('Задачи не найдены')),
      );
    }

    // Кнопка подсказки
    final hintButton = TaskActionButton(
      icon: SvgPicture.asset(
        'lib/assets/icons/hint.svg',
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(colors.hint, BlendMode.srcIn),
      ),
      title: loc.hintButton,
      onTap: () {/* TODO */},
      textColor: colors.hint,
    );

    // Кнопка проверки / продолжить
    final done = _answeredCorrectly;
    final secondTitle = done ? loc.continueBtn : loc.checkButton;
    final secondIcon = SvgPicture.asset(
      done
          ? 'lib/assets/icons/arrow_right_simple.svg'
          : 'lib/assets/icons/tick-circle.svg',
      width: 26,
      height: 26,
      colorFilter: ColorFilter.mode(colors.successGreen, BlendMode.srcIn),
    );
    final secondAction = done ? _onContinue : _onCheck;

    final actionButton = TaskActionButton(
      icon: secondIcon,
      title: secondTitle,
      onTap: secondAction,
      textColor: colors.successGreen,
    );

    // Ввод разрешён до правильного ответа
    final inputEnabled = !done;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // отступ снизу под клавиатуру
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                // минимум — вся доступная высота
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // —— Верхняя секция — AppBar + текст + матрицы
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AppBar-подобная шапка
                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: theme.appBarTheme.backgroundColor ??
                              theme.primaryColor,
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
                                        colors.text, BlendMode.srcIn),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  _getTitle(context),
                                  style: theme.textTheme.headlineMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${loc.task}: ${_getTaskSubtitle(loc, task!)}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Горизонтальный скролл матриц
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              MatrixDisplay(matrix: task.matrixA),
                              if (task.matrixB != null &&
                                  task.matrixB!.isNotEmpty) ...[
                                const SizedBox(width: 16),
                                MatrixDisplay(matrix: task.matrixB!),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                    // —— Средняя секция — MatrixInput без растягивания
                    MatrixInput(
                      key: _matrixKey,
                      rows: task.answer.length,
                      columns: task.answer.first.length,
                      cellSize: 40,
                      enabled: inputEnabled,
                      cellCorrectness:
                          _cellCorrectness.isEmpty ? null : _cellCorrectness,
                    ),

                    // —— Нижняя секция — кнопки с отступом сверху и снизу
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(child: hintButton),
                          const SizedBox(width: 16),
                          Expanded(child: actionButton),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
  String get firestoreCategory {
    switch (this) {
      case TaskType.basic:
        return 'addition_subtraction';
      case TaskType.simple:
        return 'multiplication';
      case TaskType.medium:
        return 'determinant';
      case TaskType.hard:
        return 'inverse';
    }
  }
}
