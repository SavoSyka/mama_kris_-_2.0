import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

part 'emp_user_event.dart';
part 'emp_user_state.dart';

class EmpUserBloc extends Bloc<UserEvent, EmpUserState> {
  // final GetUserProfileUseCase _getUserProfileUseCase;

  EmpUserBloc() : super(const EmpUserInitial()) {
    on<EmpGetUserProfileEvent>(_onGetUserProfile);
    on<EmpUpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onGetUserProfile(
    EmpGetUserProfileEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    emit(EmpUserLoaded(event.user));
  }

  Future<void> _onUpdateUserProfile(
    EmpUpdateUserProfileEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    emit(const EmpUserUpdating());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    emit(EmpUserUpdated(event.updatedUser));
  }
}
