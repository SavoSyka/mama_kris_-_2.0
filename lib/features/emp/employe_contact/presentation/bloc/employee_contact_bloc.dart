import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/entity/employee_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/usecase/create_employee_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/usecase/delete_employee_account_usecase.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/usecase/delete_employee_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/usecase/update_employee_basic_info_usecase.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/usecase/update_employee_contact.dart';

part 'employee_contact_event.dart';
part 'employee_contact_state.dart';

/// BLoC for managing applicant contacts.
/// Handles create, update, delete, and load operations with reactive state management.
/// 
class EmployeeContactBloc
    extends Bloc<EmployeeContactEvent, EmployeeContactState> {
      
  final CreateEmployeeContact _createUseCase;
  final UpdateEmployeeContact _updateUseCase;
  final DeleteEmployeeContact _deleteUseCase;

  final DeleteEmployeeAccountUsecase _deleteUserAccountUsecase;
  final UpdateEmployeeBasicInfoUsecase _basicInfoUsecase;

  EmployeeContactBloc({
    required CreateEmployeeContact createUseCase,
    required UpdateEmployeeContact updateUseCase,
    required DeleteEmployeeContact deleteUseCase,
    required DeleteEmployeeAccountUsecase deleteUserAccountUsecase,
    required UpdateEmployeeBasicInfoUsecase basicInfoUsecase,
  }) : _createUseCase = createUseCase,
       _updateUseCase = updateUseCase,
       _deleteUseCase = deleteUseCase,
       _deleteUserAccountUsecase = deleteUserAccountUsecase,
       _basicInfoUsecase = basicInfoUsecase,
       super(const EmployeeContactInitial()) {
    on<CreateEmployeeContactEvent>(_onCreateContact);
    on<UpdateEmployeeContactEvent>(_onUpdateContact);
    on<DeleteEmployeeContactEvent>(_onDeleteContact);
    on<DeleteUserAccountEvent>(_onDeleteAccount);
    on<UpdatingBasicInfoEvent>(_onUpdateBasicInfo);
  }



  Future<void> _onCreateContact(
    CreateEmployeeContactEvent event,
    Emitter<EmployeeContactState> emit,
  ) async {
    emit(const EmployeeContactLoading());
    final result = await _createUseCase(event.contact);
    result.fold(
      (failure) => emit(EmployeeContactError(failure.message)),
      (contact) => emit(EmployeeContactCreated(contact)),
    );
  }

  Future<void> _onUpdateContact(
    UpdateEmployeeContactEvent event,
    Emitter<EmployeeContactState> emit,
  ) async {
    emit(const EmployeeContactLoading());
    final result = await _updateUseCase(
      UpdateEmployeeContactParams(id: event.id, contact: event.contact),
    );
    result.fold(
      (failure) => emit(EmployeeContactError(failure.message)),
      (contact) => emit(EmployeeContactUpdated(contact)),
    );
  }

  Future<void> _onDeleteContact(
    DeleteEmployeeContactEvent event,
    Emitter<EmployeeContactState> emit,
  ) async {
    emit(const EmployeeContactLoading());
    final result = await _deleteUseCase(event.id);

    debugPrint("Deleting operation retruned}");

    result.fold(
      (failure) {
        debugPrint("Erro happen  ${failure.message}");
        emit(EmployeeContactError(failure.message));
      },
      (success) {
        debugPrint("Deleting operation succed}");

        emit(const EmployeeContactDeleted());
      },
    );
  }


  Future<void> _onDeleteAccount(
    DeleteUserAccountEvent event,
    Emitter<EmployeeContactState> emit,
  ) async {
    emit(const AccountDeleteLoadingState());

    Future.delayed(const Duration(seconds: 1));
    final result = await _deleteUserAccountUsecase();

    debugPrint("Deleting  User Account");

    result.fold(
      (failure) {
        debugPrint("Erro happen  ${failure.message}");
        emit(EmployeeContactError(failure.message));
      },
      (success) {
        debugPrint("Deleting operation succed}");

        emit(const UserAccountDeleted());
      },
    );
  }

  Future<void> _onUpdateBasicInfo(
    UpdatingBasicInfoEvent event,
    Emitter<EmployeeContactState> emit,
  ) async {
    debugPrint("error");
    emit(const EmployeeContactLoading());

    Future.delayed(const Duration(microseconds: 200));
    final result = await _basicInfoUsecase(
      UpdateEmpBasicInfoParams(name: event.name, dob: event.dob),
    );

    debugPrint("Updating  User Account name and dob");

    result.fold(
      (failure) {
        debugPrint("Erro happen in updating name and dob  ${failure.message}");
        emit(EmployeeContactError(failure.message));
      },
      (success) {
        debugPrint("updating name operation succed}");

        emit(const UserBasicInfoUpdated());
      },
    );
  }
}
