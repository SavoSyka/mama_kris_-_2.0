import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/create_applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/delete_applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/get_all_applicant_contacts.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/update_applicant_contact.dart';

part 'applicant_contact_event.dart';
part 'applicant_contact_state.dart';

/// BLoC for managing applicant contacts.
/// Handles create, update, delete, and load operations with reactive state management.
class ApplicantContactBloc
    extends Bloc<ApplicantContactEvent, ApplicantContactState> {
  final CreateApplicantContactUseCase _createUseCase;
  final UpdateApplicantContactUseCase _updateUseCase;
  final DeleteApplicantContactUseCase _deleteUseCase;
  final GetAllApplicantContactsUseCase _getAllUseCase;

  ApplicantContactBloc({
    required CreateApplicantContactUseCase createUseCase,
    required UpdateApplicantContactUseCase updateUseCase,
    required DeleteApplicantContactUseCase deleteUseCase,
    required GetAllApplicantContactsUseCase getAllUseCase,
  }) : _createUseCase = createUseCase,
       _updateUseCase = updateUseCase,
       _deleteUseCase = deleteUseCase,
       _getAllUseCase = getAllUseCase,
       super(const ApplicantContactInitial()) {
    on<LoadApplicantContactsEvent>(_onLoadContacts);
    on<CreateApplicantContactEvent>(_onCreateContact);
    on<UpdateApplicantContactEvent>(_onUpdateContact);
    on<DeleteApplicantContactEvent>(_onDeleteContact);
  }

  Future<void> _onLoadContacts(
    LoadApplicantContactsEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const ApplicantContactLoading());
    final result = await _getAllUseCase();
    result.fold(
      (failure) => emit(ApplicantContactError(failure.message)),
      (contacts) => emit(ApplicantContactLoaded(contacts)),
    );
  }

  Future<void> _onCreateContact(
    CreateApplicantContactEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const ApplicantContactLoading());
    final result = await _createUseCase(event.contact);
    result.fold(
      (failure) => emit(ApplicantContactError(failure.message)),
      (contact) => emit(ApplicantContactCreated(contact)),
    );
  }

  Future<void> _onUpdateContact(
    UpdateApplicantContactEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const ApplicantContactLoading());
    final result = await _updateUseCase(
      UpdateApplicantContactParams(id: event.id, contact: event.contact),
    );
    result.fold(
      (failure) => emit(ApplicantContactError(failure.message)),
      (contact) => emit(ApplicantContactUpdated(contact)),
    );
  }

  Future<void> _onDeleteContact(
    DeleteApplicantContactEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const ApplicantContactLoading());
    final result = await _deleteUseCase(event.id);

    debugPrint("Deleting operation retruned}");

    result.fold(
      (failure) {
        debugPrint("Erro happen  ${failure.message}");
        emit(ApplicantContactError(failure.message));
      },
      (success) {
    debugPrint("Deleting operation succed}");

        emit(const ApplicantContactDeleted());
      },
    );
  }
}
