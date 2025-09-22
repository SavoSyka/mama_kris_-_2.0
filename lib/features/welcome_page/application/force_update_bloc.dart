import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_event.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_state.dart';
import 'package:mama_kris/features/welcome_page/domain/usecase/check_force_update_usecase.dart';

class ForceUpdateBloc extends Bloc<ForceUpdateEvent, ForceUpdateState> {
  final CheckForceUpdateUseCase checkForceUpdateUseCase;

  ForceUpdateBloc(this.checkForceUpdateUseCase) : super(ForceUpdateInitial()) {
    on<CheckForceUpdateEvent>(_onCheckForceUpdate);
  }

  Future<void> _onCheckForceUpdate(
    CheckForceUpdateEvent event,
    Emitter<ForceUpdateState> emit,
  ) async {
    emit(ForceUpdateLoading());
    try {
      final result = await checkForceUpdateUseCase(
        versionNumber: event.versionNumber,
        platformType: event.platformType,
      );

      result.fold(
        (failure) {
          emit(ForceUpdateError(failure.message));
        },
        (success) {
          emit(ForceUpdateLoaded(success));
        },
      );
    } catch (e) {
      emit(ForceUpdateError(e.toString()));
    }
  }
}
