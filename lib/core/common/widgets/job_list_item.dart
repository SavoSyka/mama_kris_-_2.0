import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:share_plus/share_plus.dart';

class JobListItem extends StatefulWidget {
  final String jobTitle;
  final String salaryRange;
  final int jobId;

  final VoidCallback onTap;
  final VoidCallback? onDislike;

  final bool showAddToFavorite;

  final ContactJobs? contactJobs;

  const JobListItem({
    super.key,
    required this.jobTitle,
    required this.salaryRange,
    required this.onTap,
    this.showAddToFavorite = true,
    required this.jobId,
    this.onDislike,
    required this.contactJobs,
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
        PopupMenuItem(
          onTap: () {
            if (widget.showAddToFavorite) {
              context.read<JobBloc>().add(LikeJobEvent(widget.jobId));
            } else {
              widget.onDislike?.call();
            }
            // Handle add to favorites
          },
          child: Text(
            widget.showAddToFavorite
                ? 'Добавить в избранное'
                : 'Удалить из избранного',
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle add to favorites
            final buffer = StringBuffer();

            buffer.writeln("Посмотрите эту вакансию:");

            buffer.writeln("${widget.jobTitle} - ${widget.salaryRange}\n");

            buffer.writeln("Contacts:");

            if (widget.contactJobs?.telegram != null &&
                widget.contactJobs!.telegram!.isNotEmpty) {
              buffer.writeln("• Telegram: @${widget.contactJobs!.telegram}");
            }

            if (widget.contactJobs?.whatsapp != null &&
                widget.contactJobs!.whatsapp!.isNotEmpty) {
              buffer.writeln("• WhatsApp: ${widget.contactJobs!.whatsapp}");
            }

            if (widget.contactJobs?.phone != null &&
                widget.contactJobs!.phone!.isNotEmpty) {
              buffer.writeln("• Phone: ${widget.contactJobs!.phone}");
            }

            if (widget.contactJobs?.vk != null &&
                widget.contactJobs!.vk!.isNotEmpty) {
              buffer.writeln("• VK: ${widget.contactJobs!.vk}");
            }

            if (widget.contactJobs?.email != null &&
                widget.contactJobs!.email!.isNotEmpty) {
              buffer.writeln("• Email: ${widget.contactJobs!.email}");
            }

            if (widget.contactJobs?.link != null &&
                widget.contactJobs!.link!.isNotEmpty) {
              buffer.writeln("• Link: ${widget.contactJobs!.link}");
            }

            Share.share(buffer.toString(), subject: 'Job Opportunity');
          },
          child: const Text('Поделиться'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report

            HandleLaunchUrl.launchTelegram(
              context,
              username: "@mamakrisSupport_bot",
              message:
                  "Здравствуйте, я хочу сообщить о проблеме по вакансии с ID: ${widget.jobId}, название ${widget.jobTitle}",
            );
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: widget.jobTitle,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            height: 1.30,
                          ),
                        ),
                      ),
                    ],
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
