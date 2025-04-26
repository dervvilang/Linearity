// ignore_for_file: file_names

class User {
    final String id;
    String username;
    String avatarUrl;
    String email;
    int score;
    int rank;
    String description;

    User({
      required this.id,
      required this.username,
      this.avatarUrl = '',
      required this.email,
      this.score = 0,
      this.rank = 0,
      this.description = '',
    });

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'email': email,
      'score': score,
      'rank': rank,
      'description': description,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User (
      id: map['id'],
      username: map['username'],
      avatarUrl: map['avatarUrl'] ?? '',
      email: map['email'],
      score: map['score'] ?? 0,
      rank: map['rank'] ?? 0,
      description: map['description'] ?? '',
    );
  }
}