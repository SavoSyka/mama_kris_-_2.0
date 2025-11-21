// // ignore_for_file: document_ignores, lines_longer_than_80_chars, prefer_const_constructors, avoid_catches_without_on_clauses

// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'dart:math';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

// @LazySingleton(as: AuthRepository)
// class FirebaseAuthRepository implements AuthRepository {
//   FirebaseAuthRepository(
//     this._firebaseAuth,
//     this._googleSignIn,
//     this._facebookAuth,
//     this._authRemoteDataSource,
//   );
//   final firebase_auth.FirebaseAuth _firebaseAuth;
//   final GoogleSignIn _googleSignIn;
//   final FacebookAuth _facebookAuth;
//   final AuthRemoteDataSource _authRemoteDataSource;
//   final UserProfileService _userProfileService = UserProfileService();

//   String _generateSecureNonce([int length = 32]) {
//     const String charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final Random random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//         .join();
//   }

//   String _sha256ofString(String input) {
//     final List<int> bytes = utf8.encode(input);
//     final Digest digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   @override
//   Stream<domain.User> get user {
//     return _firebaseAuth.authStateChanges().map((firebaseUser) {
//       return firebaseUser == null
//           ? domain.User.empty
//           : UserModel.fromFirebase(firebaseUser);
//     });
//   }

//   @override
//   Future<Either<Failure, domain.User>> getCurrentUser() async {
//     try {
//       final firebaseUser = _firebaseAuth.currentUser;
//       return Right(
//         firebaseUser == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(firebaseUser),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> signUp({
//     required String email,
//     required String password,
//     String? displayName,
//   }) async {
//     try {
//       final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (displayName != null && displayName.isNotEmpty) {
//         await userCredential.user?.updateDisplayName(displayName);

//         await userCredential.user?.reload();
//       }

//       if (userCredential.user != null) {
//         await _userProfileService.createOrUpdateUserProfile(
//           userId: userCredential.user!.uid,
//           email: email,
//           displayName: displayName,
//         );
//       }

//       final updatedUser = _firebaseAuth.currentUser;

//       return Right(
//         updatedUser == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(updatedUser),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       return Left(
//         AuthFailure(
//           message: e.message ?? 'Authentication failed',
//           code: int.tryParse(e.code),
//         ),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       return Left(
//         AuthFailure(
//           message: e.message ?? 'Authentication failed',
//           code: int.tryParse(e.code),
//         ),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> signInWithGoogle() async {
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return Left(AuthFailure(message: 'Google sign in was canceled'));
//       }

//       final googleAuth = await googleUser.authentication;
//       final credential = firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _firebaseAuth.signInWithCredential(
//         credential,
//       );

