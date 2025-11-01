import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mama_kris/constants/api_constants.dart';

Future<bool> refreshAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  final response = await http.post(
    Uri.parse('${kBaseUrl}auth/refresh-token'),
    headers: {'Authorization': 'Bearer $refreshToken'},
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    final newAccessToken = data['accessToken'];

    if (newAccessToken != null) {
      await prefs.setString('auth_token', newAccessToken);
      return true;
    }
  } else {
    //     print(response.body);
  }

  return false;
}

Future<Map<String, dynamic>?> fetchContactDetails({
  required int userId,
  required int contactsId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('auth_token');

  if (accessToken == null) return null;

  final url = Uri.parse(
    'https://app.mamakris.ru/api/contacts/$userId/$contactsId',
  );

  final response = await http.get(
    url,
    headers: {'accept': '*/*', 'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 401) {
    final refreshed = await refreshAccessToken();
    if (!refreshed) return null;

    final newToken = prefs.getString('auth_token');
    final retryResponse = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $newToken'},
    );

    return retryResponse.statusCode == 200
        ? jsonDecode(retryResponse.body)
        : null;
  } else {
    return null;
  }
}

/// Функция обновления данных пользователя в кэше.
/// Записывает email, phone, choice и name, полученные из API.
/// При ошибке 401 пытается обновить токен и повторяет запрос.
Future<void> updateUserDataInCache(String accessToken, int userId) async {
  final prefs = await SharedPreferences.getInstance();

  Future<void> attemptUpdate(String token) async {
    final url = Uri.parse('${kBaseUrl}users/$userId');
    final headers = {'accept': '*/*', 'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      void safeSet(String key, dynamic value) {
        if (value != null && value is String && value.isNotEmpty) {
          prefs.setString(key, value);
        }
      }

      safeSet('email', data['email']);
      safeSet('phone', data['phone']);
      safeSet('name', data['name']);
      safeSet('choice', data['choice']);
    } else if (response.statusCode == 401) {
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        final newToken = prefs.getString('auth_token');
        if (newToken != null) {
          await attemptUpdate(newToken);
        }
      }
    }
    // Другие статусы — без обработки (можно расширить при необходимости)
  }

  await attemptUpdate(accessToken);
}

/// Обновляет выбранные сферы (selected spheres) на сервере,
/// считывая их из кэша SharedPreferences.
/// Возвращает true, если обновление прошло успешно, иначе false.
Future<bool> updateSelectedSpheres() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? savedSpheres = prefs.getStringList(
    'job_search_selected_spheres',
  );
  String? accessToken = prefs.getString('auth_token');
  String? userId = prefs.getInt('user_id')?.toString();

  // print("updateSelectedSpheres: savedSpheres = $savedSpheres");
  // print("updateSelectedSpheres: accessToken = $accessToken, userId = $userId");

  if (savedSpheres == null || accessToken == null || userId == null) {
    // print("updateSelectedSpheres: Отсутствуют необходимые данные в кэше");
    return false;
  }

  // Преобразуем сохранённые сферы в Set<int>
  final sphereIDs =
      savedSpheres.map((s) => int.tryParse(s)).whereType<int>().toSet();
  // print("updateSelectedSpheres: sphereIDs = $sphereIDs");

  try {
    final url = Uri.parse('${kBaseUrl}user-preferences/bulk/$userId');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'sphereIDs': sphereIDs.toList()});

    // print("updateSelectedSpheres: Отправка запроса на URL: $url");
    // print("updateSelectedSpheres: Headers: $headers");
    // print("updateSelectedSpheres: Body: $body");

    final response = await http.post(url, headers: headers, body: body);
    // print("updateSelectedSpheres: Ответ от сервера: ${response.statusCode}");
    // print("updateSelectedSpheres: Тело ответа: ${response.body}");

    if (response.statusCode == 401) {
      bool refreshed = await refreshAccessToken();
      // print("updateSelectedSpheres: token refreshed = $refreshed");
      if (refreshed) {
        // Получаем новый accessToken и повторяем запрос
        accessToken = (await SharedPreferences.getInstance()).getString(
          'auth_token',
        );
        if (accessToken != null) {
          headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await http.post(
            url,
            headers: headers,
            body: body,
          );
          return retryResponse.statusCode == 201;
        }
      }
      return false;
    }

    return response.statusCode == 201;
  } catch (e) {
    // print("updateSelectedSpheres error: $e");
    return false;
  }
}

