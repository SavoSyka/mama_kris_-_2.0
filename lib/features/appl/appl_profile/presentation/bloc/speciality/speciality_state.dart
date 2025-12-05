part of 'speciality_bloc.dart';

class SpecialityState {
  final List<String> suggestions;
  final List<String> selected;
  final bool loading;
  final String? error;

  SpecialityState({
    this.suggestions = const [],
    this.selected = const [],
    this.loading = false,
    this.error,
  });

  SpecialityState copyWith({
    List<String>? suggestions,
    List<String>? selected,
    bool? loading,
    String? error,
  }) {
    return SpecialityState(
      suggestions: suggestions ?? this.suggestions,
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
