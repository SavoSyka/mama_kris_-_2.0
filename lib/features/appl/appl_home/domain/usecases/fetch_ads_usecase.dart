import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/ad_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/ads_repository.dart';

class FetchAdsUseCase extends UsecaseWithoutParams<AdEntity> {
  final AdsRepository repository;

  FetchAdsUseCase(this.repository);

  @override
  ResultFuture<AdEntity> call() async {
    return await repository.fetchAds();
  }
}