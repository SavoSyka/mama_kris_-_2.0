import 'package:mama_kris/features/appl/appl_home/domain/entities/public_counts_entity.dart';

class PublicCountsModel extends PublicCountsEntity {
  const PublicCountsModel({
    required super.jobs,
    required super.users,
  });

  factory PublicCountsModel.fromJson(Map<String, dynamic> json) {
    return PublicCountsModel(
      jobs: json['jobs'] as int,
      users: json['users'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobs': jobs,
      'users': users,
    };
  }
}
