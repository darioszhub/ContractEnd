import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../repositories/client_repository.dart';
import 'client_form_dialog.dart';
import '../../models/contract.dart';
import '../../repositories/contract_repository.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Client> _clients = [];
  final List<Contract> _contracts = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await ClientRepository.instance.getAll();
    final contracts = await ContractRepository.instance.getAll();

    setState(() {
      _clients
        ..clear()
        ..addAll(clients);

      _contracts
        ..clear()
        ..addAll(contracts);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Client> get _filteredClients {
    if (_searchText.isEmpty) {
      return _clients;
    }

    return _clients.where((client) {
      final name = '${client.name} ${client.surname} ${client.company ?? ''}'
          .toLowerCase();

      return name.contains(_searchText);
    }).toList();
  }

  Future<void> _openClientForm() async {
    final client = await showDialog<Client>(
      context: context,
      builder: (context) => const ClientFormDialog(),
    );

    if (client != null) {
      final id = await ClientRepository.instance.insert(client);

      final savedClient = Client(
        id: id,
        name: client.name,
        surname: client.surname,
        company: client.company,
        taxCode: client.taxCode,
        vat: client.vat,
        phone: client.phone,
        email: client.email,
        address: client.address,
        city: client.city,
        notes: client.notes,
        timestampINS: client.timestampINS,
        timestampEDT: client.timestampEDT,
      );

      setState(() {
        _clients.add(savedClient);
      });
    }
  }

  Future<void> _editClient(Client client) async {
    final updatedClient = await showDialog<Client>(
      context: context,
      builder: (context) => ClientFormDialog(client: client),
    );

    if (updatedClient != null) {
      await ClientRepository.instance.update(updatedClient);

      setState(() {
        final index = _clients.indexOf(client);

        if (index != -1) {
          _clients[index] = updatedClient;
        }
      });
    }
  }

  Future<void> _deleteClient(Client client) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Elimina cliente'),
          content: Text(
            'Sei sicuro di voler eliminare ${_getClientName(client)}?',
          ),
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

    await ClientRepository.instance.delete(client);

    if (!mounted) return;

    setState(() {
      _clients.remove(client);
    });
  }

  String _getClientName(Client client) {
    if (client.company != null && client.company!.isNotEmpty) {
      return client.company!;
    }

    return '${client.name} ${client.surname}';
  }

  int _getContractCount(int clientId) {
    return _contracts.where((contract) => contract.clientId == clientId).length;
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
                              DataCell(Text(client.phone ?? '')),
                              DataCell(Text(client.email ?? '')),
                              DataCell(
                                Text(_getContractCount(client.id!).toString()),
                              ),
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
