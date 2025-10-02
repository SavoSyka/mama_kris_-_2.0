import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/notifications/applications/notification_list/bloc/notification_list_cubit.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationListCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppPalette.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              context.read<NotificationListCubit>().markAllAsRead();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationListCubit, NotificationListState>(
        builder: (context, state) {
          if (state is NotificationListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationListCubit>().loadNotifications();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationListLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications yet'),
              );
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationListItem(
                  notification: notification,
                  onTap: () {
                    // Navigate to detail page
                    context.push('/notification-detail/${notification.id}');
                  },
                  onMarkAsRead: () {
                    context.read<NotificationListCubit>().markAsRead(notification.id);
                  },
                  onDelete: () {
                    context.read<NotificationListCubit>().deleteNotification(notification.id);
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class NotificationListItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead ? Colors.grey : AppPalette.primaryColor,
          child: Icon(
            notification.isRead ? Icons.notifications_none : Icons.notifications,
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : IconButton(
                icon: const Icon(Icons.check),
                onPressed: onMarkAsRead,
              ),
        onTap: onTap,
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