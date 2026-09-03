import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

  runApp(const ContractEndApp());
}

class ContractEndApp extends StatelessWidget {
  const ContractEndApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContractEnd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}