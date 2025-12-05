import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'life_cycle_manager_event.dart';
part 'life_cycle_manager_state.dart';

class LifeCycleManagerBloc extends Bloc<LifeCycleManagerEvent, LifeCycleManagerState> {
  LifeCycleManagerBloc() : super(LifeCycleManagerInitial()) {
    on<LifeCycleManagerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
