part of 'liked_job_bloc_bloc.dart';

sealed class LikedJobBlocEvent extends Equatable {
  const LikedJobBlocEvent();

  @override
  List<Object> get props => [];
}

 class FetchLikedJobEvent extends LikedJobBlocEvent {
  const FetchLikedJobEvent();

  @override
  List<Object> get props => [];
}


class LikedLoadNextJobsPageEvent extends LikedJobBlocEvent {
  final int nextPage;
  const LikedLoadNextJobsPageEvent(this.nextPage);

  @override
  List<Object> get props => [nextPage];
}