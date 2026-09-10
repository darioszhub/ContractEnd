import '../database/database.dart';
import '../models/notification.dart';

class NotificationRepository {
  static final NotificationRepository instance =
      NotificationRepository._internal();

  NotificationRepository._internal();

  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<List<Notification>> getAll() async {
    final db = await _database.database;

    final rows = await db.query(
      'notifications',
      orderBy: 'TimestampINS DESC',
    );

    return rows.map((row) {
      return Notification(
        id: row['id'] as int,
        contractId: row['contractId'] as int,
        type: row['type'] as String,
        title: row['title'] as String,
        message: row['message'] as String,
        daysBefore: row['daysBefore'] as int?,
        isRead: (row['isRead'] as int) == 1,
        timestampINS: DateTime.parse(row['TimestampINS'] as String),
      );
    }).toList();
  }

  Future<int> insert(Notification notification) async {
    final db = await _database.database;

    return await db.insert(
      'notifications',
      {
        'contractId': notification.contractId,
        'type': notification.type,
        'title': notification.title,
        'message': notification.message,
        'daysBefore': notification.daysBefore,
        'isRead': notification.isRead ? 1 : 0,
        'TimestampINS': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<int> markAsRead(Notification notification) async {
    final db = await _database.database;

    return await db.update(
      'notifications',
      {
        'isRead': 1,
      },
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  Future<int> delete(Notification notification) async {
    final db = await _database.database;

    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }
}