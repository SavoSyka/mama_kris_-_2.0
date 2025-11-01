import 'package:shared_preferences/shared_preferences.dart';

abstract class JobLocalDataSource {
  Future<void> saveLikedJob(int jobId);
  Future<void> saveDislikedJob(int jobId);
  Future<List<int>> getLikedJobs();
  Future<List<int>> getDislikedJobs();
}

class JobLocalDataSourceImpl implements JobLocalDataSource {
  static const String likedJobsKey = 'liked_jobs';
  static const String dislikedJobsKey = 'disliked_jobs';

  @override
  Future<void> saveLikedJob(int jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedJobs = prefs.getStringList(likedJobsKey) ?? [];
    likedJobs.add(jobId.toString());
    await prefs.setStringList(likedJobsKey, likedJobs);
  }

  @override
  Future<void> saveDislikedJob(int jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final dislikedJobs = prefs.getStringList(dislikedJobsKey) ?? [];
    dislikedJobs.add(jobId.toString());
    await prefs.setStringList(dislikedJobsKey, dislikedJobs);
  }

  @override
  Future<List<int>> getLikedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final likedJobs = prefs.getStringList(likedJobsKey) ?? [];
    return likedJobs.map((id) => int.parse(id)).toList();
  }

  @override
  Future<List<int>> getDislikedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final dislikedJobs = prefs.getStringList(dislikedJobsKey) ?? [];
    return dislikedJobs.map((id) => int.parse(id)).toList();
  }
}