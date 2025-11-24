import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/data/data_sources/ads_remote_data_source.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/ad_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/ads_repository.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;

  AdsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<AdEntity> fetchAds() async {
    try {
      final value = await remoteDataSource.fetchAds();
      debugPrint("add returned ");
      return Right(value);
    } catch (e) {
      debugPrint(" erro ha add returned ");

      return Left(ServerFailure(e.toString()));
    }
  }
}
