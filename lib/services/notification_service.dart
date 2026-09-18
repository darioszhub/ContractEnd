import 'dart:io';

import 'package:flutter_desktop_notifications/flutter_desktop_notifications.dart';

import '../models/contract.dart';
import '../models/notification.dart';
import '../repositories/client_repository.dart';
import '../repositories/contract_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/setting_repository.dart';

class NotificationService {
  Function(int contractId)? onOpenContract;
  Function()? onNotificationCreated;

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
      //print('Azione notifica ricevuta: ${details.arguments}');

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

  Future<void> checkContractExpiration(Contract contract) async {
    final setting = await SettingRepository.instance.get();

    if (!setting.notificationsEnabled) {
      //print('Notifiche disabilitate');
      return;
    }

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

    /* print(
      'Contratto ${contract.number}: mancano $daysUntilExpiration giorni alla scadenza',
    ); */

    int? notificationDays;

    if (daysUntilExpiration < 0) {
      if (setting.notifyExpired) {
        notificationDays = -1;
      }
    } else if (daysUntilExpiration == 0) {
      if (setting.notifyOnExpiration) {
        notificationDays = 0;
      }
    } else {
      if (daysUntilExpiration <= 30 && setting.notify30Days) {
        notificationDays = 30;
      }

      if (daysUntilExpiration <= 15 && setting.notify15Days) {
        notificationDays = 15;
      }

      if (daysUntilExpiration <= 7 && setting.notify7Days) {
        notificationDays = 7;
      }

      if (daysUntilExpiration <= 1 && setting.notify1Day) {
        notificationDays = 1;
      }
    }

    if (notificationDays == null) {
      return;
    }

    final alreadyNotified = await NotificationRepository.instance
        .existsForContractAndDays(contract.id!, notificationDays);

    if (alreadyNotified) {
      return;
    }

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

    final notification = Notification(
      contractId: contract.id!,
      type: 'scadenza',
      title: title,
      message: message,
      daysBefore: notificationDays,
      isRead: false,
      timestampINS: DateTime.now(),
    );

    await NotificationRepository.instance.insert(notification);
    onNotificationCreated?.call();

    await _notifier.show(
      NotificationMessage.fromPluginTemplate(
        'contract-${contract.id}-$daysUntilExpiration',
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

  Future<void> checkAllContracts() async {
    final contracts = await ContractRepository.instance.getAll();

    //print('Contratti trovati: ${contracts.length}');

    for (final contract in contracts) {
      await checkContractExpiration(contract);
    }
  }
}
