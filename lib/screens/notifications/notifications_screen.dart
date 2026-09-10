import 'package:flutter/material.dart';

import '../../models/notification.dart' as app_notification;
import '../../repositories/notification_repository.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(int contractId) onOpenContract;

  const NotificationsScreen({super.key, required this.onOpenContract});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _repository = NotificationRepository.instance;

  final List<app_notification.Notification> _notifications = [];

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
    });
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
          const Text(
            'Notifiche',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Visualizza le notifiche relative alle scadenze dei contratti',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 25),

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
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () {
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(notification.message),
                            ),
                            trailing: Text(
                              _formatDateTime(notification.timestampINS),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
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
