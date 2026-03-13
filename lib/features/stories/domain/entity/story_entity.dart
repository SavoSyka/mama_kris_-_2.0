import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final int id;
  final int queue;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? imageWebpUrl;
  final String? videoUrl;
  final String? videoWebmUrl;

  const StoryEntity({
    required this.id,
    required this.queue,
    this.title,
    this.description,
    this.imageUrl,
    this.imageWebpUrl,
    this.videoUrl,
    this.videoWebmUrl,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get isTextOnly => !hasVideo && !hasImage;

  @override
  List<Object?> get props => [id, queue, title, description, imageUrl, imageWebpUrl, videoUrl, videoWebmUrl];
}
