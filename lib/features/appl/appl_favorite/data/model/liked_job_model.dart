import 'package:flutter/material.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_job.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_model.dart';

class LikedJobModel extends LikedJob {
  const LikedJobModel({required super.jobId, required super.job});

  factory LikedJobModel.fromJson(DataMap json) {
    // debugPrint('jobjjj ${json}');
    return LikedJobModel(
      jobId: json['jobID'],
      job: JobModel.fromJson(json['job']),
    );
  }
}
