import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/constants/api_constants.dart';

class JobService {
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<int?> createOrUpdateContact({
    required Map<String, dynamic> newContactData,
    Map<String, dynamic>? oldContactData,
    Function(int)? onNewContactCreatedBeforeDeletingOld,
  }) async {
    // final prefs = await SharedPreferences.getInstance();
    final token = await _getAccessToken();
    final userId = await _getUserId();
    if (token == null || userId == null) return null;

    final bool hasChanged = oldContactData == null ||
        jsonEncode(_cleanContactMap(newContactData)) !=
            jsonEncode(_cleanContactMap(oldContactData));

    if (!hasChanged) {
      // print(
      //   "🔄 Контакт не изменён. Используем существующий: ${oldContactData['contactsID']}",
      // );
      return oldContactData['contactsID'];
    }

    // print("🟢 СОЗДАНИЕ нового контакта");
    // print("➡️ URL: ${kBaseUrl}contacts/$userId");
    // print("➡️ Headers: Authorization: Bearer $token");
    // print("➡️ Body: ${jsonEncode(newContactData)}");

    final createResponse = await http.post(
      Uri.parse('${kBaseUrl}contacts/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newContactData),
    );

    if (createResponse.statusCode == 401) {
      final refreshed = await funcs.refreshAccessToken();
      if (refreshed) {
        return createOrUpdateContact(
          newContactData: newContactData,
          oldContactData: oldContactData,
          onNewContactCreatedBeforeDeletingOld:
              onNewContactCreatedBeforeDeletingOld,
        );
      }
    }

    // print("📥 Ответ: ${createResponse.statusCode}");
    // print("📦 Тело ответа: ${createResponse.body}");

    if (createResponse.statusCode == 201) {
      final decoded = jsonDecode(createResponse.body);
      final newContactId = decoded['contactsID'];

      // Сообщаем наружу, что можно обновлять вакансию до удаления старого
      if (onNewContactCreatedBeforeDeletingOld != null) {
        onNewContactCreatedBeforeDeletingOld(newContactId);
      }

      return newContactId;
    }

    return null;
  }

  static Future<bool> deleteContact(int contactId) async {
    final token = await _getAccessToken();
    final userId = await _getUserId();
    if (token == null || userId == null) return false;

    // print("🗑 Удаляем контакт ID: $contactId");

    final response = await http.delete(
      Uri.parse('${kBaseUrl}contacts/$userId/$contactId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 401) {
      final refreshed = await funcs.refreshAccessToken();
      if (refreshed) return deleteContact(contactId);
    }

    // print("📥 Ответ (удаление контакта): 
    // ${response.statusCode}");
    
    return response.statusCode == 200;
  }

  /// Функция создания или обновления вакансии.
  /// Теперь возвращает декодированный JSON-ответ от сервера (с полями jobID, status и т.д.)
  static Future<Map<String, dynamic>?> createOrUpdateJob({
    required Map<String, dynamic> jobData,
    int? jobId,
  }) async {
    final token = await _getAccessToken();
    final userId = await _getUserId();
    if (token == null || userId == null) return null;

    final uri = jobId == null
        ? Uri.parse('${kBaseUrl}jobs/user/$userId')
        : Uri.parse('${kBaseUrl}jobs/user/$userId/job/$jobId');

    final method = jobId == null ? http.post : http.put;

    if (jobId == null) {
      // print("🟢 СОЗДАНИЕ вакансии");
    } else {
      // print("🔁 ОБНОВЛЕНИЕ вакансии (ID: $jobId)");
    }
    // print("➡️ URL: $uri");
    // print("➡️ Headers: Authorization: Bearer $token");
    // print("➡️ Body: ${jsonEncode(jobData)}");

    final response = await method(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jobData),
    );

    if (response.statusCode == 401) {
      final refreshed = await funcs.refreshAccessToken();
      if (refreshed) return createOrUpdateJob(jobData: jobData, jobId: jobId);
    }

    // print("📥 Ответ: ${response.statusCode}");
    // print("📦 Тело ответа: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Возвращаем полный JSON-ответ, включающий jobID, status и другие поля
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<bool> setJobSpheres(int jobId, List<int> sphereIDs) async {
    final token = await _getAccessToken();
    final userId = await _getUserId();
    if (token == null || userId == null) return false;

    final url = Uri.parse('${kBaseUrl}job-spheres/$userId/$jobId/spheres');

    // print("🔗 Привязка сфер к вакансии $jobId");
    // print("➡️ URL: $url");
    // print("➡️ Body: ${jsonEncode({'sphereIDs': sphereIDs})}");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'sphereIDs': sphereIDs}),
    );

    if (response.statusCode == 401) {
      final refreshed = await funcs.refreshAccessToken();
      if (refreshed) return setJobSpheres(jobId, sphereIDs);
    }

    // print("📥 Ответ (job-spheres): ${response.statusCode}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Map<String, dynamic> _cleanContactMap(Map<String, dynamic> map) {
    return Map.from(map)
      ..removeWhere(
        (key, value) => value == null || value.toString().trim().isEmpty,
      );
  }
}
