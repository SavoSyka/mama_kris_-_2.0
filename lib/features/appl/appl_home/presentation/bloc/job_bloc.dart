import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/dislike_job_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/fetch_jobs_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/like_job_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/search_jobs_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final FetchJobsUseCase fetchJobsUseCase;
  final SearchJobsUseCase searchJobsUseCase;
  final LikeJobUseCase likeJobUseCase;
  final DislikeJobUseCase dislikeJobUseCase;

  JobBloc({
    required this.fetchJobsUseCase,
    required this.searchJobsUseCase,
    required this.likeJobUseCase,
    required this.dislikeJobUseCase,
  }) : super(JobInitial()) {
    on<FetchJobsEvent>(_onFetchJobs);
    on<SearchJobsEvent>(_onSearchJobs);
    on<LikeJobEvent>(_onLikeJob);
    on<DislikeJobEvent>(_onDislikeJob);
  }

  Future<void> _onFetchJobs(
    FetchJobsEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(JobLoading());
    try {
      final result = await fetchJobsUseCase();

      result.fold(
        (failure) {
          emit(JobError(failure.message));
        },
        (jobs) {
          emit(JobLoaded(jobs));
        },
      );
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onSearchJobs(
    SearchJobsEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(JobLoading());
    try {
      final result = await searchJobsUseCase(event.query);

      result.fold((failure) {}, (jobs) {
        emit(JobLoaded(jobs));
      });
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onLikeJob(LikeJobEvent event, Emitter<JobState> emit) async {
    final currentState = state;
    if (currentState is JobLoaded) {
      try {
        final result = await likeJobUseCase(event.jobId);
        result.fold((failure) => emit(JobError(failure.message)), (_) {
          // Remove liked job from the current list
          final updatedJobs = currentState.jobs.jobs
              .where((job) => job.jobId != event.jobId)
              .toList();

          emit(JobLoaded(JobList(jobs: updatedJobs)));
        });
      } catch (e) {
        emit(JobError(e.toString()));
      }
    }
  }

  Future<void> _onDislikeJob(
    DislikeJobEvent event,
    Emitter<JobState> emit,
  ) async {
    try {
      await dislikeJobUseCase(event.jobId);
      // emit(const JobActionSuccess('Job disliked successfully'));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }
}
