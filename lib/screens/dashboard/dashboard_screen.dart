import 'package:flutter/material.dart';

import '../../widgets/app_sidebar.dart';
import '../../widgets/stat_card.dart';
import '../../models/contract.dart';
import '../clients/clients_screen.dart';
import '../contracts/contracts_screen.dart';
import '../../repositories/contract_repository.dart';
import '../../repositories/client_repository.dart';
import '../../models/client.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final ContractRepository _repository = ContractRepository.instance;
  final ClientRepository _clientRepository = ClientRepository.instance;

  final List<Contract> _contracts = [];
  final List<Client> _clients = [];

  @override
  void initState() {
    super.initState();

    _loadData();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });

              if (index == 0) {
                _loadData();
              }
            },
          ),

          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 1:
        return const ClientsScreen();

      case 2:
        return const ContractsScreen();

      case 3:
        return const Center(
          child: Text('Notifiche', style: TextStyle(fontSize: 28)),
        );

      case 4:
        return const Center(
          child: Text('Impostazioni', style: TextStyle(fontSize: 28)),
        );

      default:
        return _buildDashboard();
    }
  }

  DateTime _parseDate(String date) {
    final parts = date.split('/');

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
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

  List<Contract> _getUpcomingContracts() {
    final today = DateTime.now();

    final contracts = _contracts.where((contract) {
      final expirationDate = _parseDate(contract.expirationDate);

      return !expirationDate.isBefore(today);
    }).toList();

    contracts.sort((a, b) {
      final dateA = _parseDate(a.expirationDate);
      final dateB = _parseDate(b.expirationDate);

      return dateA.compareTo(dateB);
    });

    return contracts.take(5).toList();
  }

  Widget _buildDashboard() {
    final totalContracts = _contracts.length;

    final expiringContracts = _contracts.where((contract) {
      final days = _parseDate(contract.expirationDate)
          .difference(DateTime.now())
          .inDays;

      return days >= 0 && days <= 30;
    }).length;

    final expiredContracts = _contracts.where((contract) {
      final days = _parseDate(contract.expirationDate)
          .difference(DateTime.now())
          .inDays;

      return days < 0;
    }).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Panoramica dei tuoi contratti',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    StatCard(
                      title: 'Contratti',
                      value: totalContracts.toString(),
                      icon: Icons.description_outlined,
                    ),
                    const SizedBox(width: 20),
                    StatCard(
                      title: 'In scadenza',
                      value: expiringContracts.toString(),
                      icon: Icons.warning_amber_outlined,
                    ),
                    const SizedBox(width: 20),
                    StatCard(
                      title: 'Scaduti',
                      value: expiredContracts.toString(),
                      icon: Icons.error_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Text(
                  'Prossime scadenze',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _buildContractsTable(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContractsTable() {
    final contracts = _getUpcomingContracts();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Cliente')),
          DataColumn(label: Text('Contratto')),
          DataColumn(label: Text('Scadenza')),
          DataColumn(label: Text('Stato')),
        ],
        rows: contracts.map((contract) {
          final days = _parseDate(contract.expirationDate)
              .difference(DateTime.now())
              .inDays;

          final status = _getStatus(days);

          return DataRow(
            cells: [
              DataCell(Text(_getClientName(contract.clientId))),
              DataCell(Text(contract.type)),
              DataCell(Text(contract.expirationDate)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(days).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(days),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
