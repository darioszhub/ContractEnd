import '../database/database.dart';
import '../models/setting.dart';

class SettingRepository {
  static final SettingRepository instance = SettingRepository._internal();

  SettingRepository._internal();

  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<Setting> get() async {
    final db = await _database.database;

    final rows = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    final row = rows.first;

    return Setting(
      notificationsEnabled: (row['notificationsEnabled'] as int) == 1,
      checkAtStartup: (row['checkAtStartup'] as int) == 1,
      notify30Days: (row['notify30Days'] as int) == 1,
      notify15Days: (row['notify15Days'] as int) == 1,
      notify7Days: (row['notify7Days'] as int) == 1,
      notify1Day: (row['notify1Day'] as int) == 1,
      notifyExpired: (row['notifyExpired'] as int) == 1,
    );
  }

  Future<int> update(Setting setting) async {
    final db = await _database.database;

    return await db.update(
      'settings',
      {
        'notificationsEnabled': setting.notificationsEnabled ? 1 : 0,
        'checkAtStartup': setting.checkAtStartup ? 1 : 0,
        'notify30Days': setting.notify30Days ? 1 : 0,
        'notify15Days': setting.notify15Days ? 1 : 0,
        'notify7Days': setting.notify7Days ? 1 : 0,
        'notifyExpired': setting.notifyExpired ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}