import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/create_job_params.dart';
import 'package:mama_kris/features/emp/emp_home/domain/usecases/create_job_usecase.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/create_job_state.dart';

class CreateJobCubit extends Cubit<CreateJobState> {
  final CreateJobUseCase createJobUseCase;

  CreateJobCubit({required this.createJobUseCase}) : super(CreateJobInitial());

  Future<void> createOrUpdateJob(CreateJobParams params) async {
    emit(CreateJobLoading());
    try {
      final result = await createJobUseCase(params);
      result.fold(
        (failure) => emit(CreateJobError(failure.message)),
        (_) => emit(CreateJobSuccess()),
      );
    } catch (e) {
      emit(CreateJobError(e.toString()));
    }
  }
}