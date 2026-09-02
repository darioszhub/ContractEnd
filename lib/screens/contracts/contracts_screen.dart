import 'package:flutter/material.dart';

import 'contract_form_dialog.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _contracts = [
    {
      'client': 'Mario Rossi',
      'type': 'Telefonia',
      'number': 'CTR-2025-001',
      'startDate': '15/10/2025',
      'expirationDate': '15/10/2026',
      'amount': 49.90,
      'frequency': 'Mensile',
      'filePath': '',
      'notes': '',
    },
    {
      'client': 'Luca Bianchi',
      'type': 'Internet',
      'number': 'CTR-2025-002',
      'startDate': '05/09/2025',
      'expirationDate': '05/09/2026',
      'amount': 39.90,
      'frequency': 'Mensile',
      'filePath': '',
      'notes': '',
    },
    {
      'client': 'Alfa S.r.l.',
      'type': 'Energia',
      'number': 'CTR-2026-015',
      'startDate': '20/09/2025',
      'expirationDate': '20/09/2026',
      'amount': 1250.00,
      'frequency': 'Annuale',
      'filePath': '',
      'notes': '',
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

  List<Map<String, dynamic>> get _filteredContracts {
    if (_searchText.isEmpty) {
      return _contracts;
    }

    return _contracts.where((contract) {
      final searchData =
          '${contract['client']} '
          '${contract['type']} '
          '${contract['number']}'
          .toLowerCase();

      return searchData.contains(_searchText);
    }).toList();
  }

  int _daysUntilExpiration(String date) {
    final parts = date.split('/');

    final expiration = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    return expiration.difference(DateTime.now()).inDays;
  }

  String _getStatus(int days) {
    if (days < 0) {
      return 'Scaduto';
    }

    if (days <= 30) {
      return 'In scadenza';
    }

    return 'Attivo';
  }

  Color _getStatusColor(int days) {
    if (days < 0) {
      return Colors.red;
    }

    if (days <= 30) {
      return Colors.orange;
    }

    return Colors.green;
  }

  void _openContractForm({Map<String, dynamic>? contract}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ContractFormDialog(
        contract: contract,
      ),
    );

    if (result == null) return;

    setState(() {
      if (contract == null) {
        _contracts.add(result);
      } else {
        final index = _contracts.indexOf(contract);

        if (index != -1) {
          _contracts[index] = result;
        }
      }
    });
  }

  void _deleteContract(Map<String, dynamic> contract) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elimina contratto'),
          content: Text(
            'Sei sicuro di voler eliminare '
            '${contract['number']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _contracts.remove(contract);
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

  @override
  Widget build(BuildContext context) {
    final contracts = _filteredContracts;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Contratti',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: () => _openContractForm(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nuovo contratto'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Gestisci i contratti e monitora le relative scadenze',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: 400,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca contratto...',
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
              child: contracts.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun contratto trovato',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Cliente')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Numero')),
                          DataColumn(label: Text('Scadenza')),
                          DataColumn(label: Text('Giorni')),
                          DataColumn(label: Text('Stato')),
                          DataColumn(label: Text('Azioni')),
                        ],
                        rows: contracts.map((contract) {
                          final days = _daysUntilExpiration(
                            contract['expirationDate'],
                          );

                          final status = _getStatus(days);
                          final statusColor = _getStatusColor(days);

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  contract['client'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(contract['type']),
                              ),
                              DataCell(
                                Text(contract['number']),
                              ),
                              DataCell(
                                Text(contract['expirationDate']),
                              ),
                              DataCell(
                                Text(
                                  days < 0
                                      ? '${days.abs()} giorni fa'
                                      : '$days giorni',
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Modifica',
                                      onPressed: () {
                                        _openContractForm(
                                          contract: contract,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Elimina',
                                      onPressed: () {
                                        _deleteContract(contract);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                      ),
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