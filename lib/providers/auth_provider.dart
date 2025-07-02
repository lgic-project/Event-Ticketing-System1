import 'package:flutter/foundation.dart';
import 'package:event_ticketing_system1/models/users.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _currentUser?.token;

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );
      // final data = json.decode(response.body);

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Dummy user for now
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
        isAdmin: email.contains('admin'), // Simple admin check for demo
      );

      // TODO: Save token to secure storage
      // await secureStorage.write(key: 'auth_token', value: _currentUser!.token);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/auth/signup'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'name': name,
      //     'email': email,
      //     'password': password,
      //   }),
      // );
      // final data = json.decode(response.body);

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Auto-login after signup
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
        isAdmin: false,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // TODO: Call logout API if needed
      // await http.post(
      //   Uri.parse('your-api-url/auth/logout'),
      //   headers: {'Authorization': 'Bearer ${_currentUser?.token}'},
      // );

      // TODO: Clear token from secure storage
      // await secureStorage.delete(key: 'auth_token');

      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (error) {
      print('Logout error: $error');
      // Still clear local user data even if API call fails
      _currentUser = null;
      notifyListeners();
    }
  }

  // Check auth status (for app startup)
  Future<void> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Check for saved token and validate it
      // final savedToken = await secureStorage.read(key: 'auth_token');
      // if (savedToken != null) {
      //   final response = await http.get(
      //     Uri.parse('your-api-url/auth/me'),
      //     headers: {'Authorization': 'Bearer $savedToken'},
      //   );
      //   final userData = json.decode(response.body);
      //   _currentUser = User.fromJson(userData);
      // }

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      _currentUser = null;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('your-api-url/users/${_currentUser!.id}'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer ${_currentUser!.token}',
      //   },
      //   body: json.encode({
      //     'name': name,
      //     'email': email,
      //     'phone': phone,
      //   }),
      // );
      // final userData = json.decode(response.body);

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Update current user
      _currentUser = User(
        id: _currentUser!.id,
        name: name,
        email: email,
        token: _currentUser!.token,
        isAdmin: _currentUser!.isAdmin,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/auth/reset-password'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'email': email}),
      // );

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
