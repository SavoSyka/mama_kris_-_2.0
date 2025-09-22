import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_welcome/domain/entities/user.dart';
import 'package:mama_kris/features/employe_welcome/data/data_source/emp_auth_remote_data_source.dart';
import 'package:mama_kris/features/employe_welcome/domain/entities/employe_user.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';

class EmpAuthRepositoryImpl implements EmployeAuthRepository {
  final EmpAuthRemoteDataSource remoteDataSource;
  EmpAuthRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<bool> checkEmail(String email) async {
    try {
      final result = await remoteDataSource.checkEmail(email);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> forgotPassword(String email) async {
    try {
      final result = await remoteDataSource.forgotPassword(email);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> validateOtp(String email, String otp) async {
    try {
      final result = await remoteDataSource.validateOtp(email, otp);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<EmployeUser> register(
    String email,
    String name,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.register(email, name, password);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<EmployeUser> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<EmployeUser> changePassword(String password) async {
    try {
      final result = await remoteDataSource.changePassword(password);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
