import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/entity/employee_contact.dart';

part 'emp_user_event.dart';
part 'emp_user_state.dart';

class EmpUserBloc extends Bloc<EmpUserEvent, EmpUserState> {
  // final GetUserProfileUseCase _getUserProfileUseCase;

  EmpUserBloc() : super(const EmpUserInitial()) {
    on<EmpGetUserProfileEvent>(_onGetUserProfile);
    on<EmpUpdateUserProfileEvent>(_onUpdateUserProfile);
    on<EmpAddContactEvent>(_onAddContact);
    on<EmpEditContactEvent>(_onEditContact);
    on<EmpDeleteContactEvent>(_onDeleteContact);
    on<EmpUpdateBasicInfoEvent>(_onUpdateBasicInfo);
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


    // * ───────────── update contacts after create ───────────────────────
  Future<void> _onAddContact(
    EmpAddContactEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    final currentState = state;

    if (currentState is EmpUserLoaded) {
      final List<ContactEntity> updatedContacts = [
        event.newContact,
        ...?currentState.user.contacts,
      ];

      debugPrint(" 🔐🔐🔐🔐 Contact updated");
      emit(EmpUserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 emitted state $state");
    }
  }

  // * ───────────── update contacts after edit ─────────────────────────
  Future<void> _onEditContact(
    EmpEditContactEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    final currentState = state;

    if (currentState is EmpUserLoaded) {
      final updatedContacts = currentState.user.contacts?.map((c) {
        if (c.contactsID == event.updatedContact.contactsID) {
          return event.updatedContact;
        }
        return c;
      }).toList();

      debugPrint(" 🔐🔐🔐🔐 Contact Edited");
      emit(EmpUserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 Edited emitted state $state");
    }
  }

  // * ───────────── update contacts after delete ───────────────────────
  Future<void> _onDeleteContact(
    EmpDeleteContactEvent event,
    Emitter<EmpUserState> emit,
  ) async {
    final currentState = state;

    if (currentState is EmpUserLoaded) {
      final updatedContacts = currentState.user.contacts
          ?.where((c) => c.contactsID != event.contactId)
          .toList();

      debugPrint(" 🔐🔐🔐🔐 Contact Deleted");
      emit(EmpUserLoaded(currentState.user.copyWith(contacts: updatedContacts)));
      debugPrint(" 🔐🔐 Edited Deleted state $state");
    }
  }




// * ───────────── update contacts after edit basic info ─────────────────────────
Future<void> _onUpdateBasicInfo(
  EmpUpdateBasicInfoEvent event,
  Emitter<EmpUserState> emit,
) async {
  final currentState = state;

  if (currentState is EmpUserLoaded) {
    
    // Update user model
    final updatedUser = currentState.user.copyWith(
      name: event.name,
      birthDate: event.dob,
    );

    debugPrint("🔐 Basic Info Updated");

    // Emit new state with updated user
    emit(EmpUserLoaded(updatedUser));

    debugPrint("🔐 Emitted updated user: $state");
  }
}



}
