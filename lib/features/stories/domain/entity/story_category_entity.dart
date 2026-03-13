import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';

class StoryCategoryEntity extends Equatable {
  final int id;
  final int queue;
  final String title;
  final String imageUrl;
  final String imageWebpUrl;
  final List<StoryEntity> stories;

  const StoryCategoryEntity({
    required this.id,
    required this.queue,
    required this.title,
    required this.imageUrl,
    required this.imageWebpUrl,
    required this.stories,
  });

  @override
  List<Object?> get props => [id, queue, title, imageUrl, imageWebpUrl, stories];
}
