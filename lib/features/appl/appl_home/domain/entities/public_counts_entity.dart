import 'package:equatable/equatable.dart';

class PublicCountsEntity extends Equatable {
  final int jobs;
  final int users;

  const PublicCountsEntity({
    required this.jobs,
    required this.users,
  });

  @override
  List<Object?> get props => [jobs, users];
}
