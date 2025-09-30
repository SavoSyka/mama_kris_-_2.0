import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/get_all_posted_job_usecase.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/post_job_usecase.dart';

part 'get_job_event.dart';
part 'get_job_state.dart';

class PostJobBloc extends Bloc<GetJobEvent, GetJobState> {
  final GetAllPostedJobUsecase _allPostedJobUsecase;

  PostJobBloc({required GetAllPostedJobUsecase allPostedJobUsecase})
    : _allPostedJobUsecase = allPostedJobUsecase,
      super(GetJobInitial()) {
    on<GetEmployeJobEvent>(_onGetJobSubmit);
  }

  Future<void> _onGetJobSubmit(
    GetEmployeJobEvent event,
    Emitter<GetJobState> emit,
  ) async {
    emit(GetJobLoading());

    final result = await _allPostedJobUsecase(event.type);

    result.fold(
      (failure) => emit(GetJobError(message: failure.message)),
      (_) => emit(GetJobSuccess()),
    );
  }
}
