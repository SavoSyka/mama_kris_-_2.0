// lib/login_logic.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/screens/application_screen.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/constants/api_constants.dart';

/// Возвращает следующий экран в зависимости от значения current_page, сохранённого в кэше.
/// Если current_page отсутствует, по умолчанию возвращается MainScreen.
Future<Widget> determineNextPage(
  
  String accessToken,
  int userId,
  double scaleX,
  double scaleY,
) async {
  final prefs = await SharedPreferences.getInstance();
  // Извлекаем currentPage из кэша, если отсутствует — по умолчанию 'job'
  String? currentPage = prefs.getString('current_page');
  switch (currentPage) {
    case 'search':
      return const ApplicationScreen();
    case 'job':
      return const MainScreen();
    case 'tinder':
      return const MainScreen();
    default:
      return const MainScreen();
  }
}

/// Показывает ошибку через SnackBar.
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Функция, выполняющая авторизацию:
/// – Отправляет запрос на сервер;
/// – Сохраняет полученные данные в SharedPreferences;
/// – Запускает сессию и сохраняет дополнительные параметры.
///
/// Если current_page равен 'choice' или отсутствует, функция возвращает false,
/// чтобы UI знал, что нужно закрыть окно и показать панель выбора ролей.
/// Иначе происходит навигация на следующий экран, а функция возвращает true.
Future<bool> loginAndContinue({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) async {
  try {
    final url = Uri.parse('${kBaseUrl}auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      final userId = data['userId'];

      if (accessToken != null && refreshToken != null && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setInt('user_id', userId);
        await prefs.setBool('isLogged', true);
        funcs.updateUserDataInCache(accessToken, userId);

        // // Сохраняем email, номер телефона и имя пользователя
        // await prefs.setString('email', data['email'] ?? '');
        // await prefs.setString('phone', data['phone'] ?? '');
        // await prefs.setString('name', data['name'] ?? '');

        // Начинаем сессию
        await funcs.startSession(userId, accessToken);

        bool hasSubscription = await funcs.hasSubscription();
        await prefs.setBool('has_subscription', hasSubscription);

        int viewedCount = await funcs.getViewedCount(accessToken, userId);
        await prefs.setInt('viewed_count', viewedCount);

        int likedCount = await funcs.getLikedCount(accessToken, userId);
        await prefs.setInt('liked_count', likedCount);

        // Определяем, какой следующий экран показать
        String? currentPage = prefs.getString('current_page');
        // print(currentPage);
        if (currentPage == 'choice' || currentPage == null) {
          // Указываем, что нужно закрыть текущее окно и показать панель выбора ролей.
          return false;
        } else {
          double scaleX = MediaQuery.of(context).size.width / 428;
          double scaleY = MediaQuery.of(context).size.height / 956;
          Widget nextPage = await determineNextPage(
            accessToken,
            userId,
            scaleX,
            scaleY,
          );
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, animation, secondaryAnimation) => nextPage,
              transitionsBuilder: (_, animation, __, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
            (route) => false,
          );
          return true;
        }
      } else {
        showErrorSnackBar(context, 'Ошибка входа: токены отсутствуют');
      }
    } else {
      showErrorSnackBar(
        context,
        'Неправильный логин или пароль. Попробуйте ещё раз или сбросьте пароль.',
      );
    }
  } catch (e) {
    showErrorSnackBar(
      context,
      'Непредвиденная ошибка. Пожалуйста, попробуйте ещё раз.',
    );
  }
  return true;
}
