import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.queue,
    super.title,
    super.description,
    super.buttonText,
    super.buttonUrl,
    super.imageUrl,
    super.imageWebpUrl,
    super.videoUrl,
    super.videoWebmUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      queue: json['queue'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
      buttonText: json['buttonText'] as String?,
      buttonUrl: json['buttonUrl'] as String?,
      imageUrl: json['imageUrl'] != null ? _toHttps(json['imageUrl'] as String) : null,
      imageWebpUrl: json['imageWebpUrl'] != null ? _toHttps(json['imageWebpUrl'] as String) : null,
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
