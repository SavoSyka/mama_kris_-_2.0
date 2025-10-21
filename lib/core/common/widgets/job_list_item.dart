import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';
import 'package:share_plus/share_plus.dart';

class JobListItem extends StatefulWidget {
  final String jobTitle;
  final String salaryRange;
  final VoidCallback onTap;
  final bool showAddToFavorite;

  const JobListItem({
    super.key,
    required this.jobTitle,
    required this.salaryRange,
    required this.onTap,
    this.showAddToFavorite = true,
  });

  @override
  _JobListItemState createState() => _JobListItemState();
}

class _JobListItemState extends State<JobListItem> {
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
        if (widget.showAddToFavorite)
          PopupMenuItem(
            onTap: () {
              // Handle add to favorites
            },
            child: const Text('Добавить в избранное'),
          ),
        PopupMenuItem(
          onTap: () {
            // Handle share
            Share.share(
              'Check out this job: ${widget.jobTitle} - ${widget.salaryRange}',
              subject: 'Job Opportunity',
            );
          },
          child: const Text('Поделиться'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report
          },
          child: const Text(
            'Отправить жалобу',
            style: TextStyle(color: Colors.red),
          ),
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
        decoration: AppTheme.cardDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.jobTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.salaryRange,
                  style: const TextStyle(
                    color: Color(0xFF596574),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
              ],
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
