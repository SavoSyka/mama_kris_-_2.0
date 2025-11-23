import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class Tariffsevent extends Equatable {
  const Tariffsevent();

  @override
  List<Object> get props => [];
}

class FetchTariffsEvent extends Tariffsevent {
  const FetchTariffsEvent();
}
