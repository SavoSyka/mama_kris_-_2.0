import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';

class LikedJob extends Equatable {
  final int jobId;
  final JobEntity job;

  const LikedJob({required this.jobId, required this.job});

  @override
  List<Object?> get props => [jobId, job];
}
