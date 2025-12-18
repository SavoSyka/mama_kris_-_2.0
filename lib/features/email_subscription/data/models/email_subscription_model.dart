import 'package:mama_kris/features/email_subscription/domain/entities/email_subscription_entity.dart';

class EmailSubscriptionModel extends EmailSubscriptionEntity {
  EmailSubscriptionModel({
    required super.email,
    required super.isSubscribed,
  });

  factory EmailSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return EmailSubscriptionModel(
      email: json['email'] as String? ?? '',
      isSubscribed: json['isSubscribed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isSubscribed': isSubscribed,
    };
  }
}
