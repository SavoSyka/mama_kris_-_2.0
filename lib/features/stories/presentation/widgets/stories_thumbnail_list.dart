import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';
import 'package:mama_kris/features/stories/presentation/widgets/story_viewer.dart';

class StoriesThumbnailList extends StatelessWidget {
  final List<StoryEntity> stories;
  final Set<int> viewedStoryIds;
  final ValueChanged<int>? onStoryViewed;

  const StoriesThumbnailList({
    super.key,
    required this.stories,
    this.viewedStoryIds = const {},
    this.onStoryViewed,
  });

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          final isViewed = viewedStoryIds.contains(story.id);

          return GestureDetector(
            onTap: () {
              onStoryViewed?.call(story.id);
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => StoryViewer(
                    stories: stories,
                    initialIndex: index,
                    onStoryViewed: onStoryViewed,
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isViewed
                      ? AppPalette.greyLight
                      : AppPalette.storyBorder,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: story.imageWebpUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppPalette.greyLight,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppPalette.greyLight,
                    child: const Icon(Icons.error_outline, size: 20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
