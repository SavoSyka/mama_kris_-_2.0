import 'package:mama_kris/features/stories/data/model/story_model.dart';
import 'package:mama_kris/features/stories/domain/entity/story_category_entity.dart';

class StoryCategoryModel extends StoryCategoryEntity {
  const StoryCategoryModel({
    required super.id,
    required super.queue,
    required super.title,
    required super.imageUrl,
    required super.imageWebpUrl,
    required super.stories,
  });

  factory StoryCategoryModel.fromJson(Map<String, dynamic> json) {
    final storiesList = (json['stories'] as List?)
            ?.map((s) => StoryModel.fromJson(s as Map<String, dynamic>))
            .toList() ??
        [];
    storiesList.sort((a, b) => a.queue.compareTo(b.queue));

    return StoryCategoryModel(
      id: json['id'] as int,
      queue: json['queue'] as int,
      title: json['title'] as String,
      imageUrl: _toHttps(json['imageUrl'] as String),
      imageWebpUrl: _toHttps(json['imageWebpUrl'] as String),
      stories: storiesList,
    );
  }

  static String _toHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
