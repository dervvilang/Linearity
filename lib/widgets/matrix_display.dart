import 'package:flutter/material.dart';

/// Виджет для отображения матрицы с круглыми скобками
/// и фиксированной шириной колонок под значения от -99.9 до +99.9.
class MatrixDisplay extends StatelessWidget {
  final List<List<num>> matrix;

  const MatrixDisplay({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final theme     = Theme.of(context);
    // Табличные цифры, чтобы все цифры были одной ширины
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
          fontSize: 18,
          fontFeatures: [const FontFeature.tabularFigures()],
        ) ??
        const TextStyle(fontSize: 18);

    // Ширина одной ячейки, достаточная для "-99.9"
    const columnWidth = 56.0;

    // Формируем строки таблицы
    final rows = matrix.map<TableRow>((row) {
      return TableRow(
        children: row.map<Widget>((value) {
          // Если число целое — без десятых, иначе с одним знаком
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

  /// Скобка, растягивающаяся по высоте за счет FittedBox
  Widget _bracket(String ch, TextStyle base) {
    return Container(
      // немножко горизонтальных отступов
      padding: const EdgeInsets.symmetric(horizontal: 4),
      // растягиваем по вертикали (за счёт IntrinsicHeight в родителе)
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          ch,
          // задаём большой базовый размер — FittedBox подстроит его под высоту
          style: base.copyWith(
            fontSize: base.fontSize! * 2.5,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }
}
