import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/public_counts_entity.dart';

abstract class PublicCountsRepository {
  Future<Either<Failure, PublicCountsEntity>> getPublicCounts();
}
