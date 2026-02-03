import 'package:mama_kris/features/appl/app_auth/domain/entities/use_subscription.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

class EmpUserEntity {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final EmpUserProfileEntity user;
  final UserSubscription subscription;

  EmpUserEntity({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.subscription,
  });
}