//       // Ensure user profile exists in Firestore
//       if (userCredential.user != null) {
//         await _userProfileService.ensureUserProfileExists(
//           userId: userCredential.user!.uid,
//         );
//       }

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case 'account-exists-with-different-credential':
//           errorMessage =
//               'Ya existe una cuenta con este correo electrónico pero con un método de inicio de sesión diferente. Por favor, inicia sesión con tu método original (correo y contraseña) o contacta soporte para vincular las cuentas.';
//           break;
//         case 'invalid-credential':
//           errorMessage =
//               'Las credenciales de Google no son válidas. Inténtalo de nuevo.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage =
//               'El inicio de sesión con Google no está habilitado. Contacta soporte.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'Esta cuenta ha sido deshabilitada. Contacta soporte.';
//           break;
//         case 'user-not-found':
//           errorMessage =
//               'No se encontró ningún usuario con estas credenciales.';
//           break;
//         case 'wrong-password':
//           errorMessage = 'Credenciales incorrectas. Inténtalo de nuevo.';
//           break;
//         case 'too-many-requests':
//           errorMessage = 'Demasiados intentos fallidos. Inténtalo más tarde.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Error de conexión. Verifica tu conexión a Internet.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al iniciar sesión con Google.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(
//           message: 'Error inesperado al iniciar sesión con Google.',
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> signInWithFacebook() async {
//     try {
//       final result = await _facebookAuth.login();

//       if (result.status != LoginStatus.success) {
//         return Left(AuthFailure(message: 'Facebook sign in was canceled'));
//       }

//       final accessToken = result.accessToken;

//       if (accessToken == null) {
//         return Left(AuthFailure(message: 'Facebook access token is null'));
//       }

//       final credential = firebase_auth.FacebookAuthProvider.credential(
//         accessToken.token,
//       );

//       final userCredential = await _firebaseAuth.signInWithCredential(
//         credential,
//       );

//       // Ensure user profile exists in Firestore
//       if (userCredential.user != null) {
//         await _userProfileService.ensureUserProfileExists(
//           userId: userCredential.user!.uid,
//         );
//       }

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case 'account-exists-with-different-credential':
//           errorMessage =
//               'Ya existe una cuenta con este correo electrónico pero con un método de inicio de sesión diferente. Por favor, inicia sesión con tu método original (correo y contraseña) o contacta soporte para vincular las cuentas.';
//           break;
//         case 'invalid-credential':
//           errorMessage =
//               'Las credenciales de Facebook no son válidas. Inténtalo de nuevo.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage =
//               'El inicio de sesión con Facebook no está habilitado. Contacta soporte.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'Esta cuenta ha sido deshabilitada. Contacta soporte.';
//           break;
//         case 'user-not-found':
//           errorMessage =
//               'No se encontró ningún usuario con estas credenciales.';
//           break;
//         case 'wrong-password':
//           errorMessage = 'Credenciales incorrectas. Inténtalo de nuevo.';
//           break;
//         case 'too-many-requests':
//           errorMessage = 'Demasiados intentos fallidos. Inténtalo más tarde.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Error de conexión. Verifica tu conexión a Internet.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al iniciar sesión con Facebook.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(
//           message: 'Error inesperado al iniciar sesión con Facebook.',
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> signInWithApple() async {
//     try {
//       final String rawNonce = _generateSecureNonce();
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         nonce: _sha256ofString(rawNonce),
//       );

//       if (appleCredential.identityToken == null) {
//         return Left(
//           AuthFailure(message: 'No se pudo obtener el token de identidad de Apple'),
//         );
//       }


//       final oauthCredential =
//           firebase_auth.OAuthProvider('apple.com').credential(
//         idToken: appleCredential.identityToken!,
//         rawNonce: rawNonce,
//         accessToken: appleCredential.authorizationCode,
//       );

//       final userCredential = await _firebaseAuth.signInWithCredential(
//         oauthCredential,
//       );

//       if (userCredential.additionalUserInfo?.isNewUser == true) {
//         final displayName = appleCredential.givenName != null &&
//                 appleCredential.familyName != null
//             ? '${appleCredential.givenName} ${appleCredential.familyName}'
//             : appleCredential.givenName ?? appleCredential.familyName;

//         if (displayName != null && userCredential.user != null) {
//           await userCredential.user!.updateDisplayName(displayName);
//           await userCredential.user!.reload();
//         }
//       }

//       // Ensure user profile exists in Firestore
//       if (userCredential.user != null) {
//         await _userProfileService.ensureUserProfileExists(
//           userId: userCredential.user!.uid,
//         );
//       }

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on SignInWithAppleAuthorizationException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case AuthorizationErrorCode.canceled:
//           errorMessage = 'El inicio de sesión con Apple fue cancelado.';
//           break;
//         case AuthorizationErrorCode.failed:
//           errorMessage = 'Error al iniciar sesión con Apple. Inténtalo de nuevo.';
//           break;
//         case AuthorizationErrorCode.invalidResponse:
//           errorMessage =
//               'Respuesta inválida de Apple. Por favor, inténtalo de nuevo.';
//           break;
//         case AuthorizationErrorCode.notHandled:
//           errorMessage =
//               'El inicio de sesión con Apple no está disponible. Contacta soporte.';
//           break;
//         case AuthorizationErrorCode.unknown:
//           errorMessage =
//               'Error desconocido al iniciar sesión con Apple. Inténtalo de nuevo.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al iniciar sesión con Apple.';
//       }

//       return Left(AuthFailure(message: errorMessage));
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case 'account-exists-with-different-credential':
//           errorMessage =
//               'Ya existe una cuenta con este correo electrónico pero con un método de inicio de sesión diferente. Por favor, inicia sesión con tu método original (correo y contraseña) o contacta soporte para vincular las cuentas.';
//           break;
//         case 'invalid-credential':
//           errorMessage =
//               'Las credenciales de Apple no son válidas. Inténtalo de nuevo.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage =
//               'El inicio de sesión con Apple no está habilitado. Contacta soporte.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'Esta cuenta ha sido deshabilitada. Contacta soporte.';
//           break;
//         case 'user-not-found':
//           errorMessage =
//               'No se encontró ningún usuario con estas credenciales.';
//           break;
//         case 'too-many-requests':
//           errorMessage = 'Demasiados intentos fallidos. Inténtalo más tarde.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Error de conexión. Verifica tu conexión a Internet.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al iniciar sesión con Apple.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(
//           message: 'Error inesperado al iniciar sesión con Apple: ${e.toString()}',
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await Future.wait([
//         _firebaseAuth.signOut(),
//         _googleSignIn.signOut(),
//         _facebookAuth.logOut(),
//       ]);
//       return const Right(null);
//     } catch (e) {
//       return Left(AuthFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> resetPassword(String email) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//       return const Right(null);
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case 'user-not-found':
//           errorMessage =
//               'No hay ningún usuario registrado con este correo electrónico.';
//           break;
//         case 'invalid-email':
//           errorMessage = 'El formato del correo electrónico no es válido.';
//           break;
//         case 'too-many-requests':
//           errorMessage =
//               'Demasiados intentos fallidos. Por favor, inténtalo más tarde.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Error de conexión. Verifica tu conexión a Internet.';
//           break;
//         default:
//           errorMessage =
//               e.message ?? 'Ha ocurrido un error al restablecer la contraseña.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(
//           message: 'Ha ocurrido un error inesperado. Inténtalo de nuevo.',
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> linkWithGoogle() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         return Left(AuthFailure(message: 'No hay usuario autenticado'));
//       }

//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return Left(AuthFailure(message: 'Google sign in was canceled'));
//       }

//       final googleAuth = await googleUser.authentication;
//       final credential = firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await currentUser.linkWithCredential(credential);

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {

//       String errorMessage;
//       switch (e.code) {
//         case 'provider-already-linked':
//           errorMessage = 'Esta cuenta de Google ya está vinculada a tu cuenta.';
//           break;
//         case 'credential-already-in-use':
//           errorMessage =
//               'Esta cuenta de Google ya está siendo utilizada por otro usuario.';
//           break;
//         case 'email-already-in-use':
//           errorMessage =
//               'El correo electrónico de esta cuenta de Google ya está en uso.';
//           break;
//         case 'invalid-credential':
//           errorMessage = 'Las credenciales de Google no son válidas.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage = 'La vinculación con Google no está habilitada.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'Esta cuenta ha sido deshabilitada.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al vincular cuenta de Google.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       print('General exception on Google link: $e');
//       return Left(
//         AuthFailure(message: 'Error inesperado al vincular cuenta de Google.'),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> linkWithFacebook() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         return Left(AuthFailure(message: 'No hay usuario autenticado'));
//       }

//       final result = await _facebookAuth.login();

//       if (result.status != LoginStatus.success) {
//         return Left(AuthFailure(message: 'Facebook sign in was canceled'));
//       }

//       final accessToken = result.accessToken;

//       if (accessToken == null) {
//         return Left(AuthFailure(message: 'Facebook access token is null'));
//       }

//       final credential = firebase_auth.FacebookAuthProvider.credential(
//         accessToken.token,
//       );

//       final userCredential = await currentUser.linkWithCredential(credential);

//       return Right(
//         userCredential.user == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(userCredential.user!),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {

//       String errorMessage;
//       switch (e.code) {
//         case 'provider-already-linked':
//           errorMessage =
//               'Esta cuenta de Facebook ya está vinculada a tu cuenta.';
//           break;
//         case 'credential-already-in-use':
//           errorMessage =
//               'Esta cuenta de Facebook ya está siendo utilizada por otro usuario.';
//           break;
//         case 'email-already-in-use':
//           errorMessage =
//               'El correo electrónico de esta cuenta de Facebook ya está en uso.';
//           break;
//         case 'invalid-credential':
//           errorMessage = 'Las credenciales de Facebook no son válidas.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage = 'La vinculación con Facebook no está habilitada.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'Esta cuenta ha sido deshabilitada.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al vincular cuenta de Facebook.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(
//           message: 'Error inesperado al vincular cuenta de Facebook.',
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> unlinkProvider(String providerId) async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         return Left(AuthFailure(message: 'No hay usuario autenticado'));
//       }

//       final updatedUser = await currentUser.unlink(providerId);

//       return Right(UserModel.fromFirebase(updatedUser));
//     } on firebase_auth.FirebaseAuthException catch (e) {

//       String errorMessage;
//       switch (e.code) {
//         case 'no-such-provider':
//           errorMessage = 'Este proveedor no está vinculado a tu cuenta.';
//           break;
//         case 'requires-recent-login':
//           errorMessage =
//               'Por seguridad, necesitas iniciar sesión nuevamente antes de desvincular esta cuenta.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Error al desvincular proveedor.';
//       }

//       return Left(
//         AuthFailure(message: errorMessage, code: int.tryParse(e.code)),
//       );
//     } catch (e) {
//       return Left(
//         AuthFailure(message: 'Error inesperado al desvincular proveedor.'),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, List<String>>> getLinkedProviders() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         return Left(AuthFailure(message: 'No hay usuario autenticado'));
//       }

//       final providers =
//           currentUser.providerData.map((info) => info.providerId).toList();
//       return Right(providers);
//     } catch (e) {
//       return Left(
//         AuthFailure(message: 'Error al obtener proveedores vinculados.'),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> updateProfilePhoto(
//     String photoURL,
//   ) async {
//     try {

//       final user = _firebaseAuth.currentUser;
//       if (user == null) {
//         return Left(AuthFailure(message: 'Usuario no autenticado'));
//       }

//       await user.updatePhotoURL(photoURL);

//       await user.reload();

//       final updatedUser = _firebaseAuth.currentUser;

//       return Right(
//         updatedUser == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(updatedUser),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       return Left(
//         AuthFailure(message: e.message ?? 'Error al actualizar foto de perfil'),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: 'Error al actualizar foto de perfil'));
//     }
//   }

//   @override
//   Future<Either<Failure, domain.User>> updateDisplayName(
//     String displayName,
//   ) async {
//     try {
//       final user = _firebaseAuth.currentUser;
//       if (user == null) {
//         return Left(AuthFailure(message: 'Usuario no autenticado'));
//       }

//       await user.updateDisplayName(displayName);
//       await user.reload();

//       final updatedUser = _firebaseAuth.currentUser;
//       return Right(
//         updatedUser == null
//             ? domain.User.empty
//             : UserModel.fromFirebase(updatedUser),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       return Left(
//         AuthFailure(message: e.message ?? 'Error al actualizar nombre'),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: 'Error al actualizar nombre'));
//     }
//   }

//   @override
//   Future<Either<Failure, Map<String, dynamic>>> deleteAccount() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         return Left(AuthFailure(message: 'Usuario no autenticado'));
//       }

//       final result = await _authRemoteDataSource.deleteAccount();
      
//       return result.fold(
//         (failure) => Left(failure),
//         (data) => Right(data),
//       );
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       return Left(
//         AuthFailure(
//           message: e.message ?? 'Error al eliminar la cuenta',
//           code: int.tryParse(e.code),
//         ),
//       );
//     } catch (e) {
//       return Left(AuthFailure(message: 'Error inesperado al eliminar la cuenta'));
//     }
//   }
// }
