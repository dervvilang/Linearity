// lib/views/task_view.dart

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

  /// true, когда последний ответ был правильным
  bool _answeredCorrectly = false;
  /// матрица true/false по ячейкам
  List<List<bool>> _cellCorrectness = [];

  @override
  void initState() {
    super.initState();
    _vm = context.read<TaskViewModel>();
    // грузим задачи сразу после первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.loadTasks(
        category: widget.taskType.firestoreCategory,
        level: widget.level,
        count: 3,
      );
    });
  }

  /// Проверяем ответ, подсвечиваем _cellCorrectness и ставим _answeredCorrectly
  void _onCheck() {
    final task = _vm.currentTask!;
    final userAns = _matrixKey.currentState!.getMatrix();
    final correctAns = task.answer;

    _cellCorrectness = List.generate(
      correctAns.length,
      (i) => List.generate(
        correctAns[i].length,
        (j) => userAns[i][j] == correctAns[i][j],
      ),
    );
    final allOk = _cellCorrectness.every((row) => row.every((x) => x));

    setState(() {
      _answeredCorrectly = allOk;
    });
  }

  /// Вызывается при нажатии "Продолжить"
  void _onContinue() {
    final userAns = _matrixKey.currentState!.getMatrix();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _vm.submitAnswer(userAns, uid);
    }
    // После submitAnswer currentIndex уже увеличился

    if (_vm.isComplete) {
      // Последняя задача — уходим на главный
      Navigator.popUntil(context, (r) => r.isFirst);
      return;
    }

    // Иначе очищаем ввод и сбрасываем флаги для следующей задачи
    _matrixKey.currentState!.clear();
    setState(() {
      _answeredCorrectly = false;
      _cellCorrectness = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    final vm = context.watch<TaskViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (vm.hasError) {
      return Scaffold(
        body: Center(child: Text('Ошибка загрузки задач')),
      );
    }
    final task = vm.currentTask;
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(_getTitle(context))),
        body: Center(child: Text('Задачи не найдены')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            // ——— AppBar ———
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
              child: Row(children: [
                Material(
                  shape: const CircleBorder(),
                  color: colors.greetingText,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'lib/assets/icons/arrow_left.svg',
                      width: 26, height: 26,
                      colorFilter:
                          ColorFilter.mode(colors.text, BlendMode.srcIn),
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
              ]),
            ),

            const SizedBox(height: 16),

            // ——— Заголовок ———
            Text(
              'Задание: ${_getTitle(context)}',
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: 16),

            // ——— Матрицы ———
            InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              boundaryMargin: const EdgeInsets.all(20),
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

            // ——— Ввод ответа ———
            MatrixInput(
              key: _matrixKey,
              rows: task.answer.length,
              columns: task.answer.first.length,
              cellSize: 40.0,
              cellCorrectness:
                  _cellCorrectness.isEmpty ? null : _cellCorrectness,
            ),

            const SizedBox(height: 24),

            // ——— Кнопки ———
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                // подсказка
                Expanded(
                  child: TaskActionButton(
                    initialIcon: SvgPicture.asset(
                      'lib/assets/icons/hint.svg',
                      width: 26,
                      height: 26,
                      colorFilter:
                          ColorFilter.mode(colors.hint, BlendMode.srcIn),
                    ),
                    initialTitle: loc.hintButton,
                    confirmedIcon: SvgPicture.asset(
                      'lib/assets/icons/hint.svg',
                      width: 26,
                      height: 26,
                      colorFilter:
                          ColorFilter.mode(colors.hint, BlendMode.srcIn),
                    ),
                    confirmedTitle: loc.hintButton,
                    textColor: colors.hint,
                    onTap: () {/* TODO */},
                    toggleOnTap: false,
                  ),
                ),

                const SizedBox(width: 16),

                // Check / Continue
                Expanded(
                  child: TaskActionButton(
                    initialIcon: SvgPicture.asset(
                      _answeredCorrectly
                          ? 'lib/assets/icons/arrow_right_simple.svg'
                          : 'lib/assets/icons/tick-circle.svg',
                      width: 26, height: 26,
                      colorFilter: ColorFilter.mode(
                          colors.successGreen, BlendMode.srcIn),
                    ),
                    initialTitle: _answeredCorrectly
                        ? loc.continueBtn
                        : loc.checkButton,
                    confirmedIcon: SvgPicture.asset(
                      _answeredCorrectly
                          ? 'lib/assets/icons/arrow_right_simple.svg'
                          : 'lib/assets/icons/tick-circle.svg',
                      width: 26, height: 26,
                      colorFilter: ColorFilter.mode(
                          colors.successGreen, BlendMode.srcIn),
                    ),
                    confirmedTitle: _answeredCorrectly
                        ? loc.continueBtn
                        : loc.checkButton,
                    textColor: colors.successGreen,
                    onTap: _answeredCorrectly ? _onContinue : _onCheck,
                    toggleOnTap: false,
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 16),
          ]),
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

/// Расширение для TaskType, возвращает имя коллекции в Firestore
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
