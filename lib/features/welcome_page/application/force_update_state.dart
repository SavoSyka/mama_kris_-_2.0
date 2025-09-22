import 'package:mama_kris/features/welcome_page/domain/entity/force_update.dart';

abstract class ForceUpdateState {}

class ForceUpdateInitial extends ForceUpdateState {}

class ForceUpdateLoading extends ForceUpdateState {}

class ForceUpdateLoaded extends ForceUpdateState {
  final ForceUpdate data;
  ForceUpdateLoaded(this.data);
}

class ForceUpdateError extends ForceUpdateState {
  final String message;
  ForceUpdateError(this.message);
}
