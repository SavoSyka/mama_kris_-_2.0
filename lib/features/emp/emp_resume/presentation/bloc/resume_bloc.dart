import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/fetch_resume_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final FetchResumeUsecase fetchResumeUsecase;

  ResumeBloc({required this.fetchResumeUsecase}) : super(ResumeInitialState()) {
    on<FetchResumesEvent>(_onFetchUsers);
    on<LoadNextResumePageEvent>(_onLoadNextUsersPage);
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onFetchUsers(
    FetchResumesEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoadingState());
    try {
      final result = await fetchResumeUsecase(
        FetchResumeParams(page: 1, isFavorite: event.isFavorite),
      );

      result.fold(
        (failure) {
          emit(ResumeErrorState(failure.message));
        },
        (users) {
          emit(ResumeLoadedState(users: users, isLoadingMore: false));
        },
      );
    } catch (e) {
      emit(ResumeErrorState(e.toString()));
    }
  }

  // * ────────────────────── LOAD NEXT PAGE ───────────────────────
  Future<void> _onLoadNextUsersPage(
    LoadNextResumePageEvent event,
    Emitter<ResumeState> emit,
  ) async {
    final currentState = state;

    // ── Guard: already loading or no more pages ─────────────────
    if (currentState is! ResumeLoadedState ||
        currentState.isLoadingMore ||
        currentState.users.currentPage >= currentState.users.totalPages) {
      return;
    }

    // ── Emit "loading more" (keeps old list) ───────────────────
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await fetchResumeUsecase(
        FetchResumeParams(page: event.nextPage, isFavorite: event.isFavorite),
      );
      result.fold((failure) => emit(ResumeErrorState(failure.message)), (
        newUserList,
      ) {
        final updatedUsers = [
          ...currentState.users.resume,
          ...newUserList.resume,
        ];

        emit(
          ResumeLoadedState(
            users: currentState.users.copyWith(
              resume: updatedUsers,
              currentPage: newUserList.currentPage,
              totalPages: newUserList.totalPages,
            ),
            isLoadingMore: false,
          ),
        );
      });
    } catch (e, stack) {
      debugPrint('Load next page error: $e\n$stack');
      emit(ResumeErrorState(e.toString()));
    }
  }
}
