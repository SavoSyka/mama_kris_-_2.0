part of 'liked_job_bloc_bloc.dart';

sealed class LikedJobBlocState extends Equatable {
  const LikedJobBlocState();

  @override
  List<Object> get props => [];
}

final class LikedJobBlocInitial extends LikedJobBlocState {}

class LikedJobLoading extends LikedJobBlocState {}

class LikedJobLoadedState extends LikedJobBlocState {
  final LikedListJob jobs;

  final bool isLoadingMore;

  const LikedJobLoadedState({required this.jobs, required this.isLoadingMore});

  @override
  List<Object> get props => [jobs];

  LikedJobLoadedState copyWith({LikedListJob? jobs, bool? isLoadingMore}) {
    return LikedJobLoadedState(
      jobs: jobs ?? this.jobs,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class LikedJobError extends LikedJobBlocState {
  final String message;

  const LikedJobError(this.message);

  @override
  List<Object> get props => [message];
}
