import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class EmpAuthLocalDataSource {
  /// Save authentication token locally
  Future<void> saveToken(String token);
  Future<void> saveUserType(bool isApplicant);
  Future<bool> getUserType();

  /// Retrieve authentication token
  Future<String?> getToken();

  Future<void> saveRefreshToken(String token);

  /// Save user ID locally
  Future<void> saveUserId(String userId);

  /// Retrieve saved user ID
  Future<String?> getUserId();

  /// Save full user data (if needed)
  Future<void> saveUser(Map<String, dynamic> userJson);

  /// Retrieve user data
  Future<Map<String, dynamic>?> getUser();

  /// Remove authentication token
  Future<void> removeToken();

  Future<void> removeRefreshToken();

  /// Remove user data
  Future<void> removeUser();

  /// Clear all authentication-related data
  Future<void> clearAll();
}

class EmpAuthLocalDataSourceImpl implements EmpAuthLocalDataSource {
  final SharedPreferences prefs;

  EmpAuthLocalDataSourceImpl(this.prefs);

  static const _tokenKey = 'auth_token';

  static const _userIdKey = 'user_id';

  static const _userKey = 'user_data';

  static const _refreshKey = 'refreshKey';
  static const _applicantkey = '_applicationKey';

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await prefs.setString(_userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    return prefs.getString(_userIdKey);
  }

  @override
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await prefs.setString(_userKey, jsonEncode(userJson));
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<void> removeToken() async {
    await prefs.remove(_tokenKey);
  }

  @override
  Future<void> removeUser() async {
    await prefs.remove(_userIdKey);
    await prefs.remove(_userKey);
  }

  @override
  Future<void> clearAll() async {
    await prefs.clear();
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await prefs.setString(_refreshKey, token);
  }

  @override
  Future<void> removeRefreshToken() async {
    await prefs.remove(_refreshKey);
  }

  @override
  Future<bool> getUserType() async {
    final isApplicant = prefs.getBool(_applicantkey) ?? false;

    return isApplicant;
  }

  @override
  Future<void> saveUserType(bool isApplicant) async {
    await prefs.setBool(_applicantkey, isApplicant);
  }
}
