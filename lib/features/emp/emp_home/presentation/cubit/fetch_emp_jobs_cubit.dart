import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/emp/emp_home/domain/usecases/fetch_emp_jobs_usecase.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/fetch_emp_jobs_state.dart';

class FetchEmpJobsCubit extends Cubit<FetchEmpJobsState> {
  final FetchEmpJobsUseCase fetchEmpJobsUseCase;

  FetchEmpJobsCubit({required this.fetchEmpJobsUseCase}) : super(FetchEmpJobsInitial());

  Future<void> fetchJobs(String status, {int page = 1}) async {
    emit(FetchEmpJobsLoading());
    try {
      final params = FetchEmpJobsParams(status: status, page: page);
      final result = await fetchEmpJobsUseCase(params);
      result.fold(
        (failure) => emit(FetchEmpJobsError(failure.message)),
        (jobList) => emit(FetchEmpJobsLoaded(jobList)),
      );
    } catch (e) {
      emit(FetchEmpJobsError(e.toString()));
    }
  }
}