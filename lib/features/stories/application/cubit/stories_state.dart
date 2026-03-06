import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<StoryEntity> stories;
  StoriesLoaded(this.stories);
}

class StoriesError extends StoriesState {
  final String message;
  StoriesError(this.message);
}