/// Функция для получения и сохранения рекламного баннера.
/// При успешном ответе (200) сохраняет URL картинки.
/// Если ответ 404, удаляет сохранённый URL (или записывает null).
/// Если ответ 401 — обновляет токен и повторяет запрос.
Future<void> fetchAdvertisementBanner() async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');

  if (accessToken == null) {
    // print("fetchAdvertisementBanner: Нет accessToken в кэше");
    return;
  }

  final url = Uri.parse('${kBaseUrl}advertisements');
  final headers = {'accept': '*/*', 'Authorization': 'Bearer $accessToken'};

  // print("fetchAdvertisementBanner: Отправка запроса на $url");
  // print("fetchAdvertisementBanner: Заголовки = $headers");

  try {
    final response = await http.get(url, headers: headers);
    // print(
    //   "fetchAdvertisementBanner: Получен ответ, статус = ${response.statusCode}",
    // );
    // print("fetchAdvertisementBanner: Тело ответа = ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      String imageUrl = data['imageUrl']?.toString().trim() ?? '';
      String link = data['link']?.toString().trim() ?? '';
      await prefs.setString('adv_image_url', imageUrl);
      await prefs.setString('adv_link', link);
      // print(
      //   "fetchAdvertisementBanner: URL сохранён в кэше: $imageUrl, link: $link",
      // );
    } else if (response.statusCode == 404) {
      await prefs.remove('adv_image_url');
      await prefs.remove('adv_link');
      // print(
      //   "fetchAdvertisementBanner: Рекламный баннер не найден (404), кэш очищен",
      // );
    } else if (response.statusCode == 401) {
      bool refreshed = await refreshAccessToken();
      // print("fetchAdvertisementBanner: Токен обновлён? $refreshed");
      if (refreshed) {
        accessToken = (await SharedPreferences.getInstance()).getString(
          'auth_token',
        );
        if (accessToken != null) {
          headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await http.get(url, headers: headers);
          // print(
          //   "fetchAdvertisementBanner: Повторный запрос, статус = ${retryResponse.statusCode}",
          // );
          if (retryResponse.statusCode == 200) {
            final data =
                json.decode(retryResponse.body) as Map<String, dynamic>;
            String imageUrl = data['imageUrl']?.toString().trim() ?? '';
            String link = data['link']?.toString().trim() ?? '';
            await prefs.setString('adv_image_url', imageUrl);
            await prefs.setString('adv_link', link);
            // print(
            //   "fetchAdvertisementBanner: URL сохранён после обновления токена: $imageUrl, link: $link",
            // );
          } else if (retryResponse.statusCode == 404) {
            await prefs.remove('adv_image_url');
            await prefs.remove('adv_link');
            // print(
            //   "fetchAdvertisementBanner: Рекламный баннер не найден после обновления токена (404), кэш очищен",
            // );
          }
        }
      } else {
        // print("fetchAdvertisementBanner: Не удалось обновить токен");
      }
    } else {
      // print(
      //   "fetchAdvertisementBanner: Неожиданный статус ответа: ${response.statusCode}",
      // );
    }
  } catch (e) {
    // print("fetchAdvertisementBanner: Ошибка запроса: $e");
  }
}

bool checkSubscription() {
  return true;
}

Future<String> resolveDisplayName() async {
  final prefs = await SharedPreferences.getInstance();
  String? name = prefs.getString('name');
  // print("Имя: ${name}");
  // Если имя пустое или отсутствует — пробуем обновить из API
  if (name == null || name.trim().isEmpty) {
    final String? token = prefs.getString('auth_token');
    final int? userId = prefs.getInt('user_id');

    if (token != null && userId != null) {
      await updateUserDataInCache(token, userId);
      name = prefs.getString('name');
    }
  }

  // Если всё ещё пусто — fallback на username
  return name != null && name.trim().isNotEmpty
      ? name
      : (prefs.getString('email') ?? 'Пользователь');
}

