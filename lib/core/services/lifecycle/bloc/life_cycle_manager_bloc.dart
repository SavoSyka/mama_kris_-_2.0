import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/lifecycle/domain/usecase/user_entered_usecase.dart';
import 'package:mama_kris/core/services/lifecycle/domain/usecase/user_left_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

part 'life_cycle_manager_event.dart';
part 'life_cycle_manager_state.dart';

class LifeCycleManagerBloc
    extends Bloc<LifeCycleManagerEvent, LifeCycleManagerState> {
  final UserEnteredUsecase userEnteredUsecase;
  final UserLeftUsecase userLeftUsecase;

  LifeCycleManagerBloc({
    required this.userEnteredUsecase,
    required this.userLeftUsecase,
  }) : super(LifeCycleManagerInitial()) {
    on<EndUserSessionEvent>(_onSessionEnded);
    on<StartUserSessionEvent>(_onSessionStarted);
  }

  Future<void> _onSessionEnded(
    EndUserSessionEvent event,
    Emitter<LifeCycleManagerState> emit,
  ) async {
    emit(LifeCycleManagerLoadingState());
    final result = await userLeftUsecase(
      UserLeftParams(endDate: event.endDate, sessionId: event.sessionId),
    );

    result.fold(
      (failure) => emit(LifeCycleManagerErrorState()),
      (user) => emit(const LifeCycleManagerEndedState()),
    );
  }

  Future<void> _onSessionStarted(
    StartUserSessionEvent event,
    Emitter<LifeCycleManagerState> emit,
  ) async {
    emit(LifeCycleManagerLoadingState());
    final result = await userEnteredUsecase(
      UserEnteredParams(startDate: event.startDate),
    );

    result.fold(
      (failure) => emit(LifeCycleManagerErrorState()),
      (session) {
        // Save session ID to local storage for later use when app closes
        sl<AuthLocalDataSource>().saveSessionId(session);
        emit(LifeCycleManagerStartedState(sessionId: session));
      },
    );
  }
}
