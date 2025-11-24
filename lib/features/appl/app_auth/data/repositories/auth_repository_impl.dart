import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<UserEntity> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return result.fold(
        (failure) => Left(failure),
        (userModel) => Right(userModel),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.signup(name, email, password);
      return result.fold(
        (failure) => Left(failure),
        (userModel) => Right(userModel),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> verifyOtp(String email, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(email, otp);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> checkEmail(String email) async {
    try {
      final result = await remoteDataSource.checkEmail(email);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> resendOtp(String email) async {
    try {
      final result = await remoteDataSource.resendOtp(email);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> forgotPassword(String email) async {
    try {
      final result = await remoteDataSource.forgotPassword(email);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> loginWithGoogle({required String idToken}) async {
    try {
      final result = await remoteDataSource.loginWithGoogle(idToken: idToken);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> updatePassword(String newPassword) async {
    try {
      final result = await remoteDataSource.updatePassword(newPassword);
      return const Right(true);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> loginWithApple({
    required String identityToken,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final result = await remoteDataSource.loginWithApple(
        identityToken: identityToken,
        userData: userData,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
