import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linearity/themes/additional_colors.dart';

/// Виджет для ввода матрицы в виде таблицы с обрамлением скобками.
/// Отображается внутри контейнера, где сверху написано "Ответ:" и ниже – поле для ввода матрицы.
class MatrixInput extends StatefulWidget {
  final int rows;
  final int columns;
  final double cellSize;

  const MatrixInput({
    super.key,
    required this.rows,
    required this.columns,
    this.cellSize = 50.0,
  });

  @override
  _MatrixInputState createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  // 2D-список контроллеров для каждого TextField.
  late final List<List<TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры: для каждой строки создаем список контроллеров для каждой ячейки.
    _controllers = List.generate(
      widget.rows,
      (_) => List.generate(widget.columns, (_) => TextEditingController()),
    );
  }

  @override
  void dispose() {
    // Освобождаем каждый контроллер для предотвращения утечек памяти.
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Дополнительные цвета
    final additionalColors = theme.extension<AdditionalColors>()!;
    // Формируем строки таблицы: каждая ячейка – это Container фиксированного размера с отступами и TextField внутри.
    final List<TableRow> tableRows = List.generate(widget.rows, (i) {
      return TableRow(
        children: List.generate(widget.columns, (j) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: widget.cellSize,
              height: widget.cellSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: additionalColors.firstLevel, // фон ячейки
                //border: Border.all(color: additionalColors.inactiveButtons),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _controllers[i][j],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                // Разрешаем только цифры, минус, точку и запятую
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[-\d.,]')),
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ),
          );
        }),
      );
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: additionalColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Контейнер подстраивается под содержимое
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок "Ответ:"
          Text(
            'Ответ:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: additionalColors.text,
                ),
          ),
          const SizedBox(height: 8),
          // Область ввода матрицы обрамленная скобками.
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Левая скобка: реализована с помощью Container с горизонтальными отступами и FittedBox.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '(',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: additionalColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Таблица с вводом матрицы.
                Table(
                  // Задаем фиксированную ширину столбцов: ширина ячейки плюс отступы (4.0 * 2).
                  defaultColumnWidth: FixedColumnWidth(widget.cellSize + 8.0),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: tableRows,
                ),
                const SizedBox(width: 4),
                // Правая скобка, аналогично левой.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      ')',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: additionalColors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
