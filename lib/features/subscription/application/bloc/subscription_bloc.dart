import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_state.dart';
import 'package:mama_kris/features/subscription/domain/usecase/get_tariffs_usecase.dart';
import 'package:mama_kris/features/subscription/domain/usecase/initiate_payment_usecase.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetTariffsUsecase getTariffsUsecase;
  final InitiatePaymentUsecase initiatePaymentUsecase;

  SubscriptionBloc({
    required this.getTariffsUsecase,
    required this.initiatePaymentUsecase,
  }) : super(SubscriptionInitialState()) {
    on<FetchSubscriptionEvent>(_onGetTariffs);
    on<InitiatePaymentEvent>(_onInitiatePayment);
  }

  //* ────────────────────── FETCH FIRST PAGE ──────────────────────
  Future<void> _onGetTariffs(
    FetchSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoadingState());
    try {
      final result = await getTariffsUsecase(
      );

      result.fold(
        (failure) {
          emit(SubscriptionErrorState(failure.message));
        },
        (data) {
          emit(SubscriptionLoadedState(subscriptions: data ));
        },
      );
    } catch (e) {
      emit(SubscriptionErrorState(e.toString()));
    }
  }

  //* ────────────────────── INITIATE PAYMENT ──────────────────────
  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(PaymentInitiatingState());
    try {
      final result = await initiatePaymentUsecase(event.tariff);

      result.fold(
        (failure) {
          emit(PaymentErrorState(failure.message));
        },
        (paymentUrl) {
          if (paymentUrl != null) {
            emit(PaymentInitiatedState(paymentUrl: paymentUrl));
          } else {
            emit(PaymentErrorState('Failed to generate payment URL'));
          }
        },
      );
    } catch (e) {
      emit(PaymentErrorState(e.toString()));
    }
  }

}
