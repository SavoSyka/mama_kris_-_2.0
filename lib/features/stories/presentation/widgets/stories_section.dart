import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/stories/application/cubit/stories_cubit.dart';
import 'package:mama_kris/features/stories/application/cubit/stories_state.dart';
import 'package:mama_kris/features/stories/presentation/widgets/stories_thumbnail_list.dart';

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  final Set<int> _viewedStoryIds = {};
  late final StoriesCubit _storiesCubit;

  @override
  void initState() {
    super.initState();
    _storiesCubit = sl<StoriesCubit>();
    _storiesCubit.fetchStories();
  }

  @override
  void dispose() {
    _storiesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _storiesCubit,
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state is StoriesLoaded && state.stories.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: StoriesThumbnailList(
                stories: state.stories,
                viewedStoryIds: _viewedStoryIds,
                onStoryViewed: (id) {
                  if (_viewedStoryIds.contains(id)) return;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _viewedStoryIds.add(id));
                    }
                  });
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
