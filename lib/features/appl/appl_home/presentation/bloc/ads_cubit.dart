import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/domain/usecases/fetch_ads_usecase.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final FetchAdsUseCase fetchAdsUseCase;

  AdsCubit({required this.fetchAdsUseCase}) : super(AdsInitial());

  Future<void> fetchAds() async {
    emit(AdsLoading());
    try {
      final result = await fetchAdsUseCase();

      debugPrint("Sfter addddds");

      result.fold(
        (failure) {
          debugPrint("Erro ❌❌❌❌❌ of ads $failure");

          emit(AdsError(failure.message));
        },
        (ad) {
          debugPrint("🔥success of ads");
          emit(AdsLoaded(ad: ad));
        },
      );
    } catch (e) {
      debugPrint("Sfter addddds error");

      emit(AdsError(e.toString()));
    }
  }
}
