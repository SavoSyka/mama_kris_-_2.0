import 'package:equatable/equatable.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object> get props => [];
}

class FetchResumesEvent extends ResumeEvent {
  final bool isFavorite;

  const FetchResumesEvent({required this.isFavorite});
}

class LoadNextResumePageEvent extends ResumeEvent {
  final int nextPage;

  final bool isFavorite;

  const LoadNextResumePageEvent({
    required this.nextPage,
    required this.isFavorite,
  });
  @override
  List<Object> get props => [nextPage];
}
