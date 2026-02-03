import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleParams {
  final String idToken;

  const LoginWithGoogleParams({required this.idToken});
}

class LoginWithGoogleUsecase extends UseCase<bool, LoginWithGoogleParams> {
  final AuthRepository repository;

  LoginWithGoogleUsecase(this.repository);

  @override
  ResultFuture<bool> call(LoginWithGoogleParams params) async {
    return await repository.loginWithGoogle(idToken: params.idToken);
  }
}
