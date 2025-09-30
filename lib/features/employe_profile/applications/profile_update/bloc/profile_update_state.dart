part of 'profile_update_bloc.dart';

abstract class ProfileUpdateState {
  const ProfileUpdateState();
}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateSuccess extends ProfileUpdateState {}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;

  const ProfileUpdateError({required this.message});
}