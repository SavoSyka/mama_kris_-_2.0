import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // ← Add this package

class AuthService {
  // ==================== GOOGLE SIGN-IN ====================

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['openid', 'email', 'profile'],
  serverClientId: 
  "86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com"

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

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

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