import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/search_history_local_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/get_public_profiles_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/search_speciality_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_state.dart';

class SpecialitySearchBloc
    extends Bloc<SpecialitySearchEvent, SpecialitySearchState> {
  final SearchSpecialityUsecase searchSpecialityUsecase;
  final SearchHistoryLocalDataSource searchHistoryDataSource;
  Timer? _debounce;

  final GetPublicProfilesUsecase getPublicProfilesUsecase;

  SpecialitySearchBloc({
    required this.searchSpecialityUsecase,
    required this.getPublicProfilesUsecase,
    required this.searchHistoryDataSource,
  }) : super(SpecialitySearchInitial()) {
    on<SearchSpecialitiesEvent>(_onSearchSpecialities);
    on<ClearSearchEvent>(_onClearSearch);
    on<GetUserPublicProfileEvent>(_onGetUserProfile);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<LoadNextSpecialityPageEvent>(_onLoadNextJob);
  }

  Future<void> _onSearchSpecialities(
    SearchSpecialitiesEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    // if (event.query.isEmpty) {
    //   emit(const SpecialitySearchLoaded(specialities: []));
    //   return;
    // }

    // if (state is SpecialitySearchLoading) {
    //   return;
    //   // emit(const SpecialitySearchLoaded(specialities: []));
    // }

    emit(SpecialitySearchLoading());

    try {
      final result = await searchSpecialityUsecase(
        SearchSpecialityParams(query: event.query, page: 1),
      );

      result.fold(
        (failure) => emit(SpecialitySearchError(message: failure.message)),
        (specialities) {
          emit(
            SpecialitySearchLoaded(
              specialities: specialities,
              isLoadingMore: false,
            ),
          );
          // Save search query asynchronously without blocking
          if (event.query.isNotEmpty) {
            searchHistoryDataSource.saveSearchQuery(event.query);
          }
        },
      );
    } catch (e) {
      emit(SpecialitySearchError(message: e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    // emit(const SpecialitySearchLoaded(specialities: []));
  }

  void searchWithDebounce(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      add(SearchSpecialitiesEvent(query: query));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onGetUserProfile(
    GetUserPublicProfileEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    try {
      emit(SpecialitySearchLoading());
      final result = await getPublicProfilesUsecase(event.userId);

      result.fold(
        (failure) => emit(SpecialitySearchError(message: failure.message)),
        (success) {
          emit(LoadedPublicPofileState(user: success));
        },
      );
    } catch (e, stack) {
      debugPrint('Favorite update error: $e\n$stack');
      emit(SpecialitySearchError(message: e.toString()));
    }
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    try {
      final history = await searchHistoryDataSource.getSearchHistory();
      emit(SearchHistoryLoaded(searchHistory: history));
    } catch (e) {
      debugPrint('Error loading search history: $e');
      emit(const SearchHistoryLoaded(searchHistory: []));
    }
  }

  // * ────────────────────── LOAD NEXT PAGE ───────────────────────
  Future<void> _onLoadNextJob(
    LoadNextSpecialityPageEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    final currentState = state;

    // ── Guard: already loading or no more pages ─────────────────
    if (currentState is! SpecialitySearchLoaded ||
        currentState.isLoadingMore ||
        !currentState.specialities.hasNextPage) {
      return;
    }

    // ── Emit “loading more” (keeps old list) ───────────────────
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await searchSpecialityUsecase(
        SearchSpecialityParams(query: event.query, page: event.nextPage),
      );
      result.fold(
        (failure) => emit(SpecialitySearchError(message: failure.message)),
        (newJobList) {
          final updatedJobs = [
            ...currentState.specialities.jobs,
            ...newJobList.jobs,
          ];

          emit(
            SpecialitySearchLoaded(
              specialities: currentState.specialities.copyWith(
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
    } catch (e, stack) {
      debugPrint('Load next page error: $e\n$stack');
      emit(SpecialitySearchError(message: e.toString()));
    }
  }
}
