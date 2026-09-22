import 'package:flutter/material.dart';

import '../../models/client.dart';

class AdvancedSearchResult {
  final int? clientId;
  final String? clientType;
  final String? mercCategory;
  final String? invoicePeriod;
  final String? type;
  final String? number;
  final DateTime? startDateFrom;
  final DateTime? startDateTo;
  final DateTime? expirationDateFrom;
  final DateTime? expirationDateTo;
  final DateTime? acquisitionDateFrom;
  final DateTime? acquisitionDateTo;
  final DateTime? expirationNoticeDateFrom;
  final DateTime? expirationNoticeDateTo;
  final double? meterPowerFrom;
  final double? meterPowerTo;
  final double? annualVolumeFrom;
  final double? annualVolumeTo;
  final String? offerType;
  final double? variableSpreadNewFrom;
  final double? variableSpreadNewTo;
  final double? variableSpreadOldFrom;
  final double? variableSpreadOldTo;
  final String? currentManager;
  final String? previousManager;
  final String? agent;
  final String? codagent;
  final String? frequency;
  final double? amountFrom;
  final double? amountTo;

  const AdvancedSearchResult({
    this.clientId,
    this.clientType,
    this.mercCategory,
    this.invoicePeriod,
    this.type,
    this.number,
    this.startDateFrom,
    this.startDateTo,
    this.expirationDateFrom,
    this.expirationDateTo,
    this.acquisitionDateFrom,
    this.acquisitionDateTo,
    this.expirationNoticeDateFrom,
    this.expirationNoticeDateTo,
    this.meterPowerFrom,
    this.meterPowerTo,
    this.annualVolumeFrom,
    this.annualVolumeTo,
    this.offerType,
    this.variableSpreadNewFrom,
    this.variableSpreadNewTo,
    this.variableSpreadOldFrom,
    this.variableSpreadOldTo,
    this.currentManager,
    this.previousManager,
    this.agent,
    this.codagent,
    this.frequency,
    this.amountFrom,
    this.amountTo,
  });

  bool get hasFilters =>
      clientId != null ||
      clientType != null ||
      mercCategory != null ||
      invoicePeriod != null ||
      type != null ||
      number != null ||
      startDateFrom != null ||
      startDateTo != null ||
      expirationDateFrom != null ||
      expirationDateTo != null ||
      acquisitionDateFrom != null ||
      acquisitionDateTo != null ||
      expirationNoticeDateFrom != null ||
      expirationNoticeDateTo != null ||
      meterPowerFrom != null ||
      meterPowerTo != null ||
      annualVolumeFrom != null ||
      annualVolumeTo != null ||
      offerType != null ||
      variableSpreadNewFrom != null ||
      variableSpreadNewTo != null ||
      variableSpreadOldFrom != null ||
      variableSpreadOldTo != null ||
      currentManager != null ||
      previousManager != null ||
      agent != null ||
      codagent != null ||
      frequency != null ||
      amountFrom != null ||
      amountTo != null;
}

class AdvancedSearchDialog extends StatefulWidget {
  final List<Client> clients;
  final AdvancedSearchResult? initialFilters;

  const AdvancedSearchDialog({
    super.key,
    required this.clients,
    this.initialFilters,
  });

  @override
  State<AdvancedSearchDialog> createState() => _AdvancedSearchDialogState();
}

class _AdvancedSearchDialogState extends State<AdvancedSearchDialog> {
  int? _selectedClientId;
  String? _selectedClientType;
  String? _selectedOfferType;
  String? _selectedFrequency;

  late final TextEditingController _mercCategoryController;
  late final TextEditingController _invoicePeriodController;
  late final TextEditingController _typeController;
  late final TextEditingController _numberController;
  late final TextEditingController _currentManagerController;
  late final TextEditingController _previousManagerController;
  late final TextEditingController _agentController;
  late final TextEditingController _codAgentController;

  late final TextEditingController _meterPowerFromController;
  late final TextEditingController _meterPowerToController;
  late final TextEditingController _annualVolumeFromController;
  late final TextEditingController _annualVolumeToController;
  late final TextEditingController _spreadNewFromController;
  late final TextEditingController _spreadNewToController;
  late final TextEditingController _spreadOldFromController;
  late final TextEditingController _spreadOldToController;
  late final TextEditingController _amountFromController;
  late final TextEditingController _amountToController;

