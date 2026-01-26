import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  /// Save authentication token locally
  Future<void> saveToken(String token);
  Future<void> saveUserType(bool isApplicant);
  Future<bool> getUserType();

  /// Retrieve authentication token
  Future<String> getToken();

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
  Future<bool> getSubscription();
  Future<void> saveSubscription(bool status);
  Future<int?> getViewedJobsCount();
  Future<void> saveViewedJobsCount(int count);
  Future<void> saveSessionId(int sessionId);
  Future<int?> getSessionId();
  Future<void> removeSessionId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  static const _tokenKey = 'auth_token';

  static const _userIdKey = 'user_id';

  static const _userKey = 'user_data';

  static const _refreshKey = 'refresh_token';
  static const _applicantkey = '_applicationKey';
  static const _subscriptionKey = '_subscriptionKey';
  static const _viewedJobsCountKey = '_viewedJobsCountKey';
  static const _sessionIdKey = '_sessionId';

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String> getToken() async {
    final token = prefs.getString(_tokenKey) ?? "";

    debugPrint("Token used for this service [[[ $token  ]]] ");
    return token;
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
    debugPrint("\n\nType of user data get to app 😊$isApplicant\n\n");

    return isApplicant;
  }

  @override
  Future<void> saveUserType(bool isApplicant) async {
    debugPrint("\n\nType of user data saved to app 😊$isApplicant\n\n");
    await prefs.setBool(_applicantkey, isApplicant);
  }

  @override
  Future<bool> getSubscription() async {
    final isActive = prefs.getBool(_subscriptionKey) ?? false;

    return isActive;
  }

  @override
  Future<void> saveSubscription(bool status) async {
    await prefs.setBool(_subscriptionKey, status);
  }

  @override
  Future<int?> getViewedJobsCount() async {
    return prefs.getInt(_viewedJobsCountKey);
  }

  @override
  Future<void> saveViewedJobsCount(int count) async {
    await prefs.setInt(_viewedJobsCountKey, count);
  }

  @override
  Future<void> saveSessionId(int sessionId) async {
    await prefs.setInt(_sessionIdKey, sessionId);
  }

  @override
  Future<int?> getSessionId() async {
    return prefs.getInt(_sessionIdKey);
  }

  @override
  Future<void> removeSessionId() async {
    await prefs.remove(_sessionIdKey);
  }
}
