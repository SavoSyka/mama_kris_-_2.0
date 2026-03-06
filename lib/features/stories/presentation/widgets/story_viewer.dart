import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/features/stories/domain/entity/story_entity.dart';
import 'package:video_player/video_player.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final ValueChanged<int>? onStoryViewed;

  const StoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
    this.onStoryViewed,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  VideoPlayerController? _videoController;
  late AnimationController _progressController;
  bool _isPaused = false;
  bool _isNavigating = false;

  static const _imageDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(vsync: this);
    _progressController.addStatusListener(_onProgressComplete);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStory(_currentIndex);
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

  void _onProgressComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_isNavigating) {
      _goToNext();
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
      _goToNext();
    }
  }

  Future<void> _loadStory(int index) async {
    if (!mounted) return;
    _isNavigating = false;

    widget.onStoryViewed?.call(widget.stories[index].id);

    // Cleanup previous video
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;

    _progressController.reset();

    final story = widget.stories[index];

    if (story.hasVideo) {
      setState(() {}); // show loading spinner

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
        // Fallback: show image and auto-advance
        setState(() {});
        _progressController.duration = _imageDuration;
        _progressController.forward(from: 0);
      }
    } else {
      setState(() {});
      _progressController.duration = _imageDuration;
      _progressController.forward(from: 0);
    }
  }

  void _goToNext() {
    if (_isNavigating) return;
    _isNavigating = true;

    _videoController?.pause();
    _progressController.stop();

    if (_currentIndex < widget.stories.length - 1) {
      _goToStory(_currentIndex + 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToPrevious() {
    if (_isNavigating) return;
    _isNavigating = true;

    _videoController?.pause();
    _progressController.stop();

    if (_currentIndex > 0) {
      _goToStory(_currentIndex - 1);
    } else {
      _isNavigating = false;
    }
  }

  void _goToStory(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
    _loadStory(index);
  }

  void _onTapUp(TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.globalPosition.dx < screenWidth / 3) {
      _goToPrevious();
    } else {
      _goToNext();
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

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: _onTapUp,
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Content
            if (story.hasVideo &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              )
            else if (!story.hasVideo)
              CachedNetworkImage(
                imageUrl: story.imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(Icons.error, color: Colors.white, size: 48),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Top bar with progress indicators and close
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: List.generate(widget.stories.length, (i) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            child: _StoryProgressBar(
                              animation: i == _currentIndex
                                  ? _progressController
                                  : null,
                              isFilled: i < _currentIndex,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Заголовок',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryProgressBar extends StatelessWidget {
  final AnimationController? animation;
  final bool isFilled;

  const _StoryProgressBar({this.animation, this.isFilled = false});

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
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 3,
                );
              },
            )
          : LinearProgressIndicator(
              value: isFilled ? 1.0 : 0.0,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 3,
            ),
    );
  }
}
