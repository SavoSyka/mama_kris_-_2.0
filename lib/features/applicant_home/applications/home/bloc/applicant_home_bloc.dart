import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/vacancy_entity.dart';
import 'package:mama_kris/features/applicant_home/domain/usecases/get_all_vacancies_usecase.dart';
import 'package:mama_kris/features/applicant_home/domain/usecases/search_combined_usecase.dart';

part 'applicant_home_event.dart';
part 'applicant_home_state.dart';

class ApplicantHomeBloc extends Bloc<ApplicantHomeEvent, ApplicantHomeState> {
  final GetAllVacanciesUsecase _getAllVacanciesUsecase;
  final SearchCombinedUsecase _searchCombinedUsecase;

  ApplicantHomeBloc({required GetAllVacanciesUsecase getAllVacanciesUsecase, required SearchCombinedUsecase searchCombinedUsecase})
    :
     _getAllVacanciesUsecase = getAllVacanciesUsecase,
     _searchCombinedUsecase = searchCombinedUsecase,

      super(ApplicantHomeInitial()) {
    on<ApplicantHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetAllVacancyEvent>(getVacancies);
    on<SearchCombinedEvent>(getCombinedSearch);

  }
  Future<void> getVacancies(
    GetAllVacancyEvent event,
    Emitter<ApplicantHomeState> emit,
  ) async {
    emit(ApplicantHomeLoadingState());
    final result = await _getAllVacanciesUsecase();

    result.fold(
      (failure) {
        emit(ApplicantHomeError(message: failure.message));
      },
      (success) {
        emit(VacancyLoadedState(vacancy: success));
      },
    );
  }

    Future<void> getCombinedSearch(
    SearchCombinedEvent event,
    Emitter<ApplicantHomeState> emit,
  ) async {
    emit(ApplicantHomeLoadingState());
    final result = await _searchCombinedUsecase(event.query);

    result.fold(
      (failure) {
        emit(ApplicantHomeError(message: failure.message));
      },
      (success) {
        emit(VacancyLoadedState(vacancy: success));
      },
    );
  }
}
