import 'package:mama_kris/features/appl/app_auth/data/models/user_subscription_model.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required super.subscription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'].toString(),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserProfileModel.fromJson(json['user']),
      subscription: UserSubscriptionModel.fromJson(json['subscription']),
    );
  }
}
