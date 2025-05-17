enum OperationType {
  addition,
  subtraction,
  multiplication,
  determinant,
  inverse,
}

class MatrixTask {
  final String id;
  final OperationType type;
  final String pattern;
  final List<List<num>> matrixA;
  final List<List<num>>? matrixB;
  final List<List<num>> answer;

  MatrixTask({
    required this.id,
    required this.type,
    required this.pattern,
    required this.matrixA,
    this.matrixB,
    required this.answer,
  });

  /// Создаёт MatrixTask из JSON-данных из Firestore.
  factory MatrixTask.fromJson(String id, Map<String, dynamic> json) {
    List<List<num>> parseMatrix(List<dynamic>? raw) {
      if (raw == null) return <List<num>>[];
      return raw.map<List<num>>((row) {
        // row — это Map<String, dynamic> вида {'0': x, '1': y, ...}
        final Map<String, dynamic> rowMap = Map<String, dynamic>.from(row);
        final int size = rowMap.length;
        // Собираем значение по индексам 0..size-1
        return List<num>.generate(
          size,
          (i) => rowMap[i.toString()] as num,
        );
      }).toList();
    }

    // Парсим строку типа операции в enum
    final rawType = (json['type'] as String).toLowerCase();
    final type = OperationType.values.firstWhere(
      (e) => e.toString().split('.').last == rawType,
      orElse: () => throw ArgumentError('Unknown OperationType: $rawType'),
    );

    return MatrixTask(
      id: id,
      type: type,
      pattern: json['pattern'] as String,
      matrixA: parseMatrix(json['matrixA'] as List<dynamic>?),
      matrixB: json.containsKey('matrixB')
          ? parseMatrix(json['matrixB'] as List<dynamic>?)
          : null,
      answer: parseMatrix(json['answer'] as List<dynamic>?),
    );
  }

  /// Преобразует объект в JSON (на всякий случай).
  Map<String, dynamic> toJson() {
    Map<String, dynamic> encodeMatrix(List<List<num>> m) {
      return {
        for (int i = 0; i < m.length; i++)
          i.toString(): {
            for (int j = 0; j < m[i].length; j++) j.toString(): m[i][j]
          }
      };
    }

    return <String, dynamic>{
      'type': type.toString().split('.').last,
      'pattern': pattern,
      'matrixA': matrixA
          .map((row) => {for (var i = 0; i < row.length; i++) i.toString(): row[i]})
          .toList(),
      if (matrixB != null)
        'matrixB': matrixB!
            .map((row) => {for (var i = 0; i < row.length; i++) i.toString(): row[i]})
            .toList(),
      'answer': answer
          .map((row) => {for (var i = 0; i < row.length; i++) i.toString(): row[i]})
          .toList(),
    };
  }
}
