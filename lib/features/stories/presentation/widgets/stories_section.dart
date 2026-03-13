import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
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
          if (state is StoriesLoading) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _StoriesShimmer(
                horizontalPadding: widget.horizontalPadding,
              ),
            );
          }
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

class _StoriesShimmer extends StatefulWidget {
  final double? horizontalPadding;
  const _StoriesShimmer({this.horizontalPadding});

  @override
  State<_StoriesShimmer> createState() => _StoriesShimmerState();
}

class _StoriesShimmerState extends State<_StoriesShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 81,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Color(0xFFEEEEEE),
                  Color(0xFFF5F5F5),
                  Colors.white,
                  Color(0xFFF5F5F5),
                  Color(0xFFEEEEEE),
                ],
                stops: [
                  0.0,
                  (_controller.value - 0.2).clamp(0.0, 1.0),
                  _controller.value,
                  (_controller.value + 0.2).clamp(0.0, 1.0),
                  1.0,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child!,
          );
        },
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding ?? 16,
          ),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) => Container(
            width: 81,
            height: 81,
            decoration: BoxDecoration(
              color: AppPalette.greyLight,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
