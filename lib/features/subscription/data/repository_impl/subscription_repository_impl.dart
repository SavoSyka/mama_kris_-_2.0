import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/subscription/data/data_source/subscription_remote_data_source.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';
import 'package:mama_kris/features/subscription/domain/repository/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<SubscriptionEntity>> getTariffs() async {
    try {
      final value = await remoteDataSource.getTariffs();
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<String?> initiatePayment(SubscriptionEntity tariff) async {
    try {
      final value = await remoteDataSource.initiatePayment(tariff);
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
