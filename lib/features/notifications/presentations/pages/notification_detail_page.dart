import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/notifications/applications/notification_detail/bloc/notification_detail_cubit.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';

class NotificationDetailPage extends StatefulWidget {
  final String notificationId;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationDetailCubit>().loadNotification(widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        backgroundColor: AppPalette.primaryColor,
      ),
      body: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
        builder: (context, state) {
          if (state is NotificationDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationDetailCubit>().loadNotification(widget.notificationId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationDetailLoaded) {
            final notification = state.notification;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Timestamp
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image if available
                  if (notification.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        notification.imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Body
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Mark as read button if not read
                  if (!notification.isRead)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<NotificationDetailCubit>().markAsRead(notification.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Mark as Read',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                  // Additional data if available
                  if (notification.data != null && notification.data!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Additional Information:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        notification.data.toString(),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}