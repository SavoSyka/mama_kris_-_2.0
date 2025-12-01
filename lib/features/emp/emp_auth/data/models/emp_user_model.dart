import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_subscription_model.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/data/models/emp_user_profile_model.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';

class EmpUserModel extends EmpUserEntity {
  EmpUserModel({
    required super.userId,
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required super.subscription,
  });

  factory EmpUserModel.fromJson(Map<String, dynamic> json) {
    return EmpUserModel(
      userId: json['userId'].toString(),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: EmpUserProfileModel.fromJson(json['user']),
      subscription: UserSubscriptionModel.fromJson(json['subscription']),
    );
  }
}
