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

    return await databaseFactory.openDatabase(path);
  }
}
