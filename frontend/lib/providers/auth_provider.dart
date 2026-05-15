import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    if (response['user'] != null) {
      _user = User.fromJson(response['user']);
      await _saveUserToPrefs(_user!);
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> register(String nom, String email, String password) async {
    return await _apiService.register(nom, email, password);
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) return;

    final userData = jsonDecode(prefs.getString('user')!);
    _user = User.fromJson(userData);
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
}
