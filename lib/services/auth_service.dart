import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Demo users for testing
  static const Map<String, String> _demoUsers = {
    'demo@learnhub.com': 'demo123',
    'admin@learnhub.com': 'admin123',
    'student@learnhub.com': 'student123',
  };

  static Future<bool> signInWithEmail(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Check if user exists in demo users
    if (_demoUsers.containsKey(email) && _demoUsers[email] == password) {
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }
    return false;
  }

  static Future<bool> signInWithDemo() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Save demo login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, 'demo@learnhub.com');
    await prefs.setBool(_isLoggedInKey, true);
    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_isLoggedInKey);
  }

  static String getUserDisplayName(String email) {
    switch (email) {
      case 'demo@learnhub.com':
        return 'Demo User';
      case 'admin@learnhub.com':
        return 'Admin User';
      case 'student@learnhub.com':
        return 'Student User';
      default:
        return 'User';
    }
  }
}
