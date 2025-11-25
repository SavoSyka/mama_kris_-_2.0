import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  @override
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistoryKey);
    if (historyJson != null) {
      final List<dynamic> historyList = json.decode(historyJson);
      return historyList.cast<String>();
    }
    return [];
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final currentHistory = await getSearchHistory();

    // Remove if already exists to avoid duplicates
    currentHistory.remove(query);

    // Add to beginning
    currentHistory.insert(0, query);

    // Keep only max items
    if (currentHistory.length > _maxHistoryItems) {
      currentHistory.removeRange(_maxHistoryItems, currentHistory.length);
    }

    final historyJson = json.encode(currentHistory);
    await prefs.setString(_searchHistoryKey, historyJson);
  }

  @override
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }
}