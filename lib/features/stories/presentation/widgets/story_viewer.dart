import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/stories/domain/entity/story_category_entity.dart';
import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';
import 'package:video_player/video_player.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryCategoryEntity> categories;
  final int initialCategoryIndex;
  final ValueChanged<int>? onCategoryViewed;

  const StoryViewer({
    super.key,
    required this.categories,
    this.initialCategoryIndex = 0,
    this.onCategoryViewed,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentCategoryIndex;
  int _currentStoryIndex = 0;

  VideoPlayerController? _videoController;
  late AnimationController _progressController;
  bool _isPaused = false;
  bool _isNavigating = false;

  static const _imageDuration = Duration(seconds: 5);
  static const _textDuration = Duration(seconds: 10);

  List<StoryEntity> get _currentStories =>
      widget.categories[_currentCategoryIndex].stories;

  StoryEntity get _currentStory => _currentStories[_currentStoryIndex];

  String get _currentCategoryTitle =>
      widget.categories[_currentCategoryIndex].title;

  @override
  void initState() {
    super.initState();
    _currentCategoryIndex = widget.initialCategoryIndex;
    _pageController = PageController(initialPage: _currentCategoryIndex);
    _progressController = AnimationController(vsync: this);
    _progressController.addStatusListener(_onProgressComplete);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyCategoryViewed();
      _loadStory();
    });
  }

  @override
  void dispose() {
    _progressController.removeStatusListener(_onProgressComplete);
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _notifyCategoryViewed() {
    widget.onCategoryViewed?.call(widget.categories[_currentCategoryIndex].id);
  }

  void _onProgressComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_isNavigating) {
      _goToNextStory();
    }
  }

  void _onVideoUpdate() {
    final controller = _videoController;
    if (controller == null || _isNavigating) return;
    if (!controller.value.isInitialized) return;

    final position = controller.value.position;
    final duration = controller.value.duration;

    if (duration.inMilliseconds > 0) {
      final progress = position.inMilliseconds / duration.inMilliseconds;
      if (mounted) {
        _progressController.value = progress.clamp(0.0, 1.0);
      }
    }

    if (position >= duration - const Duration(milliseconds: 200) &&
        duration.inMilliseconds > 0) {
      _goToNextStory();
    }
  }

  void _cleanupVideo() {
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
  }

  Future<void> _loadStory() async {
    if (!mounted) return;
    _isNavigating = false;

    _cleanupVideo();
    _progressController.reset();

    final story = _currentStory;

    if (story.hasVideo) {
      setState(() {});

      try {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(story.videoUrl!),
        );
        _videoController = controller;

        await controller.initialize();
        if (!mounted) return;

        setState(() {});

        _progressController.duration = controller.value.duration;
        _progressController.forward(from: 0);

        controller.addListener(_onVideoUpdate);
        controller.play();
      } catch (e) {
        debugPrint("Video init error: $e");
        if (!mounted) return;
        setState(() {});
        _progressController.duration = _imageDuration;
        _progressController.forward(from: 0);
      }
    } else if (story.isTextOnly) {
      setState(() {});
      _progressController.duration = _textDuration;
      _progressController.forward(from: 0);
    } else {
      setState(() {});
      _progressController.duration = _imageDuration;
      _progressController.forward(from: 0);
    }
  }

  // --- Navigation ---

  void _goToNextStory() {
    if (_isNavigating) return;
    _isNavigating = true;

    _videoController?.pause();
    _progressController.stop();

    if (_currentStoryIndex < _currentStories.length - 1) {
      setState(() => _currentStoryIndex++);
      _loadStory();
    } else {
      _goToNextCategory();
    }
  }

  void _goToPreviousStory() {
    if (_isNavigating) return;
    _isNavigating = true;

    _videoController?.pause();
    _progressController.stop();

    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _loadStory();
    } else {
      _goToPreviousCategory();
    }
  }

  void _goToNextCategory() {
    if (_currentCategoryIndex < widget.categories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToPreviousCategory() {
    if (_currentCategoryIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _isNavigating = false;
    }
  }

  void _onPageChanged(int page) {
    if (page == _currentCategoryIndex) return;

    _cleanupVideo();
    _progressController.reset();

    setState(() {
      _currentCategoryIndex = page;
      _currentStoryIndex = 0;
    });

    _notifyCategoryViewed();
    _loadStory();
  }

  // --- Gestures ---

  void _onTapUp(TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.globalPosition.dx < screenWidth / 3) {
      _goToPreviousStory();
    } else {
      _goToNextStory();
    }
  }

  void _onLongPressStart(LongPressStartDetails _) => _pause();
  void _onLongPressEnd(LongPressEndDetails _) => _resume();

  void _pause() {
    _isPaused = true;
    _progressController.stop();
    _videoController?.pause();
  }

  void _resume() {
    if (!_isPaused) return;
    _isPaused = false;
    _progressController.forward();
    _videoController?.play();
  }

  // --- Build ---

  /// Returns true if the current story should use dark-on-light theme (text-only stories)
  bool _isLightTheme(StoryEntity story) => story.isTextOnly;

  Widget _buildContent(StoryEntity story) {
    // Video
    if (story.hasVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }

    if (story.hasVideo) {
      return const _FullScreenShimmer();
    }

    // Image
    if (story.hasImage) {
      return CachedNetworkImage(
        imageUrl: story.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const _FullScreenShimmer(),
        errorWidget: (_, __, ___) => Container(color: Colors.black),
      );
    }

    // Text-only: white background with inline markdown
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Top spacing for indicators + title
            const SizedBox(height: 80),
            Expanded(
              child: story.description != null && story.description!.isNotEmpty
                  ? Markdown(
                      data: story.description!,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      onTapLink: (text, href, title) {
                        if (href != null && href.isNotEmpty) {
                          HandleLaunchUrl.launchUrlGeneric(context, url: href);
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        h1: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        h2: const TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        h3: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Reserve space for button
            if (story.hasButton) const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPage(BuildContext context, int categoryIndex) {
    final isActive = categoryIndex == _currentCategoryIndex;

    if (!isActive) {
      final category = widget.categories[categoryIndex];
      return Container(
        color: Colors.black,
        child: CachedNetworkImage(
          imageUrl: category.imageWebpUrl,
          fit: BoxFit.cover,
          color: Colors.black54,
          colorBlendMode: BlendMode.darken,
        ),
      );
    }

    final story = _currentStory;
    final displayTitle = story.title ?? _currentCategoryTitle;
    final stories = _currentStories;
    final isLight = _isLightTheme(story);

    final uiColor = isLight ? Colors.black : Colors.white;
    final indicatorBg = isLight
        ? Colors.black.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.3);

    return GestureDetector(
      onTapUp: _onTapUp,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildContent(story),

          // Top bar: title + indicators
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: displayTitle.isNotEmpty
                            ? Text(
                                displayTitle,
                                style: TextStyle(
                                  color: uiColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: uiColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress indicators
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: List.generate(stories.length, (i) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _StoryProgressBar(
                            animation: i == _currentStoryIndex
                                ? _progressController
                                : null,
                            isFilled: i < _currentStoryIndex,
                            activeColor: uiColor,
                            backgroundColor: indicatorBg,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Bottom button — show only when story has buttonText + buttonUrl
          if (story.hasButton)
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      HandleLaunchUrl.launchUrlGeneric(
                        context,
                        url: story.buttonUrl!,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          story.buttonText!,
                          style: TextStyle(
                            color: isLight ? Colors.white : Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.categories.length,
        onPageChanged: _onPageChanged,
        itemBuilder: _buildStoryPage,
      ),
    );
  }
}

class _StoryProgressBar extends StatelessWidget {
  final AnimationController? animation;
  final bool isFilled;
  final Color activeColor;
  final Color backgroundColor;

  const _StoryProgressBar({
    this.animation,
    this.isFilled = false,
    this.activeColor = Colors.white,
    this.backgroundColor = const Color(0x4DFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: animation != null
          ? AnimatedBuilder(
              animation: animation!,
              builder: (context, _) {
                return LinearProgressIndicator(
                  value: animation!.value,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation(activeColor),
                  minHeight: 3,
                );
              },
            )
          : LinearProgressIndicator(
              value: isFilled ? 1.0 : 0.0,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation(activeColor),
              minHeight: 3,
            ),
    );
  }
}

class _FullScreenShimmer extends StatefulWidget {
  const _FullScreenShimmer();

  @override
  State<_FullScreenShimmer> createState() => _FullScreenShimmerState();
}

class _FullScreenShimmerState extends State<_FullScreenShimmer>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF1A1A1A),
                Color(0xFF2A2A2A),
                Color(0xFF1A1A1A),
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
