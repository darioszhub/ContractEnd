import 'dart:io';

import 'package:flutter_desktop_notifications/flutter_desktop_notifications.dart';

import '../models/contract.dart';
import '../repositories/client_repository.dart';
import '../repositories/contract_repository.dart';

class NotificationService {
  Function(int contractId)? onOpenContract;

  static final NotificationService instance = NotificationService._internal();

  NotificationService._internal();

  static const String _appId = 'com.contractend.app';
  static const String _appName = 'ContractEnd';

  final DesktopNotifier _notifier = DesktopNotifier(
    appName: _appName,
    appId: _appId,
  );

  Future<void> initialize() async {
    if (Platform.isWindows) {
      await WindowsNotification.registerAumid(
        aumid: _appId,
        displayName: _appName,
      );
    }

    await _notifier.requestPermission();

    _notifier.setCallback((details) {
      print('Azione notifica ricevuta: ${details.arguments}');

      final arguments = details.arguments;

      if (arguments == null) {
        return;
      }

      if (arguments.startsWith('action:open-contract:')) {
        final contractId = int.tryParse(
          arguments.replaceFirst('action:open-contract:', ''),
        );

        if (contractId != null) {
          onOpenContract?.call(contractId);
        }
      }
    });
  }

  Future<void> showTestNotification() async {
    await _notifier.show(
      NotificationMessage.fromPluginTemplate(
        'test-notification',
        'ContractEnd',
        'Le notifiche di ContractEnd funzionano correttamente!',
      ),
    );
  }

  Future<void> checkContractExpiration(Contract contract) async {
    final parts = contract.expirationDate.split('/');

    final expirationDate = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    final daysUntilExpiration = expirationDate
        .difference(DateTime.now())
        .inDays;

    final clients = await ClientRepository.instance.getAll();

    final client = clients.firstWhere(
      (client) => client.id == contract.clientId,
    );

    final clientName =
        client.company != null && client.company!.trim().isNotEmpty
        ? client.company!
        : '${client.name} ${client.surname}';

    print(
      'Contratto ${contract.number}: mancano $daysUntilExpiration giorni alla scadenza',
    );

    if (daysUntilExpiration <= 30) {
      String title;
      String message;

      if (daysUntilExpiration > 0) {
        title = '⚠️ Contratto in scadenza';
        message =
            'Il contratto di $clientName con numero ${contract.number} scade tra $daysUntilExpiration giorni.';
      } else if (daysUntilExpiration == 0) {
        title = '🔴 Contratto in scadenza';
        message =
            'Il contratto di $clientName con numero ${contract.number} scade oggi.';
      } else {
        title = '🔴 Contratto scaduto';
        message =
            'Il contratto di $clientName con numero ${contract.number} è scaduto da ${daysUntilExpiration.abs()} giorni.';
      }

      await _notifier.show(
        NotificationMessage.fromPluginTemplate(
          'contract-${contract.id}-30',
          title,
          message,
          actions: [
            NotificationAction(
              content: 'Apri contratto',
              arguments: 'action:open-contract:${contract.id}',
            ),
          ],
        ),
      );
    }
  }

  Future<void> checkAllContracts() async {
    final contracts = await ContractRepository.instance.getAll();

    print('Contratti trovati: ${contracts.length}');

    for (final contract in contracts) {
      await checkContractExpiration(contract);
    }
  }
}
