import 'package:flutter/material.dart';

import '../../models/setting.dart';
import '../../repositories/setting_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingRepository _repository = SettingRepository.instance;

  Setting? _setting;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final setting = await _repository.get();

    if (!mounted) return;

    setState(() {
      _setting = setting;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impostazioni',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Configura il comportamento dell\'applicazione e delle notifiche',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildSettings(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    final setting = _setting!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔔 Notifiche',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Abilita notifiche'),
            value: setting.notificationsEnabled,
            onChanged: null,
          ),

          const SizedBox(height: 20),

          const Text(
            'Controllo notifiche',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Controlla le scadenze all\'avvio dell\'app',
            ),
            value: setting.checkAtStartup,
            onChanged: null,
          ),

          const SizedBox(height: 20),

          const Text(
            'Avvisi prima della scadenza',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('30 giorni prima'),
            value: setting.notify30Days,
            onChanged: null,
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('15 giorni prima'),
            value: setting.notify15Days,
            onChanged: null,
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('7 giorni prima'),
            value: setting.notify7Days,
            onChanged: null,
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('1 giorno prima'),
            value: setting.notify1Day,
            onChanged: null,
          ),

          const SizedBox(height: 20),

          const Text(
            'Contratti scaduti',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Notifica per i contratti già scaduti',
            ),
            value: setting.notifyExpired,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}