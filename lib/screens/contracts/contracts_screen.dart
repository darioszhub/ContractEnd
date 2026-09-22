import 'dart:io';

import 'package:flutter/material.dart';

import 'contract_form_dialog.dart';
import 'advanced_search_dialog.dart';
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
  AdvancedSearchResult? _advancedFilters;

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

  Future<void> _openAdvancedSearch() async {
    final result = await showDialog<AdvancedSearchResult>(
      context: context,
      builder: (dialogContext) {
        return AdvancedSearchDialog(
          clients: _clients,
          initialFilters: _advancedFilters,
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      _advancedFilters = result.hasFilters ? result : null;
    });
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
    return _contracts.where((contract) {
      // Ricerca base
      if (_searchText.isNotEmpty) {
        final searchData =
            '${_getClientName(contract.clientId)} '
                    '${contract.type} '
                    '${contract.number}'
                .toLowerCase();

        if (!searchData.contains(_searchText)) {
          return false;
        }
      }

      // Ricerca avanzata
      final filters = _advancedFilters;

      if (filters == null) {
        return true;
      }

      // Cliente
      if (filters.clientId != null && contract.clientId != filters.clientId) {
        return false;
      }

      // Tipo cliente
      if (filters.clientType != null &&
          contract.clientType != filters.clientType) {
        return false;
      }

      // Categoria merceologica
      if (filters.mercCategory != null &&
          !(contract.mercCategory ?? '').toLowerCase().contains(
            filters.mercCategory!.toLowerCase(),
          )) {
        return false;
      }

      // Fattura cliente periodo
      if (filters.invoicePeriod != null &&
          !(contract.invoicePeriod ?? '').toLowerCase().contains(
            filters.invoicePeriod!.toLowerCase(),
          )) {
        return false;
      }

      // Tipo contratto
      if (filters.type != null &&
          !contract.type.toLowerCase().contains(filters.type!.toLowerCase())) {
        return false;
      }

      // Numero contratto
      if (filters.number != null &&
          !contract.number.toLowerCase().contains(
            filters.number!.toLowerCase(),
          )) {
        return false;
      }

      // Data inizio
      if (!_dateInRange(
        contract.startDate,
        filters.startDateFrom,
        filters.startDateTo,
      )) {
        return false;
      }

      // Data scadenza
      if (!_dateInRange(
        contract.expirationDate,
        filters.expirationDateFrom,
        filters.expirationDateTo,
      )) {
        return false;
      }

      // Data acquisizione
      if (!_dateInRange(
        contract.acquisitionDate,
        filters.acquisitionDateFrom,
        filters.acquisitionDateTo,
      )) {
        return false;
      }

      // Data notifica scadenza
      if (!_dateInRange(
        contract.expirationNoticeDate,
        filters.expirationNoticeDateFrom,
        filters.expirationNoticeDateTo,
      )) {
        return false;
      }

      // Importo
      if (!_numberInRange(
        contract.amount,
        filters.amountFrom,
        filters.amountTo,
      )) {
        return false;
      }

      // Potenza contatore
      if (!_numberInRange(
        contract.meterPower,
        filters.meterPowerFrom,
        filters.meterPowerTo,
      )) {
        return false;
      }

      // Volumi annui
      if (!_numberInRange(
        contract.annualVolume,
        filters.annualVolumeFrom,
        filters.annualVolumeTo,
      )) {
        return false;
      }

      // Tipologia offerta
      if (filters.offerType != null &&
          contract.offerType != filters.offerType) {
        return false;
      }

      // Spread nuova tariffa
      if (!_numberInRange(
        contract.variableSpreadNew,
        filters.variableSpreadNewFrom,
        filters.variableSpreadNewTo,
      )) {
        return false;
      }

      // Spread vecchia tariffa
      if (!_numberInRange(
        contract.variableSpreadOld,
        filters.variableSpreadOldFrom,
        filters.variableSpreadOldTo,
      )) {
        return false;
      }

      // Gestore attuale
      if (filters.currentManager != null &&
          !(contract.currentManager ?? '').toLowerCase().contains(
            filters.currentManager!.toLowerCase(),
          )) {
        return false;
      }

      // Gestore precedente
      if (filters.previousManager != null &&
          !(contract.previousManager ?? '').toLowerCase().contains(
            filters.previousManager!.toLowerCase(),
          )) {
        return false;
      }

      // Agente
      if (filters.agent != null &&
          !(contract.agent ?? '').toLowerCase().contains(
            filters.agent!.toLowerCase(),
          )) {
        return false;
      }

      // Codice agente
      if (filters.codagent != null &&
          !(contract.codagent ?? '').toLowerCase().contains(
            filters.codagent!.toLowerCase(),
          )) {
        return false;
      }

      // Frequenza pagamento
      if (filters.frequency != null &&
          contract.frequency != filters.frequency) {
        return false;
      }

      return true;
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

  bool _numberInRange(double? value, double? from, double? to) {
    if (from == null && to == null) {
      return true;
    }

    if (value == null) {
      return false;
    }

    if (from != null && value < from) {
      return false;
    }

    if (to != null && value > to) {
      return false;
    }

    return true;
  }

  bool _dateInRange(String? value, DateTime? from, DateTime? to) {
    if (from == null && to == null) {
      return true;
    }

    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final parts = value.split('/');

    if (parts.length != 3) {
      return false;
    }

    final date = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    final normalizedDate = DateTime(date.year, date.month, date.day);

    if (from != null && normalizedDate.isBefore(from)) {
      return false;
    }

    if (to != null && normalizedDate.isAfter(to)) {
      return false;
    }

    return true;
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

    if (days <= 90) {
      return 'In scadenza';
    }

    return 'Attivo';
  }

  Color _getStatusColor(int days) {
    if (days < 0) {
      return Colors.red;
    }

    if (days <= 90) {
      return Colors.orange;
    }

    return Colors.green;
  }

  Future<void> _openContractForm({Contract? contract}) async {
    if (_contractDialogContext != null) {
      Navigator.pop(_contractDialogContext!);
      _contractDialogContext = null;
    }

    final result = await showDialog<ContractFormResult>(
      context: context,
      builder: (dialogContext) {
        _contractDialogContext = dialogContext;

        return ContractFormDialog(contract: contract, clients: _clients);
      },
    );

    _contractDialogContext = null;

    if (result == null) return;

    final updatedContract = result.contract;

    if (contract == null) {
      final id = await _repository.insert(updatedContract);

      if (!mounted) return;

      setState(() {
        _contracts.add(
          Contract(
            id: id,
            clientId: updatedContract.clientId,
            type: updatedContract.type,
            number: updatedContract.number,
            startDate: updatedContract.startDate,
            expirationDate: updatedContract.expirationDate,
            amount: updatedContract.amount,
            frequency: updatedContract.frequency,
            agent: updatedContract.agent,
            codagent: updatedContract.codagent,
            clientType: updatedContract.clientType,
            mercCategory: updatedContract.mercCategory,
            invoicePeriod: updatedContract.invoicePeriod,
            meterPower: updatedContract.meterPower,
            annualVolume: updatedContract.annualVolume,
            offerType: updatedContract.offerType,
            variableSpreadNew: updatedContract.variableSpreadNew,
            variableSpreadOld: updatedContract.variableSpreadOld,
            currentManager: updatedContract.currentManager,
            acquisitionDate: updatedContract.acquisitionDate,
            previousManager: updatedContract.previousManager,
            expirationNoticeDate: updatedContract.expirationNoticeDate,
            filePath: updatedContract.filePath,
            notes: updatedContract.notes,
            timestampINS: updatedContract.timestampINS,
            timestampEDT: updatedContract.timestampEDT,
          ),
        );
      });
    } else {
      await _repository.update(updatedContract);

      if (result.oldFilePath != null) {
        final oldFile = File(result.oldFilePath!);

        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      if (!mounted) return;

      setState(() {
        final index = _contracts.indexOf(contract);

        if (index != -1) {
          _contracts[index] = updatedContract;
        }
      });
    }
  }

  Future<void> _openPdf(Contract contract) async {
    if (contract.filePath == null || contract.filePath!.isEmpty) {
      return;
    }

    final file = File(contract.filePath!);

    if (!await file.exists()) {
      return;
    }

    await Process.start('explorer.exe', [contract.filePath!]);
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

    if (contract.filePath != null && contract.filePath!.isNotEmpty) {
      final file = File(contract.filePath!);

      if (await file.exists()) {
        await file.delete();
      }
    }

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

          Row(
            children: [
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

              const SizedBox(width: 12),

              SizedBox(
                height: 47,
                child: OutlinedButton.icon(
                  onPressed: _openAdvancedSearch,
                  icon: const Icon(Icons.tune),
                  label: const Text('Ricerca avanzata'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
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
                                      tooltip: 'Apri PDF',
                                      onPressed: contract.filePath != null
                                          ? () {
                                              _openPdf(contract);
                                            }
                                          : null,
                                      icon: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                      ),
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
