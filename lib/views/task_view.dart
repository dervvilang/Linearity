// lib/views/task_view.dart

import 'package:flutter/material.dart';
import 'package:linearity/models/matrix_task.dart';
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
import 'package:linearity/views/win_view.dart';

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

      _vm.loadHint(widget.taskType.firestoreCategory);
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

  /// Проверка ответа через ViewModel
  Future<void> _onCheck() async {
    FocusScope.of(context).unfocus();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _vm.submitAnswer(
      _matrixKey.currentState!.getMatrix(),
      uid,
    );
  }

  /// Переход дальше после верного ответа
  void _onContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WinView()),
    );
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
      return Scaffold(
        body: Center(child: Text(loc.taskError)),
      );
    }
    final task = vm.currentTask;
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(_getTitle(context))),
        body: Center(child: Text(loc.taskError)),
      );
    }

    final hintButton = TaskActionButton(
      icon: SvgPicture.asset(
        'lib/assets/icons/hint.svg',
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(colors.hint, BlendMode.srcIn),
      ),
      title: loc.hintButton,
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(loc.hintButton),
            content: Text(vm.hintText ?? loc.hintButton),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.exitButton),
              ),
            ],
          ),
        );
      },
      textColor: colors.hint,
    );

    // Кнопка проверки / продолжить
    final done = vm.answeredCorrectly;
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

    final inputEnabled = !done;
    final correctness =
        vm.cellCorrectness.isNotEmpty ? vm.cellCorrectness : null;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            '${loc.task}: ${_getTaskSubtitle(loc, task)}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                    MatrixInput(
                      key: _matrixKey,
                      rows: task.answer.length,
                      columns: task.answer.first.length,
                      cellSize: 40,
                      enabled: inputEnabled,
                      cellCorrectness: correctness,
                    ),
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
