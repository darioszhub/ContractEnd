import '../database/database.dart';
import '../models/contract.dart';

class ContractRepository {
  static final ContractRepository instance = ContractRepository._internal();

  ContractRepository._internal();

  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<List<Contract>> getAll() async {
    final db = await _database.database;

    final rows = await db.query('contracts');

    return rows.map((row) {
      return Contract(
        id: row['id'] as int,
        clientId: row['clientId'] as int,
        type: row['type'] as String,
        number: row['number'] as String,
        startDate: row['startDate'] as String,
        expirationDate: row['expirationDate'] as String,
        amount: row['amount'] as double?,
        frequency: row['frequency'] as String,
        filePath: row['filePath'] as String?,
        notes: row['notes'] as String?,
        timestampINS: DateTime.parse(row['TimestampINS'] as String),
        timestampEDT: row['TimestampEDT'] != null
            ? DateTime.parse(row['TimestampEDT'] as String)
            : null,
      );
    }).toList();
  }

  Future<int> insert(Contract contract) async {
    final db = await _database.database;

    return await db.insert('contracts', {
      'clientId': contract.clientId,
      'type': contract.type,
      'number': contract.number,
      'startDate': contract.startDate,
      'expirationDate': contract.expirationDate,
      'amount': contract.amount,
      'frequency': contract.frequency,
      'filePath': contract.filePath,
      'notes': contract.notes,
    });
  }

  Future<int> update(Contract contract) async {
    final db = await _database.database;

    return await db.update(
      'contracts',
      {
        'clientId': contract.clientId,
        'type': contract.type,
        'number': contract.number,
        'startDate': contract.startDate,
        'expirationDate': contract.expirationDate,
        'amount': contract.amount,
        'frequency': contract.frequency,
        'filePath': contract.filePath,
        'notes': contract.notes,
        'TimestampEDT': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [contract.id],
    );
  }

  Future<int> delete(Contract contract) async {
    final db = await _database.database;

    return await db.delete(
      'contracts',
      where: 'id = ?',
      whereArgs: [contract.id],
    );
  }
}
