import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/fetch_liked_jobs.dart';

part 'liked_job_bloc_event.dart';
part 'liked_job_bloc_state.dart';

class LikedJobBlocBloc extends Bloc<LikedJobBlocEvent, LikedJobBlocState> {
  final FetchLikedJobs fetchLikedJobs;

  LikedJobBlocBloc({required this.fetchLikedJobs})
    : super(LikedJobBlocInitial()) {
    on<FetchLikedJobEvent>(_onFetchJobs);
    on<LikedLoadNextJobsPageEvent>(_onLoadNextJobsPage);
    on<RemovingLikedJobs>(onDislikeJob);

    on<LikedJobBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onFetchJobs(
    FetchLikedJobEvent event,
    Emitter<LikedJobBlocState> emit,
  ) async {
    emit(LikedJobLoading());
    try {
      final result = await fetchLikedJobs(1);

      result.fold(
        (failure) {
          emit(LikedJobError(failure.message));
        },
        (jobs) {
          emit(LikedJobLoadedState(jobs: jobs, isLoadingMore: false));
        },
      );
    } catch (e) {
      emit(LikedJobError(e.toString()));
    }
  }

  // * ────────────────────── LOAD NEXT Liked PAGE ───────────────────────
  Future<void> _onLoadNextJobsPage(
    LikedLoadNextJobsPageEvent event,
    Emitter<LikedJobBlocState> emit,
  ) async {
    final currentState = state;

    // ── Guard: already loading or no more pages ─────────────────
    if (currentState is! LikedJobLoadedState ||
        currentState.isLoadingMore ||
        !currentState.jobs.hasNextPage) {
      return;
    }

    // ── Emit “loading more” (keeps old list) ───────────────────
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      debugPrint(
        "\n😭😁 we are fetching new jobs. ${currentState.jobs.likedJob.length}\n",
      );
      final result = await fetchLikedJobs(event.nextPage);
      result.fold((failure) => emit(LikedJobError(failure.message)), (
        newJobList,
      ) {
        final updatedJobs = [
          ...currentState.jobs.likedJob,
          ...newJobList.likedJob,
        ];

        emit(
          LikedJobLoadedState(
            jobs: currentState.jobs.copyWith(
              likedJob: updatedJobs,
              currentPage: newJobList.currentPage,
              totalPage: newJobList.totalPage,
              hasNextPage: newJobList.hasNextPage,
            ),
            isLoadingMore: false,
          ),
        );
      });
    } catch (e, stack) {
      debugPrint('Load next page error: $e\n$stack');
      emit(LikedJobError(e.toString()));
    }
  }

  Future<void> onDislikeJob(
    RemovingLikedJobs event,
    Emitter<LikedJobBlocState> emit,
  ) async {
    final currentState = state;
    if (currentState is LikedJobLoadedState) {
      try {
        final cpage = currentState.jobs.currentPage;
        final tPage = currentState.jobs.totalPage;
        final hasNext = currentState.jobs.hasNextPage;

        final updatedJobs = currentState.jobs.likedJob
            .where((job) => job.jobId != event.jobId)
            .toList();

        emit(
          LikedJobLoadedState(
            jobs: LikedListJob(
              likedJob: updatedJobs,
              currentPage: cpage,
              totalPage: tPage,
              hasNextPage: hasNext,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(LikedJobError(e.toString()));
      }
    }
  }
}
