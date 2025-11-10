import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/fetch_resume_usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_state.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_state.dart';
import 'package:mama_kris/features/subscription/domain/usecase/get_tariffs_usecase.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetTariffsUsecase getTariffsUsecase;

  SubscriptionBloc({required this.getTariffsUsecase}) : super(SubscriptionInitialState()) {
    on<FetchSubscriptionEvent>(_onGetTariffs);
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

}
