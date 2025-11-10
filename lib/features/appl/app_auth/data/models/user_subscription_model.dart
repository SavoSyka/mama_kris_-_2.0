import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/use_subscription.dart';

class UserSubscriptionModel extends UserSubscription {
  UserSubscriptionModel({required super.active, super.type, super.expiresAt});

  factory UserSubscriptionModel.fromJson(DataMap json) {
    return UserSubscriptionModel(
      active: json['active'],
      type: json['type'],
      expiresAt: json['expiresAt'],
    );
  }
}
