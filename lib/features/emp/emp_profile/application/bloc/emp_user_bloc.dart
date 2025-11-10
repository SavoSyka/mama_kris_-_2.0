import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

part 'emp_user_event.dart';
part 'emp_user_state.dart';

class EmpUserBloc extends Bloc<UserEvent, EmpUserState> {
  // final GetUserProfileUseCase _getUserProfileUseCase;

  EmpUserBloc() : super(const EmpUserInitial()) {
    on<EmpGetUserProfileEvent>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
    EmpGetUserProfileEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    emit(EmpUserLoaded(event.user));
  }
}
