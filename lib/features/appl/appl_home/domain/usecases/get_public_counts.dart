import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/public_counts_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/public_counts_repository.dart';

class GetPublicCounts extends UsecaseWithoutParams<PublicCountsEntity> {
  final PublicCountsRepository repository;

  GetPublicCounts(this.repository);

  @override
  ResultFuture<PublicCountsEntity> call() async {
    return await repository.getPublicCounts();
  }
}
