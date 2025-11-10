import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

class EmpUserEntity {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final EmpUserProfileEntity user;

  EmpUserEntity( {
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
