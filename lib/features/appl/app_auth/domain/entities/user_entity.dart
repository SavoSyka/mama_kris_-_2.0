import 'package:mama_kris/features/appl/app_auth/domain/entities/use_subscription.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';

class   UserEntity {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final UserProfileEntity user;
  final UserSubscription subscription;
  UserEntity({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.subscription,
  });
}
