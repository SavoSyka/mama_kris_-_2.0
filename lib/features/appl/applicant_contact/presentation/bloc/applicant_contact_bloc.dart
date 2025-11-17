import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/create_applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/delete_applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/delete_user_account_usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/get_all_applicant_contacts.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/update_applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/update_basic_info_usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/update_work_experience_usecase.dart';

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
  final UpdateWorkExperienceUseCase _updateWorkExperienceUseCase;

  final DeleteUserAccountUsecase _deleteUserAccountUsecase;
  final UpdateBasicInfoUsecase _basicInfoUsecase;
  ApplicantContactBloc({
    required CreateApplicantContactUseCase createUseCase,
    required UpdateApplicantContactUseCase updateUseCase,
    required DeleteApplicantContactUseCase deleteUseCase,
    required GetAllApplicantContactsUseCase getAllUseCase,
    required UpdateWorkExperienceUseCase updateWorkExperienceUseCase,
    required DeleteUserAccountUsecase deleteUserAccountUsecase,
    required UpdateBasicInfoUsecase basicInfoUsecase,
  }) : _createUseCase = createUseCase,
       _updateUseCase = updateUseCase,
       _deleteUseCase = deleteUseCase,
       _getAllUseCase = getAllUseCase,
       _updateWorkExperienceUseCase = updateWorkExperienceUseCase,
       _deleteUserAccountUsecase = deleteUserAccountUsecase,
       _basicInfoUsecase = basicInfoUsecase,
       super(const ApplicantContactInitial()) {
    on<LoadApplicantContactsEvent>(_onLoadContacts);
    on<CreateApplicantContactEvent>(_onCreateContact);
    on<UpdateApplicantContactEvent>(_onUpdateContact);
    on<DeleteApplicantContactEvent>(_onDeleteContact);
    on<UpdateApplicantExperience>(_onUpdateWorkExperience);
    on<DeleteUserAccountEvent>(_onDeleteAccount);
    on<UpdatingBasicInfoEvent>(_onUpdateBasicInfo);
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

  Future<void> _onUpdateWorkExperience(
    UpdateApplicantExperience event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const ApplicantContactLoading());
    final result = await _updateWorkExperienceUseCase(event.experience);

    debugPrint("Udating work expereinces");

    result.fold(
      (failure) {
        debugPrint("Erro happen  ${failure.message}");
        emit(ApplicantContactError(failure.message));
      },
      (success) {
        debugPrint("Deleting operation succed}");

        emit(const ApplicantWorkExpereinceUpdated());
      },
    );
  }

  Future<void> _onDeleteAccount(
    DeleteUserAccountEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    emit(const AccountDeleteLoadingState());

    Future.delayed(const Duration(seconds: 1));
    final result = await _deleteUserAccountUsecase();

    debugPrint("Deleting  User Account");

    result.fold(
      (failure) {
        debugPrint("Erro happen  ${failure.message}");
        emit(ApplicantContactError(failure.message));
      },
      (success) {
        debugPrint("Deleting operation succed}");

        emit(const UserAccountDeleted());
      },
    );
  }

  Future<void> _onUpdateBasicInfo(
    UpdatingBasicInfoEvent event,
    Emitter<ApplicantContactState> emit,
  ) async {
    debugPrint("error");
    emit(const ApplicantContactLoading());

    Future.delayed(const Duration(microseconds: 200));
    final result = await _basicInfoUsecase(
      UpdateBasicInfoParams(name: event.name, dob: event.dob),
    );

    debugPrint("Updating  User Account name and dob");

    result.fold(
      (failure) {
        debugPrint("Erro happen in updating name and dob  ${failure.message}");
        emit(ApplicantContactError(failure.message));
      },
      (success) {
        debugPrint("updating name operation succed}");

        emit(const UserBasicInfoUpdated());
      },
    );
  }
}
