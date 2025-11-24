import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/ad_entity.dart';

abstract class AdsRepository {
  ResultFuture<AdEntity> fetchAds();
}