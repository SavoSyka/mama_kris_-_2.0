import 'package:hive/hive.dart';
import 'package:mama_kris/core/constants/hive_constants.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';
part 'search_job_model.g.dart';

@HiveType(typeId: HiveConstants.searchJobBoxId)
class SearchJobModel extends SearchJobEntity {
  @override
  @HiveField(0)
  final String title;

  const SearchJobModel({required this.title}) : super(title: title);

  factory SearchJobModel.fromJson(dynamic json) {
    if (json is String) {
      return SearchJobModel(title: json);
    } else if (json is Map<String, dynamic>) {
      return SearchJobModel(title: json['title']);
    } else {
      throw Exception("Invalid JSON format for SearchJobModel");
    }
  }

  Map<String, dynamic> toJson() => {'title': title};
}
