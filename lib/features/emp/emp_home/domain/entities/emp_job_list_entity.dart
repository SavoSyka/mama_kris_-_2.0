import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_entity.dart';

class EmpJobListEntity extends Equatable {
  final List<EmpJobEntity> jobs;
  final int currentPage;
  final int totalPage;
  final bool hasNextPage;

  const EmpJobListEntity({
    required this.jobs,
    required this.currentPage,
    required this.totalPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [jobs, currentPage, totalPage, hasNextPage];
}