Future<String> resolveEmail() async {
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null || email.trim().isEmpty) {
    final String? token = prefs.getString('auth_token');
    final int? userId = prefs.getInt('user_id');

    if (token != null && userId != null) {
      await updateUserDataInCache(token, userId);
      email = prefs.getString('email');
    }
  }

  return email ?? ''; // fallback на дефолтное значение
}

String? validateAndFormatPhone(String rawPhone, BuildContext context) {
  rawPhone = rawPhone.trim();

  // Убираем пробелы, тире, скобки и любые другие символы кроме цифр и плюса
  String cleaned = rawPhone.replaceAll(RegExp(r'[^\d\+]'), '');

  if (cleaned.isEmpty) return null;

  if (cleaned.startsWith('+')) {
    // Оставляем только цифры после +
    final digits = cleaned.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
    final formatted = '+$digits';

    if (formatted.length < 12 || formatted.length > 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Неверный формат номера: должен быть в формате +<код><номер>",
          ),
        ),
      );
      return null;
    }

    return formatted;
  } else {
    // Если без +, проверяем, что это российский номер, начинающийся с 8
    final digits = cleaned.replaceAll(RegExp(r'[^0-9]'), '');

    if (!digits.startsWith('8') || digits.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Неверный формат. Введите номер начиная с + или с 8"),
        ),
      );
      return null;
    }

    // Заменяем 8 на +7
    return '+7${digits.substring(1)}';
  }
}

Future<bool> hasSubscription() async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');
  int? userId = prefs.getInt('user_id');

  if (accessToken == null || userId == null) {
    //       print('Access token or user ID not found');
    return false;
  }

  final url = Uri.parse('https://app.mamakris.ru/payments/check');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId.toString()}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //         print(response.body);
      //         print(data['ok'] );
      return data['ok'] ?? false;
    } else if (response.statusCode == 401) {
      //         print('Token expired, attempting to refresh...');
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        //           print('Token refreshed successfully, retrying subscription check...');
        String? newAccessToken = prefs.getString('auth_token');
        if (newAccessToken != null) {
          return hasSubscription();
        } else {
          throw Exception('Failed to get new access token');
        }
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      //         print('Failed to check subscription. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    //       print('Error checking subscription: $e');
    return false;
  }
}

Future<bool> needsSubscription(String accessToken, int userId) async {
  final url = Uri.parse('${kBaseUrl}viewed-jobs/viewed-count/$userId');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      int viewedCount = int.parse(response.body);
      //       print('Viewed jobs count: $viewedCount');
      return viewedCount > 6 && !await hasSubscription();
    } else if (response.statusCode == 401) {
      //       print('Token expired, attempting to refresh...');
      if (await refreshAccessToken()) {
        final prefs = await SharedPreferences.getInstance();
        String? newAccessToken = prefs.getString('auth_token');
        return newAccessToken != null
            ? needsSubscription(newAccessToken, userId)
            : throw Exception('Failed to get new access token');
      }
      throw Exception('Failed to refresh token');
    } else {
      //       print('Failed to get viewed count. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    //     print('Error checking subscription need: $e');
    return false;
  }
}

Future<int> getLikedCount(String accessToken, int userId) async {
  final url = Uri.parse('${kBaseUrl}viewed-jobs/liked-ids/$userId');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData.length;
    } else if (response.statusCode == 401) {
      //       print('Token expired, attempting to refresh...');
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        // Получаем новый токен и повторяем запрос
        final prefs = await SharedPreferences.getInstance();
        String? newAccessToken = prefs.getString('auth_token');
        if (newAccessToken != null) {
          return getLikedCount(newAccessToken, userId);
        } else {
          return 0;
          // throw Exception('Failed to get new access token');
        }
      } else {
        return 0;
        // throw Exception('Failed to refresh token');
      }
    } else {
      return 0;
      // throw Exception('Failed to get liked count: ${response.statusCode}');
    }
  } catch (e) {
    //     print('Error getting liked count: $e');
    // throw Exception('Failed to get liked count');
    return 0;
  }
}

