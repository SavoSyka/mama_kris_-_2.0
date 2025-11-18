import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/utils/login_logic.dart' as lgn;
import 'package:mama_kris/screens/login_sheet.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'dart:io' show Platform;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart'; // для kDebugMode
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


Future<void> signInWithApple(BuildContext context) async {
  try {
    if (kDebugMode) print('🍏 [Apple Sign-In] Запуск процесса входа через Apple...');

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (kDebugMode) {
      print('✅ [Apple Sign-In] Получены данные от Apple ID');
      print('🔑 Identity Token: ${credential.identityToken}');

      print('📧 Email: ${credential.email}');
      print('👤 Имя: ${credential.givenName}');
      print('👥 Фамилия: ${credential.familyName}');

    }
    final name = credential.givenName;
    final surname = credential.familyName;
    final identityToken = credential.identityToken;
    if (kDebugMode) {
      final parts = identityToken?.split('.');
      final payload = base64Url.normalize(parts![1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      print('🔍 Apple Token Payload: $decoded');
    }

    if (identityToken == null) {
      if (kDebugMode) print('❌ [Apple Sign-In] Не удалось получить identityToken');
      lgn.showErrorSnackBar(context, '❗ Не удалось получить Apple Identity Token');
      return;
    }

    final url = Uri.parse('${kBaseUrl}auth/apple/login');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    String body;
    if (name!=null || surname!=null){
     body = jsonEncode({
      'identityToken': identityToken,
      "userData": {"firstName": name,
        "lastName": surname},
    });
    }
    else if (name!=null){
       body = jsonEncode({
        'identityToken': identityToken,
         "userData": {"firstName": name,
           "lastName": ""},
      });
    }
    else if (surname!=null){
       body = jsonEncode({
        'identityToken': identityToken,
         "userData": {"firstName": "",
           "lastName": surname},
      });
    }
    else{
       body = jsonEncode({
        'identityToken': identityToken,
         "userData": {},
      });
    }

    if (kDebugMode) print('📡 [Apple Sign-In] Отправка запроса на бэкенд → $url');
    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print('📬 [Apple Sign-In] Ответ от сервера: ${response.statusCode}');
      print('📦 Тело ответа: ${response.body}');
    }

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      final userId = data['userID'];

      if (accessToken != null && refreshToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setInt('user_id', userId);
        await prefs.setBool('isLogged', true);

        final fullName = credential.givenName ?? '';
        if (fullName.isNotEmpty) {
          await prefs.setString('name', fullName);
          await funcs.updateUserInfo(name: fullName);
          if (kDebugMode) print('📛 Имя пользователя сохранено: $fullName');
        }

        final email = credential.email ?? '';
        if (email.isNotEmpty) {
          await prefs.setString('email', email);
          if (kDebugMode) print('📧 Email сохранён: $email');
        }

        final viewedCount = await funcs.getViewedCount(accessToken, userId);
        final likedCount = await funcs.getLikedCount(accessToken, userId);
        await prefs.setInt('viewed_count', viewedCount);
        await prefs.setInt('liked_count', likedCount);

        if (kDebugMode) print('📊 Просмотров: $viewedCount, Лайков: $likedCount');

        final String? currentPage = prefs.getString('current_page');
        if (currentPage == 'choice' || currentPage == null) {
          if (kDebugMode) print('➡️ Переход к выбору роли');
          showRoleSelectionPanel(context);
        } else {
          if (kDebugMode) print('➡️ Переход на следующую страницу...');
          double scaleX = MediaQuery.of(context).size.width / 428;
          double scaleY = MediaQuery.of(context).size.height / 956;
          Widget nextPage =
          await lgn.determineNextPage(accessToken, userId, scaleX, scaleY);

          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, animation, __) => nextPage,
              transitionsBuilder: (_, animation, __, child) {
                final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(position: animation.drive(tween), child: child);
              },
            ),
                (route) => false,
          );
        }
      } else {
        if (kDebugMode) print('❌ Токены отсутствуют в ответе от сервера');
        lgn.showErrorSnackBar(context, '❗ Ошибка входа: токены отсутствуют');
      }
    } else {
      if (kDebugMode) print('❌ Ошибка входа: статус ответа ${response.statusCode}');
      lgn.showErrorSnackBar(context, '❗ Ошибка входа через Apple');
    }
  } catch (e, stacktrace) {
    if (kDebugMode) {
      print('🛑 Исключение при входе через Apple: $e');
      print('🔍 Stacktrace: $stacktrace');
    }
    lgn.showErrorSnackBar(context, 'Ошибка входа через Apple. Попробуйте ещё раз.');
  }
}


