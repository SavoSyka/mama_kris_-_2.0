import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.queue,
    required super.imageUrl,
    required super.imageWebpUrl,
    super.videoUrl,
    super.videoWebmUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      queue: json['queue'] as int,
      imageUrl: _toHttps(json['imageUrl'] as String),
      imageWebpUrl: _toHttps(json['imageWebpUrl'] as String),
      videoUrl: json['videoUrl'] != null ? _toHttps(json['videoUrl'] as String) : null,
      videoWebmUrl: json['videoWebmUrl'] != null ? _toHttps(json['videoWebmUrl'] as String) : null,
    );
  }

  static String _toHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
