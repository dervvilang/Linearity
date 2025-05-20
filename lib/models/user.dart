// lib/models/user.dart

class AppUser {
  final String id;
  final String email;
  final String username;
  final String avatarAsset; 
  final String description;
  final int score;
  final int rank;

  AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.avatarAsset,
    this.description = '',
    this.score = 0,
    this.rank = 0,
  });

  /// Создаёт AppUser из карты (например, из документа Firestore).
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      avatarAsset: map['avatarAsset'] as String? 
          ?? 'lib/assets/icons/avatar_2.svg',
      description: map['description'] as String? ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      rank: (map['rank'] as num?)?.toInt() ?? 0,
    );
  }

  /// Преобразует AppUser в карту для записи в Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarAsset': avatarAsset,
      'description': description,
      'score': score,
      'rank': rank,
    };
  }

  /// Возвращает копию AppUser с обновлёнными полями.
  AppUser copyWith({
    String? username,
    String? avatarAsset,
    String? description,
    int? score,
    int? rank,
    String? userTheme,
  }) {
    return AppUser(
      id: id,
      email: email,
      username: username ?? this.username,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      description: description ?? this.description,
      score: score ?? this.score,
      rank: rank ?? this.rank,
    );
  }
}
