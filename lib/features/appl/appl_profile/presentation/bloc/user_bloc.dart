import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<AddContactEvent>(_onAddContact);
    on<EditContactEvent>(_onEditContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<UpdateWorkExperienceEvent>(_onUpdateWork);

    on<UpdateBasicInfo>(_onUpdateBasicInfo);
    on<UpdateSpecialityInfo>(_onUpdateSpeciality);
    on<UpdateAcceptOrdersEvent>(_onUpdateAcceptOrders);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoaded(event.user));
  }

  // * ───────────── update contacts after create ───────────────────────
  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      final List<ApplContactEntity> updatedContacts = [
        event.newContact,
        ...?currentState.user.contacts,
      ];

      debugPrint(" 🔐🔐🔐🔐 Contact updated");
      emit(UserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 emitted state $state");
    }
  }

  // * ───────────── update contacts after edit ─────────────────────────
  Future<void> _onEditContact(
    EditContactEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      final updatedContacts = currentState.user.contacts?.map((c) {
        if (c.contactsID == event.updatedContact.contactsID) {
          return event.updatedContact;
        }
        return c;
      }).toList();

      debugPrint(" 🔐🔐🔐🔐 Contact Edited");
      emit(UserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 Edited emitted state $state");
    }
  }

  // * ───────────── update contacts after delete ───────────────────────
  Future<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      final updatedContacts = currentState.user.contacts
          ?.where((c) => c.contactsID != event.contactId)
          .toList();

      debugPrint(" 🔐🔐🔐🔐 Contact Deleted");
      emit(UserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 Edited Deleted state $state");
    }
  }

  Future<void> _onUpdateWork(
    UpdateWorkExperienceEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      debugPrint(" 🔐🔐🔐🔐 Contact updated");
      emit(
        UserLoaded(currentState.user.copyWith(workExperience: event.updated)),
      );
      debugPrint(" 🔐🔐 emitted state $state");
    }
  }

  // * ───────────── update contacts after edit basic info ─────────────────────────
  Future<void> _onUpdateBasicInfo(
    UpdateBasicInfo event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      // Update user model
      final updatedUser = currentState.user.copyWith(
        name: event.name,
        birthDate: event.dob,
      );

      debugPrint("🔐 Basic Info Updated");

      // Emit new state with updated user
      emit(UserLoaded(updatedUser));

      debugPrint("🔐 Emitted updated user: $updatedUser");
    }
  }
  // * ───────────── Update Specility Info ─────────────────────────

  Future<void> _onUpdateSpeciality(
    UpdateSpecialityInfo event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      // Update user model
      final updatedUser = currentState.user.copyWith(
        specializations: event.speciality,
      );

      emit(UserLoaded(updatedUser));

      debugPrint("🔐 Emitted updated user: $state");
    }
  }

  // * ───────────── Update Accept Orders ─────────────────────────

  Future<void> _onUpdateAcceptOrders(
    UpdateAcceptOrdersEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState is UserLoaded) {
      final updatedUser = currentState.user.copyWith(
        acceptOrders: event.acceptOrders,
      );

      emit(UserLoaded(updatedUser));

      debugPrint("🔐 Accept Orders Updated: ${event.acceptOrders}");
    }
  }
}
