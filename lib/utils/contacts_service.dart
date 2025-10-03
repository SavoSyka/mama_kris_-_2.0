import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/funcs.dart';

class ContactsService {
  static Future<Map<String, dynamic>?> fetchContacts(int contactsId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (accessToken == null || userId == null) return null;

    final url = Uri.parse(
      'https://app.mamakris.ru/api/contacts/$userId/$contactsId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        final refreshed = await refreshAccessToken();
        if (refreshed) return fetchContacts(contactsId);
      }
    } catch (e) {
      // print('[ERROR] Fetching contacts: $e');
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchAllContactsForUser() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (accessToken == null || userId == null) return [];

    final url = Uri.parse(
      'https://app.mamakris.ru/api/contacts/$userId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else if (response.statusCode == 401) {
        final refreshed = await refreshAccessToken();
        if (refreshed) return fetchAllContactsForUser();
      }
    } catch (e) {
      // print('[ERROR] Fetching all contacts for user: $e');
    }

    return [];
  }
}
