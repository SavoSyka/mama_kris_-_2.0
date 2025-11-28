import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:share_plus/share_plus.dart';

class ResumeItem extends StatefulWidget {
  final String name;
  final List<String>? specializations;

  final String age;
  final int userId;
  final bool isFavorite;
  final VoidCallback onTap;

  const ResumeItem({
    super.key,
    required this.name,
    required this.specializations,
    required this.onTap,
    required this.age,
    required this.isFavorite,

    required this.userId,
  });

  @override
  _JobListItemState createState() => _JobListItemState();
}

class _JobListItemState extends State<ResumeItem> {
  final GlobalKey _menuKey = GlobalKey();

  void _showJobOptionsMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            // * Handle add to favorites

            debugPrint(
              "On like or dislike isFavorited status ${widget.isFavorite}",
            );
            context.read<ResumeBloc>().add(
              UpdateFavoritingEvent(
                isFavorited: widget.isFavorite,
                userId: widget.userId.toString(),
              ),
            );
          },
          child: Text(
            widget.isFavorite
                ? 'Remove Удалить из избранного'
                : 'add Добавить в избранное',
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle share
            HandleLaunchUrl.launchTelegram(
              context,
              username: "@mamakrisSupport_bot",
              message:
                  "Я хотел бы сообщить о резюме как мошенническом.\n\nID резюме: ${widget.userId}\nИмя: ${widget.name}\nПричина:",
            );
          },
          child: const Text('Отправить жалобу'), // * Submit a complaint
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report
          },
          child: const Text('Скрыть', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: AppTheme.cardDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.30,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (widget.specializations != null &&
                      widget.specializations!.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.specializations!
                          .take(3)
                          .map(
                            (spec) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: CustomText(
                                text: spec,
                                style: const TextStyle(
                                  color: Color(0xFF596574),
                                  fontSize: 12,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w500,
                                  height: 1.30,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 8),
                  if (widget.age.isNotEmpty)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${widget.age} год",
                            style: const TextStyle(
                              color: Color(0xFF596574),
                              fontSize: 12,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              height: 1.30,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _showJobOptionsMenu(context);
              },
              child: CustomImageView(
                key: _menuKey,
                imagePath: MediaRes.verticalDots,
                width: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
