import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/stories/application/cubit/stories_state.dart';
import 'package:mama_kris/features/stories/data/data_source/stories_remote_data_source.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRemoteDataSource remoteDataSource;

  StoriesCubit({required this.remoteDataSource}) : super(StoriesInitial());

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final categories = await remoteDataSource.getStoryCategories();
      emit(StoriesLoaded(categories));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }
}