  DateTime? _startDateFrom;
  DateTime? _startDateTo;
  DateTime? _expirationDateFrom;
  DateTime? _expirationDateTo;
  DateTime? _acquisitionDateFrom;
  DateTime? _acquisitionDateTo;
  DateTime? _expirationNoticeDateFrom;
  DateTime? _expirationNoticeDateTo;

  @override
  void initState() {
    super.initState();

    final filters = widget.initialFilters;

    _selectedClientId = filters?.clientId;
    _selectedClientType = filters?.clientType;
    _selectedOfferType = filters?.offerType;
    _selectedFrequency = filters?.frequency;

    _mercCategoryController = TextEditingController(
      text: filters?.mercCategory ?? '',
    );
    _invoicePeriodController = TextEditingController(
      text: filters?.invoicePeriod ?? '',
    );
    _typeController = TextEditingController(text: filters?.type ?? '');
    _numberController = TextEditingController(text: filters?.number ?? '');
    _currentManagerController = TextEditingController(
      text: filters?.currentManager ?? '',
    );
    _previousManagerController = TextEditingController(
      text: filters?.previousManager ?? '',
    );
    _agentController = TextEditingController(text: filters?.agent ?? '');
    _codAgentController = TextEditingController(text: filters?.codagent ?? '');

    _meterPowerFromController = _numberControllerFor(filters?.meterPowerFrom);
    _meterPowerToController = _numberControllerFor(filters?.meterPowerTo);
    _annualVolumeFromController = _numberControllerFor(
      filters?.annualVolumeFrom,
    );
    _annualVolumeToController = _numberControllerFor(filters?.annualVolumeTo);
    _spreadNewFromController = _numberControllerFor(
      filters?.variableSpreadNewFrom,
    );
    _spreadNewToController = _numberControllerFor(filters?.variableSpreadNewTo);
    _spreadOldFromController = _numberControllerFor(
      filters?.variableSpreadOldFrom,
    );
    _spreadOldToController = _numberControllerFor(filters?.variableSpreadOldTo);
    _amountFromController = _numberControllerFor(filters?.amountFrom);
    _amountToController = _numberControllerFor(filters?.amountTo);

    _startDateFrom = filters?.startDateFrom;
    _startDateTo = filters?.startDateTo;
    _expirationDateFrom = filters?.expirationDateFrom;
    _expirationDateTo = filters?.expirationDateTo;
    _acquisitionDateFrom = filters?.acquisitionDateFrom;
    _acquisitionDateTo = filters?.acquisitionDateTo;
    _expirationNoticeDateFrom = filters?.expirationNoticeDateFrom;
    _expirationNoticeDateTo = filters?.expirationNoticeDateTo;
  }

  TextEditingController _numberControllerFor(double? value) {
    return TextEditingController(text: value?.toString() ?? '');
  }

  @override
  void dispose() {
    _mercCategoryController.dispose();
    _invoicePeriodController.dispose();
    _typeController.dispose();
    _numberController.dispose();
    _currentManagerController.dispose();
    _previousManagerController.dispose();
    _agentController.dispose();
    _codAgentController.dispose();

    _meterPowerFromController.dispose();
    _meterPowerToController.dispose();
    _annualVolumeFromController.dispose();
    _annualVolumeToController.dispose();
    _spreadNewFromController.dispose();
    _spreadNewToController.dispose();
    _spreadOldFromController.dispose();
    _spreadOldToController.dispose();
    _amountFromController.dispose();
    _amountToController.dispose();

    super.dispose();
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    return double.tryParse(value.replaceAll(',', '.'));
  }

