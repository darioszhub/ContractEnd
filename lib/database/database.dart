import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    final directory = await getApplicationSupportDirectory();

    final path = join(directory.path, 'contractend.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
        CREATE TABLE clients (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          surname TEXT NOT NULL,
          company TEXT,
          phone TEXT,
          email TEXT,
          notes TEXT,
          TimestampINS TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          TimestampEDT TEXT
        )
      ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE clients ADD COLUMN taxCode TEXT');
            await db.execute('ALTER TABLE clients ADD COLUMN vat TEXT');
            await db.execute('ALTER TABLE clients ADD COLUMN address TEXT');
            await db.execute('ALTER TABLE clients ADD COLUMN city TEXT');
          }
        },
      ),
    );
  }
}
