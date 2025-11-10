import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final int tariffID;
  final String price;
  final String type;
  final String paidContent;
  final String name;

  const SubscriptionEntity({
    required this.tariffID,
    required this.price,
    required this.type,
    required this.paidContent,
    required this.name,
  });

  @override
  List<Object?> get props => [tariffID, price, type, paidContent, name];
}