final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['openid', 'email', 'profile'],
  serverClientId:
      // '86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com',
  '86099763542-9tgb2dqc63hj0utf8fc9mvve0fplc8e1.apps.googleusercontent.com',
);

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // print('🔐 [Google Sign-In] Старт входа');

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
   
    if (googleUser == null) {
      // print('❌ [Google Sign-In] Пользователь отменил вход');
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final String? idToken = googleAuth.idToken;
    if (idToken == null) {
      // print('❗ [Google Sign-In] Не удалось получить ID токен');
      return;
    }

    // print('👤 Пользователь: ${googleUser.displayName} (${googleUser.email})');
    // print('🔑 ID Token: ${idToken.substring(0, 30)}...');

    // Запрос на бэкенд
    final url = Uri.parse('${kBaseUrl}auth/google/login');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'provider': 'ios',
    };
    final body = jsonEncode({'idToken': idToken});

    final response = await http.post(url, headers: headers, body: body);

    // print('📡 [Бэкенд] POST ${url.path} → Статус: ${response.statusCode}');
    // print('📦 Ответ: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      final userId = data['userId'];

      if (accessToken != null && refreshToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setInt('user_id', userId);
        await prefs.setBool('isLogged', true);
        if (googleUser.displayName != null) {
          final name = googleUser.displayName!;
          await prefs.setString('name', name);
          await funcs.updateUserInfo(name: name);
          // print('📛 Имя пользователя сохранено: ${googleUser.displayName}');
        }

        await prefs.setString('email', googleUser.email);

        final viewedCount = await funcs.getViewedCount(accessToken, userId);
        final likedCount = await funcs.getLikedCount(accessToken, userId);
        await prefs.setInt('viewed_count', viewedCount);
        await prefs.setInt('liked_count', likedCount);

        // print(
        //     '✅ Успешный вход. UserID: $userId, Лайков: $likedCount, Просмотров: $viewedCount');

        final String? currentPage = prefs.getString('current_page');
        if (currentPage == 'choice' || currentPage == null) {
          showRoleSelectionPanel(context);
        } else {
          double scaleX = MediaQuery.of(context).size.width / 428;
          double scaleY = MediaQuery.of(context).size.height / 956;
          Widget nextPage =
              await lgn.determineNextPage(accessToken, userId, scaleX, scaleY);

          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, animation, __) => nextPage,
              transitionsBuilder: (_, animation, __, child) {
                final tween =
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                    position: animation.drive(tween), child: child);
              },
            ),
            (route) => false,
          );
        }
      } else {
        lgn.showErrorSnackBar(context, '❗ Ошибка входа: токены отсутствуют');
      }
    } else {
      lgn.showErrorSnackBar(context, '❗ Ошибка входа через Google');
    }
  } catch (e) {
    // print('🛑 Ошибка входа через Google: $e');
    // print('🔍 Stacktrace: $stacktrace');
    lgn.showErrorSnackBar(context, 'Ошибка. Попробуйте ещё раз.');
  }
}

Widget buildSocialButtons({
  required double top,
  required double scaleX,
  required double scaleY,
  required VoidCallback onGooglePressed,
  required VoidCallback onApplePressed,
  required BuildContext context,
}) {
  if (Platform.isIOS) {
    return Stack(
      children: [
        // Google
        Positioned(
          top: top * scaleY,
          left: 144 * scaleX,
          child: _circleButton(
            asset: 'assets/welcome_screen/google.svg',
            onPressed: onGooglePressed,
            scaleX: scaleX,
            scaleY: scaleY,
            backgroundColor: Colors.transparent,
          ),
        ),
        // Apple
        Positioned(
          top: top * scaleY,
          left: 234 * scaleX,
          child: SizedBox(
            width: 50 * scaleX,
            height: 50 * scaleY,
            child: ElevatedButton(
              onPressed: onApplePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero, // убираем внутренние отступы
                elevation: 0,
              ),
              child: Center(
                child: Icon(
                  Icons.apple,
                  color: Colors.white,
                  size: 36 * scaleX,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  } else if (Platform.isAndroid) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: top * scaleY),
        child: _circleButton(
          asset: 'assets/welcome_screen/google.svg',
          onPressed: onGooglePressed,
          scaleX: scaleX,
          scaleY: scaleY,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  } else {
    return const SizedBox.shrink(); // Ничего, если не iOS/Android
  }
}

// Вспомогательный виджет
Widget _circleButton({
  required String asset,
  required VoidCallback onPressed,
  required double scaleX,
  required double scaleY,
  required Color backgroundColor,
}) {
  return SizedBox(
    width: 50 * scaleX,
    height: 50 * scaleY,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.zero,
        elevation: 0,
      ),
      child: SvgPicture.asset(
        asset,
        width: 50 * scaleX,
        height: 50 * scaleY,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
      ),
    ),
  );
}


// 👉 Функция для обработки нажатия кнопки Google
void onGooglePressed(context) {
  signInWithGoogle(context);
  // print("Google нажат");
  // TODO: Добавить логику авторизации через Google
}

// 👉 Функция для обработки нажатия кнопки Apple
void onApplePressed(context) {
  signInWithApple(context);
  print("Apple нажат");
  // TODO: Добавить логику авторизации через Apple
}
