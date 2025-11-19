import 'package:equatable/equatable.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object> get props => [];
}

class FetchResumesEvent extends ResumeEvent {
  final bool isFavorite;
  final String? searchQuery;
  const FetchResumesEvent({required this.isFavorite, this.searchQuery});
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

class FetchFavoritedResumesEvent extends ResumeEvent {
  final String? searchQuery;
  const FetchFavoritedResumesEvent({this.searchQuery});
}

class LoadNextFavoritedResumePageEvent extends ResumeEvent {
  final int nextPage;

  const LoadNextFavoritedResumePageEvent({required this.nextPage});
  @override
  List<Object> get props => [nextPage];
}

class UpdateFavoritingEvent extends ResumeEvent {
  final bool isFavorited;
  final String userId;

  const UpdateFavoritingEvent({
    required this.isFavorited,
    required this.userId,
  });
}
