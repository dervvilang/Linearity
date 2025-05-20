/// Модель пользователя для хранения в Firestore и в приложении.
class AppUser {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final String description;
  final int score;
  final int rank;
  final String userTheme;

  /// Конструктор
  AppUser({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
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
      avatarUrl: map['avatarUrl'] as String?,
      description: map['description'] as String? ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      userTheme: map['userTheme'] as String? ?? 'light',
    );
  }

  /// Преобразование в Map для записи в Firestore
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'description': description,
      'score': score,
      'rank': rank,
      'userTheme': userTheme,
    };
    if (avatarUrl != null) {
      data['avatarUrl'] = avatarUrl;
    }
    return data;
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
