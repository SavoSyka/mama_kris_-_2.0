import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:flutter/foundation.dart';

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

    debugPrint("Fetching cvacony1");
    try {
      final spheresResponse = await http.get(
        Uri.parse('${kBaseUrl}user-preferences/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      debugPrint("spheresResponse.statusCode ${spheresResponse.statusCode}");
      if (spheresResponse.statusCode == 401) {
        final refreshed = await funcs.refreshAccessToken();
        _isFetching = false;
        if (refreshed) return fetchVacancies(append: append);
        return [];
      }

      if (spheresResponse.statusCode != 200) {
        _isFetching = false;
        return [];
      }

      debugPrint("spheresResponse.body ${spheresResponse.body}");
      final sphereIds = List<int>.from(jsonDecode(spheresResponse.body));
      final sphereParam = sphereIds.join(',');

      final jobsResponse = await http.get(
        Uri.parse(
          '${kBaseUrl}jobs/random-unviewed-approved/$userId?spheres=$sphereParam',
        ),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (jobsResponse.statusCode == 401) {
        final refreshed = await funcs.refreshAccessToken();
        _isFetching = false;
        if (refreshed) return fetchVacancies(append: append);
        return [];
      }

      if (jobsResponse.statusCode == 200) {
        final jobs = List<Map<String, dynamic>>.from(
          jsonDecode(jobsResponse.body),
        );
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
      }
    } catch (e) {
      // print("Ошибка получения вакансий: $e");
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
    // Параметр page здесь не используется, так как API возвращает 7 случайных вакансий каждый раз.
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (accessToken == null || userId == null) {
      // print("fetchVacanciesForListWithCache: auth_token or user_id is null");
      return [];
    }

    // Получаем список сфер пользователя
    final spheresResponse = await http.get(
      Uri.parse('${kBaseUrl}user-preferences/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (spheresResponse.statusCode != 200) {
      // print(
      //   "fetchVacanciesForListWithCache: Failed to get spheres, status code: ${spheresResponse.statusCode}",
      // );
      return [];
    }
    final sphereIds = List<int>.from(jsonDecode(spheresResponse.body));
    final sphereParam = sphereIds.join(',');
    // print("fetchVacanciesForListWithCache: Spheres: $sphereParam");

    // Формируем URL согласно предоставленному curl:
    // GET https://dev.mamakris.ru/api/jobs/random-unviewed-approved/{userId}?spheres={sphereParam}
    final url = Uri.parse(
      '${kBaseUrl}jobs/random-unviewed-approved/$userId?spheres=$sphereParam',
    );
    // print("fetchVacanciesForListWithCache: Requesting URL = $url");
    // print(
    //   "fetchVacanciesForListWithCache: accessToken = $accessToken, userId = $userId",
    // );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(
      //   "fetchVacanciesForListWithCache: Response statusCode = ${response.statusCode}",
      // );
      // print("fetchVacanciesForListWithCache: Response body = ${response.body}");

      if (response.statusCode == 200) {
        final vacancies = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        // print(
        //   "fetchVacanciesForListWithCache: Vacancies count from API = ${vacancies.length}",
        // );
        // Обновляем уменьшённый кэш с новыми данными
        final updatedCache = await updateCachedVacanciesReduced(vacancies);
        // print(
        //   "fetchVacanciesForListWithCache: Updated reduced cache length = ${updatedCache.length}",
        // );
        return updatedCache;
      } else if (response.statusCode == 401) {
        final refreshed = await funcs.refreshAccessToken();
        if (refreshed) return fetchVacanciesForListWithCache(page: page);
        return [];
      }
    } catch (e) {
      // print("fetchVacanciesForListWithCache: Exception occurred: $e");
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
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (accessToken == null || userId == null) {
      _lastErrorMessage = 'Отсутствует токен или ID пользователя';
      return false;
    }

    final url = Uri.parse('${kBaseUrl}viewed-jobs/$userId/$jobId');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'isLiked': isLiked});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 401) {
        debugPrint("sendReaction: Статус 401, пытаемся обновить токен");
        final refreshed = await funcs.refreshAccessToken();
        if (refreshed) {
          debugPrint("sendReaction: Токен успешно обновлён, повторяем запрос");
          return _sendReaction(jobId, isLiked);
        } else {
          _lastErrorMessage = 'Не удалось обновить токен';
          return false;
        }
      }

      if (response.statusCode != 200) {
        _lastErrorMessage = 'Ошибка: ${response.statusCode}';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map && responseBody.containsKey('message')) {
            _lastErrorMessage = responseBody['message'];
          }
        } catch (_) {
          // Игнорируем ошибку парсинга
        }
        return false;
      }

      _lastErrorMessage = null; // сбрасываем, если всё хорошо
      return true;
    } catch (e) {
      _lastErrorMessage = 'Сетевой сбой: $e';
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchVacancyById(int jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');

    if (accessToken == null) {
      // print("fetchVacancyById: auth_token is null");
      return null;
    }

    final url = Uri.parse('${kBaseUrl}jobs/$jobId');
    // print("fetchVacancyById: Requesting URL = $url");

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print("fetchVacancyById: Response statusCode = ${response.statusCode}");
      // print("fetchVacancyById: Response body = ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        // При необходимости можно реализовать логику обновления токена.
        final refreshed = await funcs.refreshAccessToken();
        if (refreshed) return fetchVacancyById(jobId);
      }
    } catch (e) {
      // print("fetchVacancyById: Exception occurred: $e");
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
