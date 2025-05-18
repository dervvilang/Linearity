/// Модель пользователя для хранения в Firestore и в приложении.
class AppUser {
  /// Уникальный ID пользователя (например, из FirebaseAuth.uid)
  final String id;

  /// Email, используется для входа
  final String email;

  /// Никнейм, задаётся при регистрации
  final String username;

  /// URL аватарки; по умолчанию — локальный SVG из assets
  final String avatarUrl;

  /// Описание профиля; может быть пустым
  final String description;

  /// Накопленные баллы за решения
  final int score;

  /// Позиция в рейтинге (0 означает «не рассчитано»)
  final int rank;

  /// Тема, предпочитаемая пользователем: "light" или "dark"
  final String userTheme;

  /// Конструктор
  AppUser({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl =
        'lib/assets/icons/avatar_2.svg',
    this.description = '',
    this.score = 0,
    this.rank = 0,
    this.userTheme = 'light',
  });

  /// Преобразование из Map (например, документ Firestore)
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      avatarUrl: map['avatarUrl'] as String? ??
          'lib/assets/icons/avatar_2.svg',
      description: map['description'] as String? ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      userTheme: map['userTheme'] as String? ?? 'light',
    );
  }

  /// Преобразование в Map для записи в Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'description': description,
      'score': score,
      'rank': rank,
      'userTheme': userTheme,
    };
  }

  /// Удобный copyWith для обновления части полей
  AppUser copyWith({
    String? username,
    String? avatarUrl,
    String? description,
    int? score,
    int? rank,
    String? userTheme,
  }) {
    return AppUser(
      id: id,
      email: email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      description: description ?? this.description,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      userTheme: userTheme ?? this.userTheme,
    );
  }
}
