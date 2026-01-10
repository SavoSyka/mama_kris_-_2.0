import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_payment_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_paymnet_state.dart';
import 'package:mama_kris/features/subscription/domain/usecase/get_tariffs_usecase.dart';
import 'package:mama_kris/features/subscription/domain/usecase/initiate_payment_usecase.dart';

class SubscriptionPaymentBloc
    extends Bloc<SubscriptionPaymentEvent, SubscriptionPaymentState> {
  final InitiatePaymentUsecase initiatePaymentUsecase;

  SubscriptionPaymentBloc({
    required this.initiatePaymentUsecase,
  }) : super(PaymentInitiatingState()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<ResetPaymentStateEvent>(_onResetPaymentState);
  }

  //* ────────────────────── INITIATE PAYMENT ──────────────────────
  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<SubscriptionPaymentState> emit,
  ) async {
    emit(PaymentLoadinState());
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
            emit(const PaymentErrorState('Failed to generate payment URL'));
          }
        },
      );
    } catch (e) {
      emit(PaymentErrorState(e.toString()));
    }
  }

  //* ────────────────────── RESET PAYMENT STATE ──────────────────────
  Future<void> _onResetPaymentState(
    ResetPaymentStateEvent event,
    Emitter<SubscriptionPaymentState> emit,
  ) async {
    emit(PaymentInitiatingState());
  }
}
