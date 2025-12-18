import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/email_subscription/data/data_sources/email_subscription_remote_data_source.dart';
import 'package:mama_kris/features/email_subscription/domain/repositories/email_subscription_repository.dart';

class EmailSubscriptionRepositoryImpl implements EmailSubscriptionRepository {
  final EmailSubscriptionRemoteDataSource remoteDataSource;

  EmailSubscriptionRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<bool> subscribeEmail(String email) async {
    try {
      final result = await remoteDataSource.subscribeEmail(email);
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
  ResultFuture<bool> unsubscribeEmail(String email) async {
    try {
      final result = await remoteDataSource.unsubscribeEmail(email);
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
}
