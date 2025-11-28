// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

import 'package:mama_kris/features/emp/emp_resume/domain/usecases/add_to_hide_usecase%20copy.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/get_hidden_users_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/remove_from_hide_usecase.dart';

part 'hide_resume_event.dart';
part 'hide_resume_state.dart';

class HideResumeBloc extends Bloc<HideResumeEvent, HideResumeState> {
  final GetHiddenUsersUsecase getHiddenUsersUsecase;
  final AddToHideUsecase addToHideUsecase;
  final RemoveFromHideUsecase removeFromHideUsecase;

  HideResumeBloc({
    required this.getHiddenUsersUsecase,
    required this.addToHideUsecase,
    required this.removeFromHideUsecase,
  }) : super(HideResumeInitial()) {
    /// 📌 Fetch hidden users
    on<FetchHiddenUsersEvent>((event, emit) async {
      emit(HideResumeLoading());

      final result = await getHiddenUsersUsecase();

      result.fold(
        (failure) => emit(HideResumeErrorState(failure.message)),
        (hiddenList) => emit(HiddenUsersLoadedState(hiddenUsers: hiddenList)),
      );
    });

    /// 📌 Add a user to the hidden list
    on<AddToHiddenEvent>((event, emit) async {
      emit(HideResumeLoading());

      final result = await addToHideUsecase(
        AddToHideParams(userId: event.userId),
      );

      result.fold(
        (failure) => emit(HideResumeErrorState(failure.message)),
        (_) => emit(AddToHiddenSuccessState()),
      );
    });

    /// 📌 Remove a user from hidden list
    on<RemoveFromHiddenEvent>((event, emit) async {
      emit(HideResumeLoading());

      final result = await removeFromHideUsecase(
        RemoveFromHideParams(userId: event.userId),
      );

      result.fold(
        (failure) => emit(HideResumeErrorState(failure.message)),
        (_) => emit(RemoveFromHiddenSuccessState()),
      );
    });
  }
}
