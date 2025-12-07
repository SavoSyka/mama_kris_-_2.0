import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/usecase/get_speciality_usecase.dart';

part 'speciality_event.dart';
part 'speciality_state.dart';

class SpecialityBloc extends Bloc<SpecialityEvent, SpecialityState> {
  final GetSpecialityListUsecase getSpecialityList;

  SpecialityBloc(this.getSpecialityList) : super(SpecialityState()) {
    on<SearchSpecialityEvent>(_onSearch);
    on<AddSpecialityEvent>(_onAdd);
    on<RemoveSpecialityEvent>(_onRemove);
  }

  Future<void> _onSearch(
    SearchSpecialityEvent event,
    Emitter<SpecialityState> emit,
  ) async {
    // if (event.query.isEmpty) {
    //   emit(state.copyWith(suggestions: []));
    //   return;
    // }

    emit(state.copyWith(loading: true));

    final result = await getSpecialityList(event.query);

    result.fold(
      (error) => emit(state.copyWith(
        loading: false,
        error: error.message,
      )),
      (list) {
        final filtered = list
            .where((item) => !state.selected.contains(item))
            .toList();

        emit(state.copyWith(
          loading: false,
          suggestions: filtered,
        ));
      },
    );
  }

  void _onAdd(AddSpecialityEvent event, Emitter<SpecialityState> emit) {
    final updatedSelected = List<String>.from(state.selected)
      ..add(event.speciality);

    final updatedSuggestions = List<String>.from(state.suggestions)
      ..remove(event.speciality);

    emit(state.copyWith(
      selected: updatedSelected,
      suggestions: updatedSuggestions,
    ));
  }

  void _onRemove(RemoveSpecialityEvent event, Emitter<SpecialityState> emit) {
    final updatedSelected = List<String>.from(state.selected)
      ..remove(event.speciality);

    emit(state.copyWith(selected: updatedSelected));
  }
}

