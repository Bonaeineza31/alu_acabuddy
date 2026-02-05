import 'package:flutter/material.dart';
import '../models/user.dart';

/// Provider for managing user data
class UserProvider extends ChangeNotifier {
  User? _currentUser;

  /// Get current user
  User? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Login user (for now, just store user data)
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Update user profile
  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  /// Get user's full name
  String get userName => _currentUser?.fullName ?? 'Student';

  /// Get user's first name
  String get userFirstName {
    if (_currentUser == null) return 'Student';
    return _currentUser!.fullName.split(' ').first;
  }
}