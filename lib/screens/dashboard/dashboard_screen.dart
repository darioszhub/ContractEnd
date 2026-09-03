import 'package:flutter/material.dart';

import '../../widgets/app_sidebar.dart';
import '../../widgets/stat_card.dart';
import '../../models/contract.dart';
import '../clients/clients_screen.dart';
import '../contracts/contracts_screen.dart';
import '../../repositories/contract_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final ContractRepository _repository = ContractRepository.instance;

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

  List<Contract> _getUpcomingContracts() {
    final today = DateTime.now();

    final contracts = _repository.contracts.where((contract) {
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
    final totalContracts = _repository.contracts.length;

    final expiringContracts = _repository.contracts.where((contract) {
      final days = _parseDate(contract.expirationDate)
          .difference(DateTime.now())
          .inDays;

      return days >= 0 && days <= 30;
    }).length;

    final expiredContracts = _repository.contracts.where((contract) {
      final days = _parseDate(contract.expirationDate)
          .difference(DateTime.now())
          .inDays;

      return days < 0;
    }).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
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
              SizedBox(width: 20),
              StatCard(
                title: 'In scadenza',
                value: expiringContracts.toString(),
                icon: Icons.warning_amber_outlined,
              ),
              SizedBox(width: 20),
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

          String status;

          if (days < 0) {
            status = 'Scaduto';
          } else if (days <= 30) {
            status = 'In scadenza';
          } else {
            status = 'Attivo';
          }

          return DataRow(
            cells: [
              DataCell(Text(contract.client)),
              DataCell(Text(contract.type)),
              DataCell(Text(contract.expirationDate)),
              DataCell(Text(status)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
