import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/get_public_counts.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_state.dart';

class PublicCountsBloc extends Bloc<PublicCountsEvent, PublicCountsState> {
  final GetPublicCounts getPublicCounts;

  PublicCountsBloc({required this.getPublicCounts})
      : super(PublicCountsInitial()) {
    on<FetchPublicCountsEvent>(_onFetchPublicCounts);
  }

  Future<void> _onFetchPublicCounts(
    FetchPublicCountsEvent event,
    Emitter<PublicCountsState> emit,
  ) async {
    emit(PublicCountsLoading());

    final result = await getPublicCounts();

    result.fold(
      (failure) => emit(PublicCountsError(failure.message)),
      (counts) => emit(PublicCountsLoaded(counts)),
    );
  }
}