Future<int> getViewedCount(String accessToken, int userId) async {
  final url = Uri.parse('${kBaseUrl}viewed-jobs/viewed-count/$userId');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 401) {
      //       print('Token expired, attempting to refresh...');
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        // Получаем новый токен и повторяем запрос
        final prefs = await SharedPreferences.getInstance();
        String? newAccessToken = prefs.getString('auth_token');
        if (newAccessToken != null) {
          return getViewedCount(newAccessToken, userId);
        } else {
          return 0;
        }
      } else {
        return 0;
        // throw Exception('Failed to refresh token');
      }
    } else {
      return 0;
      // throw Exception('Failed to get viewed count: ${response.statusCode}');
    }
  } catch (e) {
    //     print('Error getting viewed count: $e');
    // throw Exception('Failed to get viewed count');
    return 0;
  }
}

//   Future<void> signOut(BuildContext context) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       int? userId = prefs.getInt('user_id');
//       String? accessToken = prefs.getString('auth_token');

//       if (userId != null && accessToken != null) {
//         await endSession(userId, accessToken); // Завершаем сессию
//       }

//       // Удаляем данные пользователя из SharedPreferences
//       await prefs.remove('auth_token');
//       await prefs.remove('refresh_token');
//       await prefs.remove('user_id');
//       await prefs.remove('user_email');
//       await prefs.remove('isLoggedIn');

//       // Перенаправляем пользователя на страницу входа
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => StartPage()),
//         (Route<dynamic> route) => false,
//       );
//     } catch (e) {
// //       print('Error during sign out: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка при выходе из аккаунта')),
//       );
//     }
//   }

Future<Map<String, String>> _fetchUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');
  int? userId = prefs.getInt('user_id');

  if (accessToken == null || userId == null) {
    return {};
  }

  try {
    final response = await http.get(
      Uri.parse('${kBaseUrl}users/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    // print("Ответ: ${response.body}");
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return {'email': userData['email'], 'phone': userData['phone']};
    } else if (response.statusCode == 401) {
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        return _fetchUserInfo();
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  } catch (e) {
    // print('Error fetching user info: $e');
    return {};
  }
}

Future<void> sendPostRequest(String type) async {
  final prefs = await SharedPreferences.getInstance();
  bool? inCrm = prefs.getBool('in_crm');
  if (!(inCrm ?? false)) {
    final userInfo = await _fetchUserInfo();
    if (userInfo.isEmpty) {
      // print('Error: User info is empty');
      return;
    }
    // print(userInfo['phone']);
    final url = Uri.parse('https://mamakris.sotka-api.ru/new_request');
    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = {
      'name': userInfo['email'],
      'phone': userInfo['phone'],
      'income_source': 'MobileApp',
      'income_source_id': 'acc07562-22a6-4776-9ced-4889ad6c3d6f',
      'funnel_id': '78c999ac-28d9-42b7-b4c9-d7e430b005ad',
      'stage': '1',
      'type': type,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('in_crm', true);
      }
    } catch (e) {
      //     print('Error sending request: $e');
    }
  }
}

//   Future<void> deleteUser(BuildContext context) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('auth_token');
//       int? userId = prefs.getInt('user_id');

//       if (accessToken == null || userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Отправляем DELETE запрос на сервер
//       final response = await http.delete(
//         Uri.parse('https://app.mamakris.ru/api/users/$userId'),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'accept': '*/*',
//         },
//       );

//       if (response.statusCode == 200) {
//         // Успешное удаление на сервере, теперь очищаем локальные данные
//         await prefs.clear(); // Очищаем все данные из SharedPreferences

//         // Перенаправляем пользователя на страницу входа или начальную страницу
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => StartPage()),
//           (Route<dynamic> route) => false,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Аккаунт успешно удален')),
//         );
//       } else if (response.statusCode == 401) {
//         // Токен истек, пробуем обновить
//         bool refreshed = await refreshAccessToken();
//         if (refreshed) {
//           // Повторяем попытку удаления
//           return deleteUser(context);
//         } else {
//           throw Exception('Failed to refresh token');
//         }
//       } else {
//         throw Exception('Failed to delete user: ${response.statusCode}');
//       }
//     } catch (e) {
// //       print('Error deleting user: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка при удалении аккаунта: $e')),
//       );
//     }
//   }

