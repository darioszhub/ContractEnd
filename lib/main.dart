import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'database/database.dart';
import 'services/notification_service.dart';
import 'repositories/setting_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;
  await NotificationService.instance.initialize();
  final setting = await SettingRepository.instance.get();

  if (setting.checkAtStartup) {
    await NotificationService.instance.checkAllContracts();
  }

  Timer.periodic(const Duration(hours: 1), (_) async {
    print('Controllo periodico delle scadenze');
    final currentSetting = await SettingRepository.instance.get();

    if (!currentSetting.notificationsEnabled) {
      return;
    }

    await NotificationService.instance.checkAllContracts();
  });

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const DashboardScreen(),
    );
  }
}
