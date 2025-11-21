import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // ← Add this package

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // для kDebugMode
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mama_kris/utils/login_logic.dart' as lgn;

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

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
  // ==================== GOOGLE SIGN-IN ====================

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['openid', 'email', 'profile'],
    serverClientId:
        "86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com",
    // '86099763542-9tgb2dqc63hj0utf8fc9mvve0fplc8e1.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('❌ [Google Sign-In] Пользователь отменил вход');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        debugPrint('❗ [Google Sign-In] Не удалось получить ID токен');
        return null;
      }

      return {'idToken': idToken};

      /*
      // print('👤 Пользователь: ${googleUser.displayName} (${googleUser.email})');
      // print('🔑 ID Token: ${idToken.substring(0, 30)}...');

      // Запрос на бэкенд
      final url = Uri.parse('${kBaseUrl}auth/google/login');
      final headers = {
        'Content-Type': 'application/json',
      
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
            Widget nextPage = await lgn.determineNextPage(
              accessToken,
              userId,
              scaleX,
              scaleY,
            );

            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, animation, __) => nextPage,
                transitionsBuilder: (_, animation, __, child) {
                  final tween = Tween(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
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

      */
    } catch (e) {
      print('🛑 Ошибка входа через Google: $e');
      print('🔍 Stacktrace: ');
      // lgn.showErrorSnackBar(context, 'Ошибка. Попробуйте ещё раз.');
    }
    return null;
  }

  /*
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['openid', 'email', 'profile'],
    serverClientId:
        "86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com",
  );



  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        debugPrint("❌ Google Sign-In ERROR: idToken is null");
        return null;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;

      return {
        "firebaseUser": user,
        "googleIdToken": idToken,
        "googleAccessToken": accessToken,
        "email": googleUser.email,
        "name": googleUser.displayName,
        "photoUrl": googleUser.photoUrl,
      };
    } catch (e) {
      debugPrint("⛔ Google Sign-In Error: $e");
      return null;
    }
  }
*/

  String _generateSecureNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  // final UserProfileService _userProfileService = UserProfileService();

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final String rawNonce = _generateSecureNonce();
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: _sha256ofString(rawNonce),
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.mama.kris",
          redirectUri: Uri.parse(
            "https://mamakris-0.firebaseapp.com/__/auth/handler",
          ),
        ),
      );

      if (appleCredential.identityToken == null) {
        debugPrint("❌❌❌ errro hapend here in appleCredential.identityToken ");
      }

      final oauthCredential = firebase_auth.OAuthProvider('apple.com')
          .credential(
            idToken: appleCredential.identityToken!,
            rawNonce: rawNonce,
            accessToken: appleCredential.authorizationCode,
          );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final displayName =
            appleCredential.givenName != null &&
                appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : appleCredential.givenName ?? appleCredential.familyName;

        if (displayName != null && userCredential.user != null) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }
      }

      // Ensure user profile exists in Firestore
      if (userCredential.user != null) {
        // await _userProfileService.ensureUserProfileExists(
        //   userId: userCredential.user!.uid,
        // );
      }

      // return Right(
      //   userCredential.user == null
      //       ? domain.User.empty
      //       : UserModel.fromFirebase(userCredential.user!),
      // );

      return {'identityToken': appleCredential.identityToken};
    } on SignInWithAppleAuthorizationException catch (e) {
      String errorMessage;
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          errorMessage = 'El inicio de sesión con Apple fue cancelado.';
          break;
        case AuthorizationErrorCode.failed:
          errorMessage =
              'Error al iniciar sesión con Apple. Inténtalo de nuevo.';
          break;
        case AuthorizationErrorCode.invalidResponse:
          errorMessage =
              'Respuesta inválida de Apple. Por favor, inténtalo de nuevo.';
          break;
        case AuthorizationErrorCode.notHandled:
          errorMessage =
              'El inicio de sesión con Apple no está disponible. Contacta soporte.';
          break;
        case AuthorizationErrorCode.unknown:
          errorMessage =
              'Error desconocido al iniciar sesión con Apple. Inténtalo de nuevo.';
          break;
        default:
          errorMessage = e.message ?? 'Error al iniciar sesión con Apple.';
      }

      return null;
      // Left(AuthFailure(message: errorMessage));
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'Ya existe una cuenta con este correo electrónico pero con un método de inicio de sesión diferente. Por favor, inicia sesión con tu método original (correo y contraseña) o contacta soporte para vincular las cuentas.';
          break;
        case 'invalid-credential':
          errorMessage =
              'Las credenciales de Apple no son válidas. Inténtalo de nuevo.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'El inicio de sesión con Apple no está habilitado. Contacta soporte.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada. Contacta soporte.';
          break;
        case 'user-not-found':
          errorMessage =
              'No se encontró ningún usuario con estas credenciales.';
          break;
        case 'too-many-requests':
          errorMessage = 'Demasiados intentos fallidos. Inténtalo más tarde.';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión. Verifica tu conexión a Internet.';
          break;
        default:
          errorMessage = e.message ?? 'Error al iniciar sesión con Apple.';
      }

      return null;
      //  Left(
      //   AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
      // );
    } catch (e) {
      debugPrint("error $e");
      return null;
      // return Left(
      //   AuthFailure(
      //     message:
      //         'Error inesperado al iniciar sesión con Apple: ${e.toString()}',
      //   ),
      // );
    }
  }

  // * uncommen it when it is failed.
  /*
  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      if (kDebugMode)
        print('🍏 [Apple Sign-In] Запуск процесса входа через Apple...');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (kDebugMode) {
        print('✅ [Apple Sign-In] Получены данные от Apple ID');
        print('🔑 Identity Token: ${credential.identityToken}');
        print(
          '📧 Email: ${credential.email ?? 'не предоставлен (первый вход)'}',
        );
        print('👤 Имя: ${credential.givenName ?? 'не предоставлено'}');
        print('👥 Фамилия: ${credential.familyName ?? 'не предоставлено'}');
      }

      // Декодируем payload из identityToken (для отладки и понимания, что внутри)
      if (credential.identityToken != null) {
        final parts = credential.identityToken!.split('.');
        if (parts.length == 3) {
          final payload = base64Url.normalize(parts[1]);
          final decoded = utf8.decode(base64Url.decode(payload));
          if (kDebugMode) print('🔍 Apple Token Payload: $decoded');
        }
      } else {
        if (kDebugMode) print('❌ [Apple Sign-In] identityToken == null');
        // lgn.showErrorSnackBar(context, 'Не удалось получить Apple Identity Token');
        return null;
      }

      // Формируем результат
      final result = {
        'identityToken': credential.identityToken,

        "userData": {
          'email': credential.email,
          'firstName': credential.givenName,
          'lastName': credential.familyName,
          'authorizationCode': credential.authorizationCode, // иногда нужен
          'userIdentifier':
              credential.userIdentifier, // Apple User ID (стабильный)
        },
      };

      if (kDebugMode) {
        print('🎉 Успешно получены данные от Apple!');
        print('Результат: $result');
      }

      // Возвращаем данные — НИКАКИХ HTTP-запросов!
      return result;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('🛑 Ошибка при входе через Apple: $e');
        print('Stacktrace: $stacktrace');
      }
      // lgn.showErrorSnackBar(context, 'Ошибка входа через Apple. Попробуйте ещё раз.');
      return null;
    }
  }
*/
  /*
xiqoo dhiyoo
  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      if (kDebugMode)
        print('🍏 [Apple Sign-In] Запуск процесса входа через Apple...');

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
        if (kDebugMode)
          print('❌ [Apple Sign-In] Не удалось получить identityToken');
        return null;
      }
    } catch (e, stack) {
      debugPrint("🛑 Apple Sign-In Error → $e");
      debugPrint("STACK → $stack");
      return null;
    }
    return null;
  }

  old one 
  // ==================== APPLE SIGN-IN ====================
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: appleCredential.authorizationCode, // This works as nonce
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Optional: Update display name if available (only first time)
      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        final displayName =
            "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}"
                .trim();
        if (displayName.isNotEmpty) {
          await userCredential.user?.updateDisplayName(displayName);
        }
      }

      debugPrint("Signed in with Apple: ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      debugPrint('Error during Apple Sign-In: $e');
      return null;
    }
  }
*/
  // ==================== SIGN OUT (Both Google & Apple) ====================
  Future<void> signOut() async {
    try {
      // Sign out from Google (prevents auto-login)
      await GoogleSignIn().signOut();

      // Sign out from Apple (optional, but good practice)
      // Note: Apple doesn't have a direct sign-out, but we disconnect to avoid auto-login
      // await SignInWithApple.disconnect(); // TODO * This is important!

      // Finally sign out from Firebase
      await FirebaseAuth.instance.signOut();

      debugPrint("Signed out successfully");
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }
}
