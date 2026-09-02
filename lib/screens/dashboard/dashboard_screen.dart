import 'package:flutter/material.dart';

import '../../widgets/app_sidebar.dart';
import '../../widgets/stat_card.dart';
import '../clients/clients_screen.dart';
import '../contracts/contracts_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

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

  Widget _buildDashboard() {
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
            children: const [
              StatCard(
                title: 'Contratti',
                value: '128',
                icon: Icons.description_outlined,
              ),
              SizedBox(width: 20),
              StatCard(
                title: 'In scadenza',
                value: '12',
                icon: Icons.warning_amber_outlined,
              ),
              SizedBox(width: 20),
              StatCard(title: 'Scaduti', value: '4', icon: Icons.error_outline),
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
        rows: const [
          DataRow(
            cells: [
              DataCell(Text('Mario Rossi')),
              DataCell(Text('Assistenza')),
              DataCell(Text('15/09/2026')),
              DataCell(Text('In scadenza')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('Alfa S.r.l.')),
              DataCell(Text('Consulenza')),
              DataCell(Text('20/09/2026')),
              DataCell(Text('In scadenza')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('Luca Bianchi')),
              DataCell(Text('Manutenzione')),
              DataCell(Text('12/11/2026')),
              DataCell(Text('Attivo')),
            ],
          ),
        ],
      ),
    );
  }
}