Future<void> startSession(int userId, String accessToken) async {
  final prefs = await SharedPreferences.getInstance();
  final url = Uri.parse('${kBaseUrl}session-times/user/$userId');

  try {
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userID': userId,
        'startTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'endTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final sessionData = jsonDecode(response.body);
      await prefs.setInt('sessionID', sessionData['sessionID']);
    } else if (response.statusCode == 401) {
      //       print('Token expired, attempting to refresh...');
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        // Получаем новый токен и повторяем запрос
        String? newAccessToken = prefs.getString('auth_token');
        if (newAccessToken != null) {
          return startSession(userId, newAccessToken);
        } else {
          throw Exception('Failed to get new access token');
        }
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('Failed to start session: ${response.statusCode}');
    }
  } catch (e) {
    //     print('Error starting session: $e');
    throw Exception('Failed to start session');
  }
}

Future<void> endSession(int userId, String accessToken) async {
  final prefs = await SharedPreferences.getInstance();
  int? sessionId = prefs.getInt('sessionID');

  if (sessionId == null) {
    //     print('No active session');
    return;
  }

  final url = Uri.parse(
    '${kBaseUrl}session-times/user/$userId/session/$sessionId',
  );

  try {
    final response = await http.put(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'endTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.remove('sessionID');
      //       print('Session ended successfully');
    } else if (response.statusCode == 401) {
      //       print('Token expired, attempting to refresh...');
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        String? newAccessToken = prefs.getString('auth_token');
        if (newAccessToken != null) {
          return endSession(userId, newAccessToken);
        } else {
          throw Exception('Failed to get new access token');
        }
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('Failed to end session: ${response.statusCode}');
    }
  } catch (e) {
    //     print('Error ending session: $e');
    throw Exception('Failed to end session');
  }
}

Future<void> checkPaymentAndMoveRequest() async {
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');
  if (userId == null) {
    // print('Error: User ID is missing');
    return;
  }

  final userInfo = await _fetchUserInfo();
  if (userInfo.isEmpty) {
    // print('Error: User info is empty or phone is missing');
    return;
  }

  final phoneNumber = userInfo['phone'];

  // Первый запрос: проверка оплаты
  final url = Uri.parse('https://app.mamakris.ru/payments/check');
  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  final body = {'user_id': userId.toString()};

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['ok']) {
        // Второй запрос: перемещение запроса
        final moveUrl = Uri.parse('https://mamakris.sotka-api.ru/move_request');
        final moveHeaders = {
          'Access-Control-Allow-Origin': '*',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        };
        final moveBody = {
          'phone': phoneNumber,
          'funnel_id': '78c999ac-28d9-42b7-b4c9-d7e430b005ad',
          'stage': getStage(jsonData['type']),
        };
        // print('Отправляемый запрос:');
        // print('URL: $moveUrl');
        // print('Headers: $moveHeaders');
        // print('Body: $moveBody');

        //             print(phoneNumber);
        //             print( getStage(jsonData['type']));
        try {
          // final moveResponse =
          await http.post(
            moveUrl,
            headers: moveHeaders,
            body: jsonEncode(moveBody),
          );

          // print(moveResponse.body);
        } catch (e) {
          // print('Error moving request: $e');
        }
      } else {
        // print('Error: Payment not found');
      }
    } else {
      // print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error checking payment: $e');
  }
}

String getStage(String type) {
  switch (type) {
    case 'month':
      return '4';
    case 'half':
      return '5';
    case 'year':
      return '6';
    default:
      return '8';
  }
}

/// Обновление поля invest (инвестиции), устанавливая его в true.
/// Телефон и имя передаются как аргументы.
Future<Map<String, dynamic>?> updateInvestStatus({
  required String phone,
  required String name,
}) async {
  const url = 'https://mamakris.sotka-api.ru/update_request';
  final body = {"phone": phone, "name": name, "invest": true};

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json", "accept": "*/*"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    // print(
    //   "Error updating invest status: ${response.statusCode} ${response.body}",
    // );
    return null;
  }
}

/// Обновляет поле kar_kons (карьерная консультация) – устанавливается всегда в true.
Future<Map<String, dynamic>?> updateKarKonsStatusFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  String? phone = prefs.getString('phone');
  String? name = prefs.getString('name');
  if (phone == null || phone.isEmpty) {
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    if (token != null && userId != null) {
      await updateUserDataInCache(token, userId);
    }
    phone = prefs.getString('phone');
    name = prefs.getString('name');
    if (phone == null || phone.isEmpty) {
      // print("updateKarKonsStatusFromCache: Phone is not available in cache.");
      return null;
    }
  }

  const url = 'https://mamakris.sotka-api.ru/update_request';
  final body = {"phone": phone, "name": name ?? "", "kar_kons": true};

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json", "accept": "*/*"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    // print(
    //   "updateKarKonsStatusFromCache: Error updating kar_kons status: ${response.statusCode} ${response.body}",
    // );
    return null;
  }
}

