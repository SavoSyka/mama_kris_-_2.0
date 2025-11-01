import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/data/mock_jobs.dart';

class VacancyService {
  static bool _isFetching = false;
  static String? _lastErrorMessage;

  static String? getLastErrorMessage() => _lastErrorMessage;

  /// Существующие функции не изменяются:
  static Future<List<Map<String, dynamic>>> loadCachedVacancies() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('saved_jobs');
    if (cached != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cached));
    }
    return [];
  }

  static Future<void> saveCachedVacancies(
    List<Map<String, dynamic>> jobs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_jobs', jsonEncode(jobs));
  }

  static Future<void> removeFromCache(int jobID) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('saved_jobs');
    if (cached != null) {
      List<dynamic> list = jsonDecode(cached);
      list.removeWhere((job) => job['jobID'] == jobID);
      await prefs.setString('saved_jobs', jsonEncode(list));
    }
  }

  static Future<List<Map<String, dynamic>>> fetchVacancies({
    bool append = false,
  }) async {
    if (_isFetching) return [];
    _isFetching = true;

    debugPrint("Fetching cvacony 000 ");

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');

    debugPrint("Fetching cvacony 000  $accessToken $userId ");

    if (accessToken == null || userId == null) {
      _isFetching = false;
      return [];
    }

    debugPrint("Fetching mock jobs");
    try {
      final jobs = await getMockJobs();
      if (append) {
        final existing = await loadCachedVacancies();
        final newOnes = jobs
            .where((job) => !existing.any((e) => e['jobID'] == job['jobID']))
            .toList();
        final updated = [...existing, ...newOnes];
        await saveCachedVacancies(updated);
        _isFetching = false;
        return updated;
      } else {
        await saveCachedVacancies(jobs);
        _isFetching = false;
        return jobs;
      }
    } catch (e) {
      debugPrint("Ошибка получения mock вакансий: $e");
    }

    _isFetching = false;
    return [];
  }

  /// Новые функции для работы с уменьшённым кэшем вакансий (для списка)

  /// Преобразует вакансию в уменьшённый формат (jobID, title, salary)
  static Map<String, dynamic> _reduceVacancyForCache(
    Map<String, dynamic> vacancy,
  ) {
    if (vacancy.containsKey('job')) {
      return {
        'jobID': vacancy['job']['jobID'],
        'title': vacancy['job']['title'],
        'salary': vacancy['job']['salary'],
      };
    } else {
      return {
        'jobID': vacancy['jobID'],
        'title': vacancy['title'],
        'salary': vacancy['salary'],
      };
    }
  }

  /// Сохраняет вакансии в уменьшённом формате по ключу 'saved_reduced_jobs',
  /// ограничивая количество сохраняемых элементов до 100.
  static Future<void> saveCachedVacanciesReduced(
    List<Map<String, dynamic>> jobs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final reduced = jobs.map((job) => _reduceVacancyForCache(job)).toList();
    final limited = reduced.length > 100
        ? reduced.sublist(reduced.length - 100)
        : reduced;
    await prefs.setString('saved_reduced_jobs', jsonEncode(limited));
  }

  /// Загружает вакансии из уменьшённого кэша по ключу 'saved_reduced_jobs'.
  static Future<List<Map<String, dynamic>>> loadCachedVacanciesReduced() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('saved_reduced_jobs');
    if (cached != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cached));
    }
    return [];
  }

  /// Обновляет уменьшённый кэш, объединяя существующие вакансии с новыми
  /// и ограничивая итоговое количество до 100.
  static Future<List<Map<String, dynamic>>> updateCachedVacanciesReduced(
    List<Map<String, dynamic>> newJobs,
  ) async {
    final existing = await loadCachedVacanciesReduced();
    final reducedNewJobs = newJobs
        .map((job) => _reduceVacancyForCache(job))
        .toList();
    final combined = [...existing, ...reducedNewJobs];
    final limited = combined.length > 100
        ? combined.sublist(combined.length - 100)
        : combined;
    await saveCachedVacanciesReduced(limited);
    return limited;
  }

  /// Новый метод для получения вакансий для списка с кэшированием.
  /// Сервер возвращает пакетами по 7 вакансий.
  static Future<List<Map<String, dynamic>>> fetchVacanciesForListWithCache({
    required int page,
  }) async {
    debugPrint("Fetching mock jobs for list");
    try {
      final jobs = await getMockJobs();
      final updatedCache = await updateCachedVacanciesReduced(jobs);
      return updatedCache;
    } catch (e) {
      debugPrint("Ошибка получения mock вакансий для списка: $e");
    }
    return [];
  }

  /// Лайкнуть вакансию
  static Future<bool> likeVacancy(int jobId) async {
    return _sendReaction(jobId, true);
  }

  /// Дизлайкнуть вакансию
  static Future<bool> dislikeVacancy(int jobId) async {
    return _sendReaction(jobId, false);
  }

  static Future<bool> _sendReaction(int jobId, bool isLiked) async {
    debugPrint("Mock reaction: $jobId, liked: $isLiked");
    // For mock, always succeed
    _lastErrorMessage = null;
    return true;
  }

  static Future<Map<String, dynamic>?> fetchVacancyById(int jobId) async {
    debugPrint("Fetching mock vacancy by id: $jobId");
    try {
      final jobs = await getMockJobs();
      for (var j in jobs) {
        if (j['jobID'] == jobId) {
          return j['job'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint("Ошибка получения mock вакансии по id: $e");
    }
    return null;
  }

  static Future<void> removeFromReducedCache(int jobID) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('saved_reduced_jobs');
    // print("removeFromReducedCache: cached = $cached");
    if (cached != null) {
      List<dynamic> list = jsonDecode(cached);
      // int initialCount = list.length;
      list.removeWhere((job) {
        // В редюсед кэше мы ожидаем, что каждая вакансия представлена в сокращённом виде,
        // то есть имеет поля jobID, title, salary.
        var id = job['jobID'];
        // print("removeFromReducedCache: checking job with id = $id");
        return id?.toString() == jobID.toString();
      });
      // int finalCount = list.length;
      // print(
      //   "removeFromReducedCache: removed ${initialCount - finalCount} vacancies",
      // );
      await prefs.setString('saved_reduced_jobs', jsonEncode(list));
    }
  }
}
