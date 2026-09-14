import 'package:flutter/material.dart';

import '../../models/notification.dart' as app_notification;
import '../../repositories/notification_repository.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(int contractId) onOpenContract;
  final VoidCallback onNotificationsChanged;

  const NotificationsScreen({
    super.key,
    required this.onOpenContract,
    required this.onNotificationsChanged,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _repository = NotificationRepository.instance;

  final List<app_notification.Notification> _notifications = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _repository.getAll();

    if (!mounted) return;

    setState(() {
      _notifications
        ..clear()
        ..addAll(notifications);

      _isLoading = false;
    });
  }

  Future<void> _markAllAsRead() async {
    await _repository.markAllAsRead();

    await _loadNotifications();

    widget.onNotificationsChanged();
  }

  Future<void> _deleteNotification(
    app_notification.Notification notification,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Elimina notifica'),
          content: const Text('Sei sicuro di voler eliminare questa notifica?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _repository.delete(notification);

    if (!mounted) return;

    setState(() {
      _notifications.remove(notification);
    });

    widget.onNotificationsChanged();
  }

  Future<void> _deleteAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Elimina tutte le notifiche'),
          content: const Text(
            'Sei sicuro di voler eliminare tutte le notifiche?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Elimina tutto'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _repository.deleteAll();

    if (!mounted) return;

    setState(() {
      _notifications.clear();
    });

    widget.onNotificationsChanged();
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifiche',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),

              FilledButton.icon(
                onPressed: _isLoading || _notifications.isEmpty
                    ? () {}
                    : _deleteAllNotifications,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Elimina tutto'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Visualizza le notifiche relative alle scadenze dei contratti',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              FilledButton.icon(
                onPressed: _isLoading || _notifications.isEmpty
                    ? () {}
                    : _markAllAsRead,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.done_all),
                label: const Text('Segna tutto come letto'),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessuna notifica',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];

                        return Material(
                          color: notification.isRead
                              ? Colors.transparent
                              : Colors.blue.withValues(alpha: 0.05),
                          child: ListTile(
                            onTap: () async {
                              if (!notification.isRead) {
                                await _repository.markAsRead(notification);
                                widget.onNotificationsChanged();
                              }

                              if (!mounted) return;

                              widget.onOpenContract(notification.contractId);
                            },
                            leading: Icon(
                              notification.daysBefore != null &&
                                      notification.daysBefore! < 0
                                  ? Icons.error_outline
                                  : Icons.warning_amber_outlined,
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(notification.message),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatDateTime(notification.timestampINS),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  tooltip: 'Elimina notifica',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _deleteNotification(notification),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
