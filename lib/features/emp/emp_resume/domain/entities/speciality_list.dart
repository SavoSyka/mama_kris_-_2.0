// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';

class SpecialityList extends Equatable {
  final List<Speciality> jobs;
  final int totalPage;
  final int currentPage;
  final bool hasNextPage;

  const SpecialityList({
    required this.jobs,
    required this.totalPage,
    required this.currentPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [jobs, currentPage, totalPage, hasNextPage];

  SpecialityList copyWith({
    List<Speciality>? jobs,
    int? totalPage,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return SpecialityList(
      jobs: jobs ?? this.jobs,
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
