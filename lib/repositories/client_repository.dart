import '../database/database.dart';
import '../models/client.dart';

class ClientRepository {
  static final ClientRepository instance = ClientRepository._internal();

  ClientRepository._internal();

  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<List<Client>> getAll() async {
    final db = await _database.database;

    final rows = await db.query('clients');

    return rows.map((row) {
      return Client(
        id: row['id'] as int,
        name: row['name'] as String,
        surname: row['surname'] as String,
        company: row['company'] as String?,
        taxCode: row['taxCode'] as String?,
        vat: row['vat'] as String?,
        phone: row['phone'] as String?,
        email: row['email'] as String?,
        address: row['address'] as String?,
        city: row['city'] as String?,
        notes: row['notes'] as String?,
        timestampINS: DateTime.parse(row['TimestampINS'] as String),
        timestampEDT: row['TimestampEDT'] != null
            ? DateTime.parse(row['TimestampEDT'] as String)
            : null,
      );
    }).toList();
  }

  Future<int> insert(Client client) async {
    final db = await _database.database;

    return await db.insert('clients', {
      'name': client.name,
      'surname': client.surname,
      'company': client.company,
      'taxCode': client.taxCode,
      'vat': client.vat,
      'phone': client.phone,
      'email': client.email,
      'address': client.address,
      'city': client.city,
      'notes': client.notes,
      'TimestampINS': DateTime.now().toIso8601String(),
    });
  }

  Future<int> update(Client client) async {
    final db = await _database.database;

    return await db.update(
      'clients',
      {
        'name': client.name,
        'surname': client.surname,
        'company': client.company,
        'taxCode': client.taxCode,
        'vat': client.vat,
        'phone': client.phone,
        'email': client.email,
        'address': client.address,
        'city': client.city,
        'notes': client.notes,
        'TimestampEDT': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> delete(Client client) async {
    final db = await _database.database;

    return await db.delete('clients', where: 'id = ?', whereArgs: [client.id]);
  }
}
