import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/search_speciality_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_state.dart';

class SpecialitySearchBloc extends Bloc<SpecialitySearchEvent, SpecialitySearchState> {
  final SearchSpecialityUsecase searchSpecialityUsecase;
  Timer? _debounce;

  SpecialitySearchBloc({required this.searchSpecialityUsecase})
      : super(SpecialitySearchInitial()) {
    on<SearchSpecialitiesEvent>(_onSearchSpecialities);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchSpecialities(
    SearchSpecialitiesEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SpecialitySearchLoaded(specialities: []));
      return;
    }

    emit(SpecialitySearchLoading());

    try {
      final result = await searchSpecialityUsecase(
        SearchSpecialityParams(query: event.query),
      );

      result.fold(
        (failure) => emit(SpecialitySearchError(message: failure.message)),
        (specialities) => emit(SpecialitySearchLoaded(specialities: specialities)),
      );
    } catch (e) {
      emit(SpecialitySearchError(message: e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SpecialitySearchState> emit,
  ) async {
    emit(SpecialitySearchLoaded(specialities: []));
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
}