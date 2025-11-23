import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/subscription/application/bloc/TariffsEvent.dart';
import 'package:mama_kris/features/subscription/application/bloc/TariffsState.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_payment_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_paymnet_state.dart';
import 'package:mama_kris/features/subscription/domain/usecase/get_tariffs_usecase.dart';
import 'package:mama_kris/features/subscription/domain/usecase/initiate_payment_usecase.dart';

class TarriffsBloc extends Bloc<Tariffsevent, Tariffsstate> {
  final GetTariffsUsecase getTariffsUsecase;

  TarriffsBloc({required this.getTariffsUsecase})
    : super(TariffsInitialState()) {
    on<FetchTariffsEvent>(_onGetTariffs);
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onGetTariffs(
    FetchTariffsEvent event,
    Emitter<Tariffsstate> emit,
  ) async {
    emit(TariffsLoadingState());
    try {
      final result = await getTariffsUsecase();

      result.fold(
        (failure) {
          emit(TariffsErrorState(failure.message));
        },
        (data) {
          emit(TariffsLoadedState(subscriptions: data));
        },
      );
    } catch (e) {
      emit(TariffsErrorState(e.toString()));
    }
  }
}
