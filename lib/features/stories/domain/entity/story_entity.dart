import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final int id;
  final int queue;
  final String? title;
  final String? description;
  final String? buttonText;
  final String? buttonUrl;
  final String? imageUrl;
  final String? imageWebpUrl;
  final String? videoUrl;
  final String? videoWebmUrl;

  const StoryEntity({
    required this.id,
    required this.queue,
    this.title,
    this.description,
    this.buttonText,
    this.buttonUrl,
    this.imageUrl,
    this.imageWebpUrl,
    this.videoUrl,
    this.videoWebmUrl,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get isTextOnly => !hasVideo && !hasImage;
  bool get hasButton =>
      buttonText != null &&
      buttonText!.isNotEmpty &&
      buttonUrl != null &&
      buttonUrl!.isNotEmpty;

  @override
  List<Object?> get props => [id, queue, title, description, buttonText, buttonUrl, imageUrl, imageWebpUrl, videoUrl, videoWebmUrl];
}
