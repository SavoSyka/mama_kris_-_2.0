import 'package:equatable/equatable.dart';

abstract class Tariffsevent extends Equatable {
  const Tariffsevent();

  @override
  List<Object> get props => [];
}

class FetchTariffsEvent extends Tariffsevent {
  const FetchTariffsEvent();
}
