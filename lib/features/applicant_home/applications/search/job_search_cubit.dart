// presentation/cubit/jobs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/applicant_home/applications/search/job_search_state.dart';
import 'package:mama_kris/features/applicant_home/domain/usecases/get_query_jobs_usecase.dart';

class JobSearchCubit extends Cubit<JobSearchState> {
  final GetQueryJobsUsecase getJobs;

  JobSearchCubit(this.getJobs) : super(JobsInitial());

  Future<void> fetchJobs(String query) async {
    emit(JobsLoading());
    try {
      final result = await getJobs(query);

      result.fold(
        (failure) {
          emit(JobsError(failure.message));
        },
        (jobs) {
          emit(JobsLoaded(jobs));
        },
      );
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }
}
