// lib/models/matrix_task.dart

/// Тип операции
enum OperationType {
  addition,
  subtraction,
  multiplication,
  determinant,
  inverse,
}

/// Задача над матрицами (или детерминант)
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

  factory MatrixTask.fromJson(String id, Map<String, dynamic> json) {
    // Парсер «матрицы» List<Map<'0':…, '1':…>> → List<List<num>>
    List<List<num>> parseMatrix(List<dynamic>? raw) {
      if (raw == null) return <List<num>>[];
      return raw.map<List<num>>((row) {
        final rowMap = Map<String, dynamic>.from(row as Map);
        return List<num>.generate(
          rowMap.length,
          (i) => rowMap[i.toString()] as num,
        );
      }).toList();
    }

    // Определяем enum из json['type']
    final rawType = (json['type'] as String).toLowerCase();
    final opType = OperationType.values.firstWhere(
      (e) => e.toString().split('.').last == rawType,
      orElse: () => throw ArgumentError('Unknown OperationType: $rawType'),
    );

    // matrixA всегда есть
    final a = parseMatrix(json['matrixA'] as List<dynamic>?);

    // matrixB есть только для add/sub/mult
    final b = (json.containsKey('matrixB'))
        ? parseMatrix(json['matrixB'] as List<dynamic>?)
        : null;

    // ответ: если детерминант — число → упакуем в 1×1
    final answerField = json['answer'];
    final ans = (opType == OperationType.determinant && answerField is num)
        ? <List<num>>[
            <num>[answerField]
          ]
        : parseMatrix(json['answer'] as List<dynamic>?);

    return MatrixTask(
      id: id,
      type: opType,
      pattern: json['pattern'] as String,
      matrixA: a,
      matrixB: b,
      answer: ans,
    );
  }

  Map<String, dynamic> toJson() {
    // Утилита: List<List<num>> → List<Map<String,num>>
    List<Map<String, num>> encodeRow(List<num> row) {
      return [
        for (int i = 0; i < row.length; i++) {i.toString(): row[i]}
      ];
    }

    final data = <String, dynamic>{
      'type': type.toString().split('.').last,
      'pattern': pattern,
      'matrixA': matrixA.map((r) => encodeRow(r)).toList(),
    };

    if (matrixB != null) {
      data['matrixB'] = matrixB!.map((r) => encodeRow(r)).toList();
    }

    // Если это детерминант и answer — 1×1, то кладём скаляр
    if (type == OperationType.determinant && answer.length == 1 && answer[0].length == 1) {
      data['answer'] = answer[0][0];
    } else {
      data['answer'] = answer.map((r) => encodeRow(r)).toList();
    }

    return data;
  }
}
