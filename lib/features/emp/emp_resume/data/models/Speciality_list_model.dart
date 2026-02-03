import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality_list.dart';

class SpecialityListModel extends SpecialityList {
  const SpecialityListModel({
    required super.jobs,
    required super.currentPage,
    required super.totalPage,
    required super.hasNextPage,
  });

  factory SpecialityListModel.fromJson(DataMap json) {
    // debugPrint("SpecialityListModel -> page");

    final jobsData = json['data'] as List;
    final cPage = json['page'] is int ? json['page'] as int : 0;
    final tPage = json['total'] is int ? json['total'] as int : 0;
    final pSize = json['pageSize'] is int ? json['pageSize'] as int : 0;

    final totalFetchedData = cPage * pSize;
    final hasNextPage = totalFetchedData < tPage;

    return SpecialityListModel(
      jobs: jobsData.map((job) => SpecialityModel.fromJson(job)).toList(),
      currentPage: cPage,
      totalPage: tPage,
      hasNextPage: hasNextPage,
    );
  }
}

class SpecialityModel extends Speciality {
  const SpecialityModel({required super.name});

  factory SpecialityModel.fromJson(String json) {
    return SpecialityModel(name: json);
  }
}
