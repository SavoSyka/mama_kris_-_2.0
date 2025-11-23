import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/fetch_favorited_users_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/fetch_resume_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/get_public_profiles_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/like_resume_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final FetchResumeUsecase fetchResumeUsecase;
  final LikeResumeUsecase likeResumeUsecase;

  final FetchFavoritedUsersUsecase fetchFavoritedUsersUsecase;

  ResumeBloc({
    required this.fetchResumeUsecase,
    required this.likeResumeUsecase,
    required this.fetchFavoritedUsersUsecase,
  }) : super(ResumeInitialState()) {
    on<FetchResumesEvent>(_onFetchUsers);
    on<LoadNextResumePageEvent>(_onLoadNextUsersPage);

    on<FetchFavoritedResumesEvent>(_onFetchFavoriteUsers);
    on<LoadNextFavoritedResumePageEvent>(_onLoadNextFavoriteUsersPage);

    on<UpdateFavoritingEvent>(_onUpdatingFavorite);
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onFetchUsers(
    FetchResumesEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoadingState());
    try {
      final result = await fetchResumeUsecase(
        FetchResumeParams(page: 1, searchQuery: event.searchQuery),
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
        FetchResumeParams(page: event.nextPage),
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

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onFetchFavoriteUsers(
    FetchFavoritedResumesEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoadingState());
    try {
      final result = await fetchFavoritedUsersUsecase(
        FetchFavoritedResumeParams(page: 1, searchQuery: event.searchQuery),
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
  Future<void> _onLoadNextFavoriteUsersPage(
    LoadNextFavoritedResumePageEvent event,
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
      final result = await fetchFavoritedUsersUsecase(
        FetchFavoritedResumeParams(page: event.nextPage),
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

  // * ────────────────────── LOAD NEXT PAGE ───────────────────────
  Future<void> _onUpdatingFavorite(
    UpdateFavoritingEvent event,
    Emitter<ResumeState> emit,
  ) async {
    final currentState = state;

    try {
      final result = await likeResumeUsecase(
        LikedResumeParams(userId: event.userId, isFavorited: event.isFavorited),
      );

      result.fold((failure) => emit(ResumeErrorState(failure.message)), (_) {});
    } catch (e, stack) {
      debugPrint('Favorite update error: $e\n$stack');
      emit(ResumeErrorState(e.toString()));
    }
  }
}
