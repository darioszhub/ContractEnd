import 'package:flutter/material.dart';

import 'contract_form_dialog.dart';
import '../../models/contract.dart';
import '../../repositories/contract_repository.dart';
import '../../models/client.dart';
import '../../repositories/client_repository.dart';

class ContractsScreen extends StatefulWidget {
  final int? contractIdToOpen;

  const ContractsScreen({super.key, this.contractIdToOpen});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ContractRepository _repository = ContractRepository.instance;
  final ClientRepository _clientRepository = ClientRepository.instance;

  final List<Contract> _contracts = [];
  final List<Client> _clients = [];

  String _searchText = '';

  BuildContext? _contractDialogContext;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });

    _loadData();
  }

  @override
  void didUpdateWidget(covariant ContractsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.contractIdToOpen != oldWidget.contractIdToOpen) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final contracts = await _repository.getAll();
    final clients = await _clientRepository.getAll();

    if (!mounted) return;

    setState(() {
      _contracts
        ..clear()
        ..addAll(contracts);

      _clients
        ..clear()
        ..addAll(clients);
    });

    if (widget.contractIdToOpen != null) {
      final contract = contracts
          .where((contract) => contract.id == widget.contractIdToOpen)
          .firstOrNull;

      if (contract != null) {
        await _openContractForm(contract: contract);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Contract> get _filteredContracts {
    if (_searchText.isEmpty) {
      return _contracts;
    }

    return _contracts.where((contract) {
      final searchData =
          '${_getClientName(contract.clientId)} '
                  '${contract.type} '
                  '${contract.number}'
              .toLowerCase();

      return searchData.contains(_searchText);
    }).toList();
  }

  String _getClientName(int clientId) {
    final client = _clients
        .where((client) => client.id == clientId)
        .firstOrNull;

    if (client == null) {
      return 'Cliente non trovato';
    }

    if (client.company != null && client.company!.isNotEmpty) {
      return client.company!;
    }

    return '${client.name} ${client.surname}';
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

  Future<void> _openContractForm({Contract? contract}) async {
    if (_contractDialogContext != null) {
      Navigator.pop(_contractDialogContext!);
      _contractDialogContext = null;
    }

    final result = await showDialog<Contract>(
      context: context,
      builder: (dialogContext) {
        _contractDialogContext = dialogContext;

        return ContractFormDialog(contract: contract, clients: _clients);
      },
    );

    _contractDialogContext = null;

    if (result == null) return;

    if (contract == null) {
      final id = await _repository.insert(result);

      if (!mounted) return;

      setState(() {
        _contracts.add(
          Contract(
            id: id,
            clientId: result.clientId,
            type: result.type,
            number: result.number,
            startDate: result.startDate,
            expirationDate: result.expirationDate,
            amount: result.amount,
            frequency: result.frequency,
            filePath: result.filePath,
            notes: result.notes,
            timestampINS: result.timestampINS,
            timestampEDT: result.timestampEDT,
          ),
        );
      });
    } else {
      await _repository.update(result);

      if (!mounted) return;

      setState(() {
        final index = _contracts.indexOf(contract);

        if (index != -1) {
          _contracts[index] = result;
        }
      });
    }
  }

  Future<void> _deleteContract(Contract contract) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Elimina contratto'),
          content: Text('Sei sicuro di voler eliminare ${contract.number}?'),
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

    await _repository.delete(contract);

    if (!mounted) return;

    setState(() {
      _contracts.remove(contract);
    });
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            style: TextStyle(color: Colors.grey, fontSize: 16),
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
                        style: TextStyle(color: Colors.grey, fontSize: 16),
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
                            contract.expirationDate,
                          );

                          final status = _getStatus(days);
                          final statusColor = _getStatusColor(days);

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  _getClientName(contract.clientId),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(Text(contract.type)),
                              DataCell(Text(contract.number)),
                              DataCell(Text(contract.expirationDate)),
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
                                        _openContractForm(contract: contract);
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Elimina',
                                      onPressed: () {
                                        _deleteContract(contract);
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
