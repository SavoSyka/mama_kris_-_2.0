import 'package:flutter/material.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.tariffID,
    required super.price,
    required super.type,
    required super.paidContent,
    required super.name,
    required super.pricePerMonth,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    debugPrint("json figuring out where it failed");
    return SubscriptionModel(
      tariffID: json['tariffID'] as int,
      price: json['price'] as String,
      type: json['type'] as String,
      paidContent: json['paidСontent'] as String, // Note: “С” is Cyrillic
      name: json['name'] as String,
      pricePerMonth: json['pricePerMonth'].toString(),
    );
  }
}
