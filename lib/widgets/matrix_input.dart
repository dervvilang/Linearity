// lib/widgets/matrix_input.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Поле ввода для матрицы
class MatrixInput extends StatefulWidget {
  final int rows;
  final int columns;
  final double cellSize;
  /// Подсветка корректности ответов
  final List<List<bool>>? cellCorrectness;
  /// Включает или отключает ввод
  final bool enabled;

  const MatrixInput({
    super.key,
    required this.rows,
    required this.columns,
    this.cellSize = 50,
    this.cellCorrectness,
    this.enabled = true,
  });

  @override
  MatrixInputState createState() => MatrixInputState();
}

class MatrixInputState extends State<MatrixInput> {
  late final List<List<TextEditingController>> _controllers;

  /// Создаёт контроллеры для всех ячеек
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.rows,
      (_) => List.generate(widget.columns, (_) => TextEditingController()),
    );
  }

  @override
  void dispose() {
    for (final row in _controllers) {
      for (final c in row) {
        c.dispose();
      }
    }
    super.dispose();
  }

  /// Возвращает введённую матрицу чисел
  List<List<num>> getMatrix() {
    return _controllers.map((row) {
      return row.map((c) {
        final str = c.text.replaceAll(',', '.');
        return num.tryParse(str) ?? 0;
      }).toList();
    }).toList();
  }

  /// Очищает все поля ввода
  void clear() {
    if (!mounted) return;
    for (final row in _controllers) {
      for (final c in row) {
        c.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.answer,
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: colors.text)),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _bracket('(', colors.text),
                Table(
                  defaultColumnWidth: FixedColumnWidth(widget.cellSize + 8),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: List.generate(widget.rows, (i) {
                    return TableRow(
                      children: List.generate(widget.columns, (j) {
                        final ok = widget.cellCorrectness?[i][j];
                        final txt = ok == null
                            ? colors.text2
                            : (ok ? Colors.green : Colors.red);

                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: widget.cellSize,
                            height: widget.cellSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.firstLevel,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextField(
                              readOnly: !widget.enabled,
                              controller: _controllers[i][j],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: txt),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[-\d.,]')),
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
                  }),
                ),
                _bracket(')', colors.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Рисует скобку, растягивающуюся по высоте
  Widget _bracket(String ch, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          child: Text(
            ch,
            style: TextStyle(fontWeight: FontWeight.w200, color: color),
          ),
        ),
      );
}