/// Обновляет поле psy_kons (психологическая поддержка) – устанавливается всегда в true.
Future<Map<String, dynamic>?> updatePsyKonsStatusFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  String? phone = prefs.getString('phone');
  String? name = prefs.getString('name');
  if (phone == null || phone.isEmpty) {
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    if (token != null && userId != null) {
      await updateUserDataInCache(token, userId);
    }
    phone = prefs.getString('phone');
    name = prefs.getString('name');
    if (phone == null || phone.isEmpty) {
      // print("updatePsyKonsStatusFromCache: Phone is not available in cache.");
      return null;
    }
  }

  const url = 'https://mamakris.sotka-api.ru/update_request';
  final body = {"phone": phone, "name": name ?? "", "psy_kons": true};

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json", "accept": "*/*"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    // print(
    //   "updatePsyKonsStatusFromCache: Error updating psy_kons status: ${response.statusCode} ${response.body}",
    // );
    return null;
  }
}

/// Обновление поля ads (реклама на баннере), устанавливая его в true.
Future<Map<String, dynamic>?> updateAdsStatus({
  required String phone,
  required String name,
}) async {
  const url = 'https://mamakris.sotka-api.ru/update_request';
  final body = {"phone": phone, "name": name, "ads": true};

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json", "accept": "*/*"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    // print("Error updating ads status: ${response.statusCode} ${response.body}");
    return null;
  }
}

Future<String?> generatePaymentLink({
  required String tariffType,
  required bool demoMode,
  required int jobId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('auth_token');
  final int? userId = prefs.getInt('user_id');

  if (accessToken == null || userId == null) {
    // print("Ошибка: отсутствует accessToken или userId");
    return null;
  }

  final Uri url = Uri.parse('$kBaseUrl/payments.v2/generate-link/$userId');
  final String body = jsonEncode({
    "TariffType": tariffType,
    "demoMode": demoMode,
    "jobId": jobId,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Если получен статус 401, обновляем токен и повторяем запрос
    if (response.statusCode == 401) {
      // print("Получен статус 401. Попытка обновления токена...");
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        // Обновляем токен и повторяем запрос
        accessToken = prefs.getString('auth_token');
        if (accessToken != null) {
          return generatePaymentLink(
            tariffType: tariffType,
            demoMode: demoMode,
            jobId: jobId,
          );
        }
      }
      // print("Не удалось обновить токен.");
      return null;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String paymentLink = response.body.trim();
      // print("Сгенерированная ссылка: $paymentLink");
      return paymentLink;
    } else {
      // print(
      //   "Ошибка генерации ссылки. Код: ${response.statusCode}, тело: ${response.body}",
      // );
      return null;
    }
  } catch (e) {
    // print("Ошибка при выполнении запроса: $e");
    return null;
  }
}

Future<bool> updateUserInfo({
  required String name,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('auth_token');
  final userId = prefs.getInt('user_id');

  if (accessToken == null || userId == null) {
    // print("❌ Нет accessToken или userId");
    return false;
  }

  final url =
      Uri.parse('https://dev.mamakris.ru/api/users/$userId/update-info');
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "name": name,
  });

  // print("📤 Отправка PUT запроса на обновление имени:");
  // print("➡️ URL: $url");
  // print("➡️ Body: $body");

  final response = await http.put(url, headers: headers, body: body);
  // print("📥 Ответ: ${response.statusCode}");
  // print("📦 Тело ответа: ${response.body}");

  if (response.statusCode == 401) {
    // print("🔒 Токен истёк, пытаемся обновить...");
    final refreshed = await refreshAccessToken();
    if (refreshed) {
      return await updateUserInfo(name: name);
    } else {
      // print("❌ Не удалось обновить токен");
      return false;
    }
  }

  return response.statusCode == 200;
}
