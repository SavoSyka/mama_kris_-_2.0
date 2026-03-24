import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // ← Add this package

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // для kDebugMode

// для kDebugMode

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:math';
import 'package:crypto/crypto.dart';

class AuthService {
  // ==================== GOOGLE SIGN-IN ====================

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['openid', 'email', 'profile'],
  //   serverClientId:
  //       "86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com",
  //   // '86099763542-9tgb2dqc63hj0utf8fc9mvve0fplc8e1.apps.googleusercontent.com',
  // );

  // Future<Map<String, dynamic>?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       debugPrint('❌ [Google Sign-In] Пользователь отменил вход');
  //       return null;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final String? idToken = googleAuth.idToken;
  //     if (idToken == null) {
  //       debugPrint('❗ [Google Sign-In] Не удалось получить ID токен');
  //       return null;
  //     }

  //     return {'idToken': idToken};
  //   } catch (e) {
  //     print('🛑 Ошибка входа через Google: $e');
  //     print('🔍 Stacktrace: ');
  //     // lgn.showErrorSnackBar(context, 'Ошибка. Попробуйте ещё раз.');
  //   }
  //   return null;
  // }

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

  // * uncommen it when it is failed.

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      if (kDebugMode) {
        print('[Apple Sign-In] Starting Apple sign-in...');
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (kDebugMode) {
        print('[Apple Sign-In] Got Apple ID credential');
        print('Identity Token: ${credential.identityToken}');
        print('Email: ${credential.email ?? 'not provided (repeat sign-in)'}');
        print('Name: ${credential.givenName ?? 'not provided'}');
      }

      if (credential.identityToken == null) {
        if (kDebugMode) print('[Apple Sign-In] identityToken == null');
        throw Exception('Apple Identity Token is null');
      }

      if (kDebugMode) {
        final parts = credential.identityToken!.split('.');
        if (parts.length == 3) {
          final payload = base64Url.normalize(parts[1]);
          final decoded = utf8.decode(base64Url.decode(payload));
          print('Apple Token Payload: $decoded');
        }
      }

      final result = {
        'identityToken': credential.identityToken,
        "userData": {
          'email': credential.email,
          'firstName': credential.givenName,
          'lastName': credential.familyName,
          'authorizationCode': credential.authorizationCode,
          'userIdentifier': credential.userIdentifier,
        },
      };

      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('[Apple Sign-In] User cancelled');
        return null;
      }
      debugPrint('[Apple Sign-In] Authorization error: ${e.message}');
      rethrow;
    } catch (e, stacktrace) {
      debugPrint('[Apple Sign-In] Error: $e');
      if (kDebugMode) {
        print('Stacktrace: $stacktrace');
      }
      rethrow;
    }
  }

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
      // await GoogleSignIn().signOut();

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
