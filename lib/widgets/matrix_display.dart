// lib/widgets/matrix_display.dart

import 'package:flutter/material.dart';

/// Отображает матрицу с круглым скобками
class MatrixDisplay extends StatelessWidget {
  final List<List<num>> matrix;

  const MatrixDisplay({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    /// Моноширинный текст для выравнивания цифр
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
          fontSize: 18,
          fontFeatures: [const FontFeature.tabularFigures()],
        ) ??
        const TextStyle(fontSize: 18);

    /// Ширина ячейки для значений от -99.9 до +99.9
    const columnWidth = 56.0;

    /// Преобразует каждое число в строку с нужным форматом
    final rows = matrix.map<TableRow>((row) {
      return TableRow(
        children: row.map<Widget>((value) {
          final str = (value % 1 == 0)
              ? value.toInt().toString()
              : value.toStringAsFixed(1);
          return Container(
            width: columnWidth,
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            child: Text(str, style: textStyle),
          );
        }).toList(),
      );
    }).toList();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _bracket('(', textStyle),
          Table(
            defaultColumnWidth: const FixedColumnWidth(columnWidth),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: rows,
          ),
          _bracket(')', textStyle),
        ],
      ),
    );
  }

  /// Рисует скобку заданной высоты
  Widget _bracket(String ch, TextStyle base) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          ch,
          style: base.copyWith(
            fontSize: base.fontSize! * 2.5,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }
}
