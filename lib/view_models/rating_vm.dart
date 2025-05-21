// lib/view_models/rating_vm.dart

import 'package:flutter/foundation.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/models/user.dart';

class RatingViewModel extends ChangeNotifier {
  final FirestoreService _fs;
  bool isLoading = false;
  bool hasError = false;
  List<AppUser> users = [];

  RatingViewModel(this._fs);

  Future<void> loadUsers() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Ранги уже сохранены в базе, просто читаем топ-100
      users = await _fs.fetchUsers(limit: 100);
    } catch (e) {
      hasError = true;
      debugPrint('Error loading users for rating: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
