import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'applicant_home_event.dart';
part 'applicant_home_state.dart';

class ApplicantHomeBloc extends Bloc<ApplicantHomeEvent, ApplicantHomeState> {
  ApplicantHomeBloc() : super(ApplicantHomeInitial()) {
    on<ApplicantHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
