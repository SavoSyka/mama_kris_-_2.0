import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/dislike_job_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/fetch_jobs_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/filter_jobs_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/like_job_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/search_jobs_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/view_job_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final FetchJobsUseCase fetchJobsUseCase;
  final SearchJobsUseCase searchJobsUseCase;
  final LikeJobUseCase likeJobUseCase;
  final DislikeJobUseCase dislikeJobUseCase;
  final FilterJobsUsecase filterJobsUsecase;
  final ViewJobUseCase viewJobUseCase;

  JobBloc({
    required this.fetchJobsUseCase,
    required this.searchJobsUseCase,
    required this.likeJobUseCase,
    required this.dislikeJobUseCase,
    required this.filterJobsUsecase,
    required this.viewJobUseCase,
  }) : super(JobInitial()) {
    on<FetchJobsEvent>(_onFetchJobs);
    on<LoadNextJobsPageEvent>(_onLoadNextJobsPage);

    on<SearchJobsEvent>(_onSearchJobs);
    on<LikeJobEvent>(_onLikeJob);
    on<DislikeJobEvent>(_onDislikeJob);
    on<ViewJobEvent>(_onViewJob);
    on<FilterJobEvent>(_onFilterJob);
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onFetchJobs(
    FetchJobsEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(JobLoading());
    try {
      final result = await fetchJobsUseCase(1);

      result.fold(
        (failure) {
          emit(JobError(failure.message));
        },
        (jobs) {
          emit(JobLoaded(jobs: jobs, isLoadingMore: false));
        },
      );
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onFilterJob(
    FilterJobEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(JobLoading());
    try {
      final result = await filterJobsUsecase(
        FilterJobParams(
          page: event.page,
          perPage: event.perPage,
          maxSalary: event.maxSalary,
          minSalary: event.minSalary,
          title: event.title,
          salaryWithAgreement: event.salaryWithAgreement,
        ),
      );

      result.fold(
        (failure) {
          emit(JobError(failure.message));
        },
        (jobs) {
          emit(JobLoaded(jobs: jobs, isLoadingMore: false));
        },
      );
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  // * ────────────────────── LOAD NEXT PAGE ───────────────────────
  Future<void> _onLoadNextJobsPage(
    LoadNextJobsPageEvent event,
    Emitter<JobState> emit,
  ) async {
    final currentState = state;

    // ── Guard: already loading or no more pages ─────────────────
    if (currentState is! JobLoaded ||
        currentState.isLoadingMore ||
        !currentState.jobs.hasNextPage) {
      return;
    }

    // ── Emit "loading more" (keeps old list) ───────────────────
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      // Check if filters are active
      final hasFilters = event.minSalary != null ||
          event.maxSalary != null ||
          event.title != null ||
          event.salaryWithAgreement != null;

      if (hasFilters) {
        // Use filter usecase when filters are active
        final result = await filterJobsUsecase(
          FilterJobParams(
            page: event.nextPage,
            perPage: 10,
            maxSalary: event.maxSalary,
            minSalary: event.minSalary,
            title: event.title,
            salaryWithAgreement: event.salaryWithAgreement,
          ),
        );

        result.fold(
          (failure) => emit(JobError(failure.message)),
          (newJobList) {
            final updatedJobs = [...currentState.jobs.jobs, ...newJobList.jobs];

            emit(
              JobLoaded(
                jobs: currentState.jobs.copyWith(
                  jobs: updatedJobs,
                  currentPage: newJobList.currentPage,
                  totalPage: newJobList.totalPage,
                  hasNextPage: newJobList.hasNextPage,
                ),
                isLoadingMore: false,
              ),
            );
          },
        );
      } else {
        // Use regular fetch when no filters
        final result = await fetchJobsUseCase(event.nextPage);
        result.fold((failure) => emit(JobError(failure.message)), (newJobList) {
          final updatedJobs = [...currentState.jobs.jobs, ...newJobList.jobs];

          emit(
            JobLoaded(
              jobs: currentState.jobs.copyWith(
                jobs: updatedJobs,
                currentPage: newJobList.currentPage,
                totalPage: newJobList.totalPage,
                hasNextPage: newJobList.hasNextPage,
              ),
              isLoadingMore: false,
            ),
          );
        });
      }
    } catch (e, stack) {
      debugPrint('Load next page error: $e\n$stack');
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
        emit(JobLoaded(jobs: jobs, isLoadingMore: false));
      });
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onLikeJob(LikeJobEvent event, Emitter<JobState> emit) async {
    final currentState = state;
    if (currentState is JobLoaded) {
      try {
        final cpage = currentState.jobs.currentPage;
        final tPage = currentState.jobs.totalPage;
        final hasNext = currentState.jobs.hasNextPage;

        final result = await likeJobUseCase(event.jobId);
        result.fold((failure) => emit(JobError(failure.message)), (_) {
          // Remove liked job from the current list
          final updatedJobs = currentState.jobs.jobs
              .where((job) => job.jobId != event.jobId)
              .toList();

          emit(
            JobLoaded(
              jobs: JobList(
                jobs: updatedJobs,
                currentPage: cpage,
                totalPage: tPage,
                hasNextPage: hasNext,
              ),
              isLoadingMore: false,
            ),
          );
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

  Future<void> _onViewJob(
    ViewJobEvent event,
    Emitter<JobState> emit,
  ) async {
    try {
      await viewJobUseCase(event.jobId);
    } catch (e) {
      // Silently fail for view job - don't show error to user
      debugPrint('Error viewing job: $e');
    }
  }
}
