import 'package:bloc/bloc.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/post_job_usecase.dart';

part 'post_job_event.dart';
part 'post_job_state.dart';

class PostJobBloc extends Bloc<PostJobEvent, PostJobState> {
  final PostJobUsecase _postJobUsecase;

  PostJobBloc({required PostJobUsecase postJobUsecase})
      : _postJobUsecase = postJobUsecase,
        super(const PostJobData()) {
    on<PostJobUpdateProfessionEvent>(_onUpdateProfession);
    on<PostJobUpdateDescriptionEvent>(_onUpdateDescription);
    on<PostJobUpdateContactsEvent>(_onUpdateContacts);
    on<PostJobUpdateSalaryEvent>(_onUpdateSalary);
    on<PostJobSubmitEvent>(_onPostJobSubmit);
  }

  void _onUpdateProfession(
    PostJobUpdateProfessionEvent event,
    Emitter<PostJobState> emit,
  ) {
    if (state is PostJobData) {
      final currentData = state as PostJobData;
      emit(currentData.copyWith(profession: event.profession));
    }
  }

  void _onUpdateDescription(
    PostJobUpdateDescriptionEvent event,
    Emitter<PostJobState> emit,
  ) {
    if (state is PostJobData) {
      final currentData = state as PostJobData;
      emit(currentData.copyWith(description: event.description));
    }
  }

  void _onUpdateContacts(
    PostJobUpdateContactsEvent event,
    Emitter<PostJobState> emit,
  ) {
    if (state is PostJobData) {
      final currentData = state as PostJobData;
      emit(currentData.copyWith(contacts: event.contacts));
    }
  }

  void _onUpdateSalary(
    PostJobUpdateSalaryEvent event,
    Emitter<PostJobState> emit,
  ) {
    if (state is PostJobData) {
      final currentData = state as PostJobData;
      emit(currentData.copyWith(
        salary: event.salary,
        salaryByAgreement: event.salaryByAgreement,
      ));
    }
  }

  Future<void> _onPostJobSubmit(
    PostJobSubmitEvent event,
    Emitter<PostJobState> emit,
  ) async {
    if (state is PostJobData) {
      final data = state as PostJobData;
      if (data.profession == null ||
          data.description == null ||
          data.contacts == null ||
          (data.salary == null && data.salaryByAgreement != true)) {
        emit(const PostJobError(message: 'Please fill all required fields'));
        return;
      }

      emit(PostJobLoading());
      final jobPost = JobPostEntity(
        profession: data.profession!,
        salary: data.salary ?? '',
        description: data.description!,
        contacts: data.contacts!,
        salaryByAgreement: data.salaryByAgreement ?? false,
      );
      final result = await _postJobUsecase(jobPost);

      result.fold(
        (failure) => emit(PostJobError(message: failure.message)),
        (_) => emit(PostJobSuccess()),
      );
    }
  }
}