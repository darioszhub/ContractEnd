import 'package:flutter/material.dart';

import 'client_form_dialog.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _clients = [
    {
      'name': 'Mario',
      'surname': 'Rossi',
      'company': '',
      'phone': '333 1234567',
      'email': 'mario.rossi@email.it',
      'contracts': 2,
    },
    {
      'name': 'Luca',
      'surname': 'Bianchi',
      'company': '',
      'phone': '347 9876543',
      'email': 'luca.bianchi@email.it',
      'contracts': 1,
    },
    {
      'name': '',
      'surname': '',
      'company': 'Alfa S.r.l.',
      'phone': '095 123456',
      'email': 'info@alfasrl.it',
      'contracts': 5,
    },
  ];

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredClients {
    if (_searchText.isEmpty) {
      return _clients;
    }

    return _clients.where((client) {
      final name = '${client['name']} ${client['surname']} ${client['company']}'
          .toLowerCase();

      return name.contains(_searchText);
    }).toList();
  }

  void _openClientForm() async {
    final client = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ClientFormDialog(),
    );

    if (client != null) {
      setState(() {
        _clients.add(client);
      });
    }
  }

  void _editClient(Map<String, dynamic> client) async {
    final updatedClient = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ClientFormDialog(client: client),
    );

    if (updatedClient != null) {
      setState(() {
        final index = _clients.indexOf(client);

        if (index != -1) {
          _clients[index] = updatedClient;
        }
      });
    }
  }

  void _deleteClient(Map<String, dynamic> client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elimina cliente'),
          content: Text(
            'Sei sicuro di voler eliminare '
            '${client['company'].toString().isNotEmpty ? client['company'] : '${client['name']} ${client['surname']}'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _clients.remove(client);
                });

                Navigator.pop(context);
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  String _getClientName(Map<String, dynamic> client) {
    if (client['company'].toString().isNotEmpty) {
      return client['company'];
    }

    return '${client['name']} ${client['surname']}';
  }

  @override
  Widget build(BuildContext context) {
    final clients = _filteredClients;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Clienti',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),

              FilledButton.icon(
                onPressed: _openClientForm,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nuovo cliente'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Gestisci i clienti e i relativi dati anagrafici',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: 400,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca cliente...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: clients.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun cliente trovato',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Cliente')),
                          DataColumn(label: Text('Telefono')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Contratti')),
                          DataColumn(label: Text('Azioni')),
                        ],
                        rows: clients.map((client) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  _getClientName(client),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(Text(client['phone'])),
                              DataCell(Text(client['email'])),
                              DataCell(Text(client['contracts'].toString())),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Modifica',
                                      onPressed: () {
                                        _editClient(client);
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Elimina',
                                      onPressed: () {
                                        _deleteClient(client);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
