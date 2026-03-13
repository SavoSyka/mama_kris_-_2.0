import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/stories/application/cubit/stories_cubit.dart';
import 'package:mama_kris/features/stories/application/cubit/stories_state.dart';
import 'package:mama_kris/features/stories/presentation/widgets/stories_thumbnail_list.dart';

class StoriesSection extends StatefulWidget {
  final double? horizontalPadding;
  const StoriesSection({super.key, this.horizontalPadding});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  final Set<int> _viewedCategoryIds = {};
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
          if (state is StoriesLoaded && state.categories.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: StoriesThumbnailList(
                categories: state.categories,
                horizontalPadding: widget.horizontalPadding,
                viewedCategoryIds: _viewedCategoryIds,
                onCategoryViewed: (id) {
                  if (_viewedCategoryIds.contains(id)) return;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _viewedCategoryIds.add(id));
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
