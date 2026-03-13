import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api/auth'));
  String? _token;
  bool get isLoggedIn => _token != null;

  AuthProvider() {
    _loadToken();
    // Simulate authentication for testing
    _token = 'dummy_token';
    notifyListeners();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? 'dummy_token'; // Default to dummy for testing
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {'email': email, 'password': password});
      await _saveToken(response.data['token']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _dio.post('/register', data: {'email': email, 'password': password});
      // After signup, sign in
      await signIn(email, password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    notifyListeners();
  }
}
