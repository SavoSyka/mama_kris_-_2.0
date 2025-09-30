import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/post_job_usecase.dart';

part 'post_job_event.dart';
part 'post_job_state.dart';

class PostJobBloc extends Bloc<PostJobEvent, PostJobState> {
  final PostJobUsecase _postJobUsecase;

  PostJobBloc({required PostJobUsecase postJobUsecase})
      : _postJobUsecase = postJobUsecase,
        super(PostJobInitial()) {
    on<PostJobSubmitEvent>(_onPostJobSubmit);
  }

  Future<void> _onPostJobSubmit(
    PostJobSubmitEvent event,
    Emitter<PostJobState> emit,
  ) async {
    emit(PostJobLoading());
    final jobPost = JobPostEntity(
      profession: event.profession,
      salary: event.salary,
      description: event.description,
    );
    final result = await _postJobUsecase(jobPost);

    result.fold(
      (failure) => emit(PostJobError(message: failure.message)),
      (_) => emit(PostJobSuccess()),
    );
  }
}