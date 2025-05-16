/// Модель одного задания (например, сложение/вычитание матриц)
class TaskModel {
  final String type;       // тип задания, например "addition" или "subtraction"
  final String operation;  // символ операции, например "+" или "-"
  final String pattern;    // шаблон задания (например, диагональная матрица и т.п.)
  final List<List<int>> matrixA;
  final List<List<int>> matrixB;
  final List<List<int>> answer;

  TaskModel({
    required this.type,
    required this.operation,
    required this.pattern,
    required this.matrixA,
    required this.matrixB,
    required this.answer,
  });

  /// Фабричный конструктор: создание TaskModel из данных Firestore (Map JSON)
  factory TaskModel.fromMap(Map<String, dynamic> data) {
    // Вспомогательная функция для парсинга матрицы из списка
    List<List<int>> parseMatrix(List<dynamic> matrixData) {
      return matrixData.map((row) {
        // Каждая строка представлена как Map с ключами-индексами столбцов
        if (row is Map<String, dynamic>) {
          // Сортируем ключи, чтобы получить значения в правильном порядке столбцов
          var sortedKeys = row.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
          return sortedKeys.map((colKey) => row[colKey] as int).toList();
        } else if (row is List) {
          // Если уже список (на случай другого формата)
          return List<int>.from(row);
        } else {
          return <int>[]; // непредвиденный формат
        }
      }).toList();
    }

    return TaskModel(
      type: data['type'] as String,
      operation: data['operation'] as String,
      pattern: data['pattern'] as String,
      matrixA: parseMatrix(data['matrixA'] as List<dynamic>),
      matrixB: parseMatrix(data['matrixB'] as List<dynamic>),
      answer: parseMatrix(data['answer'] as List<dynamic>),
    );
  }
}
