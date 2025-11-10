import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/usecase/get_user_data.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  UserBloc({required GetUserProfileUseCase getUserProfileUseCase})
      : _getUserProfileUseCase = getUserProfileUseCase,
        super(const UserInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _getUserProfileUseCase();

    result.fold(
      (failure) => emit(UserError(failure.message ?? 'Something went wrong')),
      (user) => emit(UserLoaded(user)),
    );
  }
}
