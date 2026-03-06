import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final int id;
  final int queue;
  final String imageUrl;
  final String imageWebpUrl;
  final String? videoUrl;
  final String? videoWebmUrl;

  const StoryEntity({
    required this.id,
    required this.queue,
    required this.imageUrl,
    required this.imageWebpUrl,
    this.videoUrl,
    this.videoWebmUrl,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [id, queue, imageUrl, imageWebpUrl, videoUrl, videoWebmUrl];
}
