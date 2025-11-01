import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_model.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

class JobListModel extends JobList {
  const JobListModel({required super.jobs});

  factory JobListModel.fromJson(DataMap json) {
    return JobListModel(
      jobs: [
        JobModel(
          id: 123,
          title: 'title',
          description: 'description',
          price: 22,
          status: '',
        ),
      ],
    );
  }
}
