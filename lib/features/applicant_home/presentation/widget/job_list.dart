import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/entity/job_model.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/empty_posted_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:flutter/services.dart';

class JobList extends StatefulWidget {
  final List<JobModel> jobs;
  final bool isList;

  const JobList({super.key, required this.jobs, required this.isList});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> with TickerProviderStateMixin {
  List<JobModel> _jobs = [];
  final List<JobModel> _history = []; // Stack for dismissed "Интересно" jobs
  int _currentIndex = 0;
  bool _isLoading = true;
  AnimationController? _animationController;
  Animation<double>? _slideAnimation;
  Animation<double>? _rotateAnimation;
  bool _isAnimating = false;
  double _dragOffset = 0.0; // Tracks drag position
  bool _isDragging = false;
  bool _isNextCard =
      false; // Direction of animation (true for next, false for previous)

  @override
  void initState() {
    super.initState();
    debugPrint("All jobs ${widget.jobs}");
    loadJobs();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  Future<void> loadJobs() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/job.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _jobs = jsonData.map((e) => JobModel.fromJson(e)).toList();
      _isLoading = false;
    });
    debugPrint("Jobs ${_jobs.length}");
  }

  void _onUninterested() {
        debugPrint(
      "On  Un interested jobs length  ${_jobs.length} and current ${_currentIndex}",
    );
    if (_jobs.isEmpty || _isAnimating) return;

    _isAnimating = true;
    final screenWidth = MediaQuery.of(context).size.width;

    _animationController!.forward().then((_) {
      setState(() {
        _jobs.removeAt(_currentIndex);
        if (_currentIndex >= _jobs.length && _jobs.isNotEmpty) {
          _currentIndex = _jobs.length - 1;
        }
        _animationController!.reset();
        _isAnimating = false;
      });
    });

    _slideAnimation =
        Tween<double>(
          begin: 0,
          end: -screenWidth * 1.2, // slide left naturally
        ).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Curves.easeOutCubic,
          ),
        );

    _rotateAnimation =
        Tween<double>(
          begin: 0,
          end: -0.15, // slight counter-clockwise
        ).animate(
          CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
        );
  }

  void _onInteresting() {
    debugPrint(
      "On interested jobs length  ${_jobs.length} and current ${_currentIndex}",
    );
    if (_jobs.isEmpty || _isAnimating) return;

    _isAnimating = true;
    final screenWidth = MediaQuery.of(context).size.width;

    _animationController!.forward().then((_) {
      setState(() {
        _history.add(_jobs[_currentIndex]);
        _jobs.removeAt(_currentIndex);
        if (_currentIndex >= _jobs.length && _jobs.isNotEmpty) {
          _currentIndex = _jobs.length - 1;
        }
        _animationController!.reset();
        _isAnimating = false;
      });
    });

    _slideAnimation =
        Tween<double>(
          begin: 0,
          end: screenWidth * 1.2, // slide right naturally
        ).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Curves.easeOutCubic,
          ),
        );

    _rotateAnimation =
        Tween<double>(
          begin: 0,
          end: 0.15, // slight clockwise
        ).animate(
          CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
        );
  }

  void _undoInteresting() async {
    if (_history.isEmpty || _isAnimating) return;
    setState(() {
      _isAnimating = true;
      _isNextCard = false; // Slide in from left
      _dragOffset = -MediaQuery.of(context).size.width; // Slide in from left
      final job = _history.removeLast();
      _jobs.insert(_currentIndex, job);
      if (_currentIndex >= _jobs.length) {
        _currentIndex = _jobs.length - 1;
      }
    });
    await _animationController!.forward();
    setState(() {
      _dragOffset = 0.0;
      _isAnimating = false;
      _animationController!.reset();
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _isDragging = true;
      _dragOffset += details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    if (_dragOffset.abs() > screenWidth * 0.3) {
      if (_dragOffset > 0) {
        _onInteresting();
      } else {
        _onUninterested();
      }
    } else {
      setState(() {
        _dragOffset = 0.0;
        _isDragging = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_jobs.isEmpty) {
      return const EmptyPostedJob();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Next card (only shown if it exists and not animating to previous)
              if (_jobs.length > _currentIndex + 1 && _isNextCard)
                Positioned(
                  top: 16,
                  left: 24,
                  right: 24,
                  bottom: 0,
                  child: Transform.scale(
                    scale: 0.95,
                    child: _JobCard(
                      title: _jobs[_currentIndex + 1].title,
                      price: '${_jobs[_currentIndex + 1].price} руб',
                      description: _jobs[_currentIndex + 1].description,

                      isList: widget.isList,
                      onInteresting: () {},
                      onUnterested: () {},
                    ),
                  ),
                ),
              // Current card
              AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  final offsetX = _slideAnimation?.value ?? _dragOffset;
                  final rotation = _rotateAnimation?.value ?? 0.0;
                  final opacity = 1.0 - (_animationController!.value * 0.6);

                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(offsetX, 0),
                      child: Transform.rotate(
                        angle: rotation,
                        child: GestureDetector(
                          onPanUpdate: _onDragUpdate,
                          onPanEnd: _onDragEnd,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: _JobCard(
                              title: _jobs[_currentIndex].title,
                              description: _jobs[_currentIndex].description,
                              price: '${_jobs[_currentIndex].price} руб',
                              isList: widget.isList,
                              onInteresting: _onInteresting,
                              onUnterested: _onUninterested,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // if (_history.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: EmployeHomeCard(
        //       onTap: _undoInteresting,
        //       text: "Вернуть предыдущую",
        //       isSelected: false,
        //       isTextCenter: true,
        //     ),
        //   ),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.title,
    required this.price,
    required this.description,

    required this.isList,
    required this.onInteresting,
    required this.onUnterested,
  });

  final String title;
  final String price;
  final String description;

  final bool isList;
  final void Function() onInteresting;
  final void Function() onUnterested;

  @override
  Widget build(BuildContext context) {
    return CustomShadowContainer(
      borderRadius: 15,
      horMargin: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: title,
                  style: const TextStyle(
                    color: AppPalette.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              if (isList)
                InkWell(
                  onTap: () {
                    _jobDetailBottomSheet(context);
                  },
                  child: const CustomImageView(
                    imagePath: MediaRes.settingGearIcon,
                    width: 28,
                  ),
                ),
            ],
          ),
          if (isList) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                CustomText(
                  text: price,
                  style: const TextStyle(
                    color: AppPalette.greyDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
          if (!isList) ...[
            const SizedBox(height: 14),
            CustomText(text: description),
            Row(
              children: [
                CustomText(
                  text: price,
                  style: const TextStyle(
                    color: AppPalette.greyDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: EmployeHomeCard(
                    onTap: onUnterested,
                    text: "Неинтересно",
                    isSelected: false,
                    isTextCenter: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EmployeHomeCard(
                    onTap: onInteresting,
                    text: "Интересно",
                    isSelected: true,
                    isTextCenter: true,
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _jobDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Егорова Ирина",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Работаю как UX/UI дизайнер, занимаюсь графическим дизайном и иллюстрацией. Высшее образование получила в Алматинском технологическом университете, училась там с 2014 по 2018 год, диплом у меня в PDF, могу прикрепить при необходимости.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              CustomShadowContainer(
                child: GestureDetector(
                  onTap: onUnterested,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Связаться",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomImageView(imagePath: MediaRes.send, width: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomShadowContainer(
                child: GestureDetector(
                  onTap: onInteresting,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Добавить в избранное",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomImageView(imagePath: MediaRes.star, width: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Отправить жалобу",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.error,
                      ),
                    ),
                    CustomImageView(
                      imagePath: MediaRes.warningCircle,
                      width: 24,
                      color: AppPalette.error,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
            ],
          ),
        );
      },
    );
  }
}
