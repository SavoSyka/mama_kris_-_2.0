import 'package:mama_kris/features/stories/domain/entity/story_category_entity.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<StoryCategoryEntity> categories;
  StoriesLoaded(this.categories);
}

class StoriesError extends StoriesState {
  final String message;
  StoriesError(this.message);
}
