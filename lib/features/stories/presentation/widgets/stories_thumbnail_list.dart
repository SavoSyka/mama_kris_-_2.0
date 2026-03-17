import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/stories/domain/entity/story_category_entity.dart';
import 'package:mama_kris/features/stories/presentation/widgets/story_viewer.dart';

class StoriesThumbnailList extends StatelessWidget {
  final List<StoryCategoryEntity> categories;
  final Set<int> viewedCategoryIds;
  final ValueChanged<int>? onCategoryViewed;
  final double? horizontalPadding;

  const StoriesThumbnailList({
    super.key,
    required this.categories,
    this.viewedCategoryIds = const {},
    this.onCategoryViewed,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 81,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isViewed = viewedCategoryIds.contains(category.id);

          return GestureDetector(
            onTap: () {
              if (category.stories.isEmpty) return;
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => StoryViewer(
                    categories: categories,
                    initialCategoryIndex: index,
                    onCategoryViewed: onCategoryViewed,
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Container(
              width: 81,
              height: 81,
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
                  imageUrl: category.imageWebpUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: AppPalette.greyLight),
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
