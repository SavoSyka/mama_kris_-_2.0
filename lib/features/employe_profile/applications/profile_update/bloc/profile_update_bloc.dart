import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/about_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_verification_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/password_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/usecases/update_about_usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/usecases/update_contacts_usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/usecases/update_email_usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/usecases/update_password_usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/usecases/verify_email_usecase.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final UpdateEmailUsecase _updateEmailUsecase;
  final VerifyEmailUsecase _verifyEmailUsecase;
  final UpdateContactsUsecase _updateContactsUsecase;
  final UpdatePasswordUsecase _updatePasswordUsecase;
  final UpdateAboutUsecase _updateAboutUsecase;

  ProfileUpdateBloc({
    required UpdateEmailUsecase updateEmailUsecase,
    required VerifyEmailUsecase verifyEmailUsecase,
    required UpdateContactsUsecase updateContactsUsecase,
    required UpdatePasswordUsecase updatePasswordUsecase,
    required UpdateAboutUsecase updateAboutUsecase,
  })  : _updateEmailUsecase = updateEmailUsecase,
        _verifyEmailUsecase = verifyEmailUsecase,
        _updateContactsUsecase = updateContactsUsecase,
        _updatePasswordUsecase = updatePasswordUsecase,
        _updateAboutUsecase = updateAboutUsecase,
        super(ProfileUpdateInitial()) {
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<UpdateContactsEvent>(_onUpdateContacts);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdateAboutEvent>(_onUpdateAbout);
  }

  Future<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());
    final result = await _updateEmailUsecase(EmailUpdateEntity(email: event.email));
    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());
    final result = await _verifyEmailUsecase(EmailVerificationEntity(otp: event.otp));
    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }

  Future<void> _onUpdateContacts(
    UpdateContactsEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());
 
    final result = await _updateContactsUsecase(event.contacts);
    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());
    final result = await _updatePasswordUsecase(PasswordUpdateEntity(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }

  Future<void> _onUpdateAbout(
    UpdateAboutEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());
    final result = await _updateAboutUsecase(AboutUpdateEntity(description: event.description));
    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }
}