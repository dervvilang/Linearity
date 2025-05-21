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
      users = await _fs.fetchAllUsersByScore();
      // проставляем rank по порядку
      for (int i = 0; i < users.length; i++) {
        users[i] = users[i].copyWith(rank: i + 1);
      }
    } catch (e) {
      hasError = true;
      debugPrint('Error loading users for rating: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
