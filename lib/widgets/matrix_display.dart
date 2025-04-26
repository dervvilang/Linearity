import 'package:flutter/material.dart';

/// Виджет для отображения матрицы с круглым оформлением (скобками).
/// [matrix] — матрица в виде списка списков чисел.
class MatrixDisplay extends StatelessWidget {
  final List<List<num>> matrix;
  
  const MatrixDisplay({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    // Создаем TableRow для каждой строки матрицы.
    // Для каждой ячейки добавляем отступы и центрируем текст.
    List<TableRow> rows = matrix.map((row) {
      return TableRow(
        children: row.map((value) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        }).toList(),
      );
    }).toList();

    // Используем IntrinsicHeight, чтобы дочерние виджеты (таблица и скобки) получили одинаковую высоту.
    return IntrinsicHeight(
      child: Row(
        // Растягиваем всех детей по вертикали
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize.min - чтобы Row занимал минимально необходимую ширину
        mainAxisSize: MainAxisSize.min,
        children: [
          // Левая скобка: обернута в Container с горизонтальными отступами,
          // а затем в FittedBox для масштабирования по высоте.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: const Text(
                '(',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          // Таблица с матрицей: задаем фиксированную ширину столбцов,
          // чтобы обеспечить корректное распределение ячеек по горизонтали.
          Table(
            // Фиксированная ширина для каждой ячейки (настраиваемая)
            defaultColumnWidth: const FixedColumnWidth(35.0),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: rows,
          ),
          // Правая скобка, аналогично левой.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: const Text(
                ')',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