  Future<DateTime?> _pickDate(DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Qualsiasi';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return Expanded(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: value != null
              ? IconButton(onPressed: onClear, icon: const Icon(Icons.clear))
              : const Icon(Icons.calendar_today),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(_formatDate(value)),
          ),
        ),
      ),
    );
  }

  Widget _rangeFields({
    required String label,
    required TextEditingController fromController,
    required TextEditingController toController,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: fromController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Da',
                  suffixText: suffix,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: toController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'A',
                  suffixText: suffix,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedClientId = null;
      _selectedClientType = null;
      _selectedOfferType = null;
      _selectedFrequency = null;

      _mercCategoryController.clear();
      _typeController.clear();
      _numberController.clear();
      _currentManagerController.clear();
      _previousManagerController.clear();
      _agentController.clear();
      _codAgentController.clear();

      _meterPowerFromController.clear();
      _meterPowerToController.clear();
      _annualVolumeFromController.clear();
      _annualVolumeToController.clear();
      _spreadNewFromController.clear();
      _spreadNewToController.clear();
      _spreadOldFromController.clear();
      _spreadOldToController.clear();
      _amountFromController.clear();
      _amountToController.clear();

      _startDateFrom = null;
      _startDateTo = null;
      _expirationDateFrom = null;
      _expirationDateTo = null;
      _acquisitionDateFrom = null;
      _acquisitionDateTo = null;
      _expirationNoticeDateFrom = null;
      _expirationNoticeDateTo = null;
    });
  }

  void _applyFilters() {
    Navigator.pop(
      context,
      AdvancedSearchResult(
        clientId: _selectedClientId,
        clientType: _selectedClientType,
        mercCategory: _mercCategoryController.text.trim().isEmpty
            ? null
            : _mercCategoryController.text.trim(),
        invoicePeriod: _invoicePeriodController.text.trim().isEmpty
            ? null
            : _invoicePeriodController.text.trim(),
        type: _typeController.text.trim().isEmpty
            ? null
            : _typeController.text.trim(),
        number: _numberController.text.trim().isEmpty
            ? null
            : _numberController.text.trim(),
        startDateFrom: _startDateFrom,
        startDateTo: _startDateTo,
        expirationDateFrom: _expirationDateFrom,
        expirationDateTo: _expirationDateTo,
        acquisitionDateFrom: _acquisitionDateFrom,
        acquisitionDateTo: _acquisitionDateTo,
        expirationNoticeDateFrom: _expirationNoticeDateFrom,
        expirationNoticeDateTo: _expirationNoticeDateTo,
        meterPowerFrom: _parseDouble(_meterPowerFromController.text),
        meterPowerTo: _parseDouble(_meterPowerToController.text),
        annualVolumeFrom: _parseDouble(_annualVolumeFromController.text),
        annualVolumeTo: _parseDouble(_annualVolumeToController.text),
        offerType: _selectedOfferType,
        variableSpreadNewFrom: _parseDouble(_spreadNewFromController.text),
        variableSpreadNewTo: _parseDouble(_spreadNewToController.text),
        variableSpreadOldFrom: _parseDouble(_spreadOldFromController.text),
        variableSpreadOldTo: _parseDouble(_spreadOldToController.text),
        currentManager: _currentManagerController.text.trim().isEmpty
            ? null
            : _currentManagerController.text.trim(),
        previousManager: _previousManagerController.text.trim().isEmpty
            ? null
            : _previousManagerController.text.trim(),
        agent: _agentController.text.trim().isEmpty
            ? null
            : _agentController.text.trim(),
        codagent: _codAgentController.text.trim().isEmpty
            ? null
            : _codAgentController.text.trim(),
        frequency: _selectedFrequency,
        amountFrom: _parseDouble(_amountFromController.text),
        amountTo: _parseDouble(_amountToController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ricerca avanzata'),
      content: SizedBox(
        width: 650,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                initialValue: _selectedClientId,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(),
                ),
                items: widget.clients.map((client) {
                  final clientName =
                      client.company != null && client.company!.isNotEmpty
                      ? client.company!
                      : '${client.name} ${client.surname}';

                  return DropdownMenuItem<int>(
                    value: client.id,
                    child: Text(clientName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClientId = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedClientType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo cliente',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Residenziale',
                          child: Text('Residenziale'),
                        ),
                        DropdownMenuItem(value: 'Micro', child: Text('Micro')),
                        DropdownMenuItem(value: 'SME', child: Text('SME')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedClientType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedOfferType,
                      decoration: const InputDecoration(
                        labelText: 'Offerta prezzo',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Prezzo Variabile',
                          child: Text('Prezzo Variabile'),
                        ),
                        DropdownMenuItem(
                          value: 'Prezzo Fisso',
                          child: Text('Prezzo Fisso'),
                        ),
                        DropdownMenuItem(
                          value: 'Prezzo Mix',
                          child: Text('Prezzo Mix'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedOfferType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _textField(
                label: 'Categoria merceologica',
                controller: _mercCategoryController,
              ),

              const SizedBox(height: 16),
              _textField(
                label: 'Fattura cliente periodo',
                controller: _invoicePeriodController,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _textField(
                      label: 'Tipo contratto',
                      controller: _typeController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      label: 'Numero contratto',
                      controller: _numberController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data inizio',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateField(
                    label: 'Da',
                    value: _startDateFrom,
                    onTap: () async {
                      final date = await _pickDate(_startDateFrom);
                      if (date != null) {
                        setState(() {
                          _startDateFrom = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _startDateFrom = null;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _dateField(
                    label: 'A',
                    value: _startDateTo,
                    onTap: () async {
                      final date = await _pickDate(_startDateTo);
                      if (date != null) {
                        setState(() {
                          _startDateTo = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _startDateTo = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data scadenza',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateField(
                    label: 'Da',
                    value: _expirationDateFrom,
                    onTap: () async {
                      final date = await _pickDate(_expirationDateFrom);
                      if (date != null) {
                        setState(() {
                          _expirationDateFrom = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _expirationDateFrom = null;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _dateField(
                    label: 'A',
                    value: _expirationDateTo,
                    onTap: () async {
                      final date = await _pickDate(_expirationDateTo);
                      if (date != null) {
                        setState(() {
                          _expirationDateTo = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _expirationDateTo = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data acquisizione',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateField(
                    label: 'Da',
                    value: _acquisitionDateFrom,
                    onTap: () async {
                      final date = await _pickDate(_acquisitionDateFrom);
                      if (date != null) {
                        setState(() {
                          _acquisitionDateFrom = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _acquisitionDateFrom = null;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _dateField(
                    label: 'A',
                    value: _acquisitionDateTo,
                    onTap: () async {
                      final date = await _pickDate(_acquisitionDateTo);
                      if (date != null) {
                        setState(() {
                          _acquisitionDateTo = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _acquisitionDateTo = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data notifica scadenza offerta',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateField(
                    label: 'Da',
                    value: _expirationNoticeDateFrom,
                    onTap: () async {
                      final date = await _pickDate(_expirationNoticeDateFrom);
                      if (date != null) {
                        setState(() {
                          _expirationNoticeDateFrom = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _expirationNoticeDateFrom = null;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _dateField(
                    label: 'A',
                    value: _expirationNoticeDateTo,
                    onTap: () async {
                      final date = await _pickDate(_expirationNoticeDateTo);
                      if (date != null) {
                        setState(() {
                          _expirationNoticeDateTo = date;
                        });
                      }
                    },
                    onClear: () {
                      setState(() {
                        _expirationNoticeDateTo = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _rangeFields(
                label: 'Importo',
                fromController: _amountFromController,
                toController: _amountToController,
                suffix: '€',
              ),
              const SizedBox(height: 16),

              _rangeFields(
                label: 'Potenza contatore',
                fromController: _meterPowerFromController,
                toController: _meterPowerToController,
                suffix: 'kW',
              ),
              const SizedBox(height: 16),

              _rangeFields(
                label: 'Volumi annui',
                fromController: _annualVolumeFromController,
                toController: _annualVolumeToController,
                suffix: 'kWh',
              ),
              const SizedBox(height: 16),

              _rangeFields(
                label: 'Spread nuova tariffa',
                fromController: _spreadNewFromController,
                toController: _spreadNewToController,
              ),
              const SizedBox(height: 16),

              _rangeFields(
                label: 'Spread vecchia tariffa',
                fromController: _spreadOldFromController,
                toController: _spreadOldToController,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequenza pagamento',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Mensile', child: Text('Mensile')),
                  DropdownMenuItem(
                    value: 'Trimestrale',
                    child: Text('Trimestrale'),
                  ),
                  DropdownMenuItem(
                    value: 'Semestrale',
                    child: Text('Semestrale'),
                  ),
                  DropdownMenuItem(value: 'Annuale', child: Text('Annuale')),
                  DropdownMenuItem(
                    value: 'Una tantum',
                    child: Text('Una tantum'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              _textField(
                label: 'Gestore attuale',
                controller: _currentManagerController,
              ),
              const SizedBox(height: 16),

              _textField(
                label: 'Gestore precedente',
                controller: _previousManagerController,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _textField(
                      label: 'Agente',
                      controller: _agentController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      label: 'Codice agente',
                      controller: _codAgentController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearFilters,
          child: const Text('Azzera filtri'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _applyFilters,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Applica filtri'),
        ),
      ],
    );
  }
}
