import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService extends ChangeNotifier {
  final Box _authBox = Hive.box('auth');
  bool _isLoggedIn = false;
  String? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;

  AuthService() {
    _loadAuthState();
  }

  void _loadAuthState() {
    _isLoggedIn = _authBox.get('isLoggedIn', defaultValue: false);
    _currentUser = _authBox.get('currentUser');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // In a real app, you would verify credentials with a backend
    // For now, we'll use a simple check
    final users = _authBox.get('users', defaultValue: <String, String>{}) as Map;
    
    if (users[email] == password) {
      _isLoggedIn = true;
      _currentUser = email;
      await _authBox.put('isLoggedIn', true);
      await _authBox.put('currentUser', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    final users = _authBox.get('users', defaultValue: <String, String>{}) as Map;
    
    if (users.containsKey(email)) {
      return false; // User already exists
    }

    users[email] = password;
    await _authBox.put('users', users);
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    await _authBox.put('isLoggedIn', false);
    await _authBox.put('currentUser', null);
    notifyListeners();
  }
} 