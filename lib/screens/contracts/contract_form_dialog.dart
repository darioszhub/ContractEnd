import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../services/gemini_service.dart';
import '../../models/contract.dart';
import '../../models/client.dart';

class ContractFormResult {
  final Contract contract;
  final String? oldFilePath;

  ContractFormResult({required this.contract, this.oldFilePath});
}

class ContractFormDialog extends StatefulWidget {
  final Contract? contract;
  final List<Client> clients;

  const ContractFormDialog({super.key, this.contract, required this.clients});

  @override
  State<ContractFormDialog> createState() => _ContractFormDialogState();
}

class _ContractFormDialogState extends State<ContractFormDialog> {
  late final TextEditingController _numberController;
  late final TextEditingController _typeController;
  late final TextEditingController _startDateController;
  late final TextEditingController _expirationDateController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final TextEditingController _agentController;
  late final TextEditingController _codAgentController;
  final _formKey = GlobalKey<FormState>();

  int? _selectedClientId;
  String _selectedFrequency = 'Mensile';
  String? _filePath;
  String? _oldFilePath;
  String? _newFilePath;

  bool get _isEditing => widget.contract != null;
  bool _isAnalyzingWithGemini = false;

  @override
  void initState() {
    super.initState();

    final contract = widget.contract;
    _filePath = contract?.filePath;

    _numberController = TextEditingController(text: contract?.number ?? '');

    _typeController = TextEditingController(text: contract?.type ?? '');

    _startDateController = TextEditingController(
      text: contract?.startDate ?? '',
    );

    _expirationDateController = TextEditingController(
      text: contract?.expirationDate ?? '',
    );

    _amountController = TextEditingController(
      text: contract?.amount?.toString() ?? '',
    );

    _notesController = TextEditingController(text: contract?.notes ?? '');

    _agentController = TextEditingController(text: contract?.agent ?? '');

    _codAgentController = TextEditingController(text: contract?.codagent ?? '');

    if (contract != null) {
      _selectedClientId = contract.clientId;
      _selectedFrequency = contract.frequency;
    }
  }

  String? _findSimilarValue(
    String value,
    List<String> allowedValues, {
    double threshold = 0.75,
  }) {
    final normalizedValue = value.toLowerCase().trim();

    if (normalizedValue.isEmpty) {
      return null;
    }

    String? bestMatch;
    double bestSimilarity = 0;

    for (final allowedValue in allowedValues) {
      final normalizedAllowedValue = allowedValue.toLowerCase().trim();

      final maxLength = normalizedValue.length > normalizedAllowedValue.length
          ? normalizedValue.length
          : normalizedAllowedValue.length;

      if (maxLength == 0) {
        continue;
      }

      final distance = _levenshteinDistance(
        normalizedValue,
        normalizedAllowedValue,
      );

      final similarity = 1 - (distance / maxLength);

      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatch = allowedValue;
      }
    }

    if (bestSimilarity >= threshold) {
      return bestMatch;
    }

    return null;
  }

  int _levenshteinDistance(String a, String b) {
    final previousRow = List<int>.generate(b.length + 1, (index) => index);

    for (var i = 0; i < a.length; i++) {
      var currentRow = List<int>.filled(b.length + 1, 0);

      currentRow[0] = i + 1;

      for (var j = 0; j < b.length; j++) {
        final insertCost = currentRow[j] + 1;
        final deleteCost = previousRow[j + 1] + 1;
        final replaceCost = previousRow[j] + (a[i] == b[j] ? 0 : 1);

        currentRow[j + 1] = [
          insertCost,
          deleteCost,
          replaceCost,
        ].reduce((a, b) => a < b ? a : b);
      }

      previousRow.setAll(0, currentRow);
    }

    return previousRow[b.length];
  }

  Future<void> _analyzeWithGemini() async {
    if (_filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleziona prima un documento PDF.')),
      );

      return;
    }

    setState(() {
      _isAnalyzingWithGemini = true;
    });

    try {
      final data = await GeminiService.analyzeContract(_filePath!);

      if (!mounted) return;

      _typeController.text = data['tipo_contratto']?.toString() ?? '';

      _numberController.text = data['numero_contratto']?.toString() ?? '';

      _startDateController.text = data['data_inizio']?.toString() ?? '';

      final expirationDate = data['data_scadenza']?.toString();
      final notes = data['note']?.toString() ?? '';

      if (expirationDate != null && expirationDate.trim().isNotEmpty) {
        if (expirationDate.toLowerCase().contains('tempo indeterminato')) {
          _expirationDateController.text = '01/01/2199';
        } else {
          _expirationDateController.text = expirationDate;
        }
      } else if (notes.toLowerCase().contains('tempo indeterminato')) {
        _expirationDateController.text = '01/01/2199';
      } else {
        _expirationDateController.clear();
      }

      final amount = data['importo'];

      _amountController.text = amount?.toString() ?? '';

      final frequency = data['frequenza_pagamento']?.toString().trim();

      if (frequency != null && frequency.isNotEmpty) {
        final matchingFrequency = _findSimilarValue(frequency, const [
          'Mensile',
          'Trimestrale',
          'Semestrale',
          'Annuale',
          'Una tantum',
        ]);

        if (matchingFrequency != null) {
          _selectedFrequency = matchingFrequency;
        }
      }

      _notesController.text = data['note']?.toString() ?? '';

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dati estratti dal contratto con Gemini.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'analisi del contratto: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzingWithGemini = false;
        });
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contract = Contract(
      id: widget.contract?.id,
      clientId: _selectedClientId!,
      type: _typeController.text.trim(),
      number: _numberController.text.trim(),
      startDate: _startDateController.text,
      expirationDate: _expirationDateController.text,
      amount: double.tryParse(_amountController.text.replaceAll(',', '.')),
      frequency: _selectedFrequency,
      agent: _agentController.text.trim(),
      codagent: _codAgentController.text.trim(),
      filePath: _filePath,
      notes: _notesController.text.trim(),
      timestampINS: widget.contract?.timestampINS ?? DateTime.now(),
      timestampEDT: widget.contract?.timestampEDT,
    );

    Navigator.pop(
      context,
      ContractFormResult(contract: contract, oldFilePath: _oldFilePath),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    final day = pickedDate.day.toString().padLeft(2, '0');
    final month = pickedDate.month.toString().padLeft(2, '0');
    final year = pickedDate.year.toString();

    controller.text = '$day/$month/$year';
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result.isEmpty) return;

    final selectedFile = File(result.single.path!);

    final appDirectory = await getApplicationSupportDirectory();

    final documentsDirectory = Directory(
      path.join(appDirectory.path, 'documents'),
    );

    if (!await documentsDirectory.exists()) {
      await documentsDirectory.create(recursive: true);
    }

    final originalName = path.basenameWithoutExtension(selectedFile.path);
    final extension = path.extension(selectedFile.path);

    var fileName = '$originalName$extension';
    var destinationPath = path.join(documentsDirectory.path, fileName);

    var counter = 1;

    while (await File(destinationPath).exists()) {
      fileName = '$originalName ($counter)$extension';

      destinationPath = path.join(documentsDirectory.path, fileName);

      counter++;
    }

    final copiedFile = await selectedFile.copy(destinationPath);

    if (_filePath != null && _filePath != copiedFile.path) {
      _oldFilePath = _filePath;
    }

    setState(() {
      _filePath = copiedFile.path;
      _newFilePath = copiedFile.path;
    });
  }

  Future<void> _openPdf() async {
    if (_filePath == null || _filePath!.isEmpty) {
      return;
    }

    final file = File(_filePath!);

    if (!await file.exists()) {
      return;
    }

    await Process.start('explorer.exe', [_filePath!]);
  }

  String? _getFileName() {
    if (_filePath == null || _filePath!.isEmpty) {
      return null;
    }

    return _filePath!.split('\\').last;
  }

  void _removePdf() {
    if (_filePath != null) {
      _oldFilePath = _filePath;
    }

    setState(() {
      _filePath = null;
    });
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    final parts = value.split('/');

    if (parts.length != 3) {
      return null;
    }

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Modifica contratto' : 'Nuovo contratto'),
      content: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  initialValue: _selectedClientId,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  validator: (value) {
                    if (value == null) {
                      return 'Il cliente è obbligatorio';
                    }

                    return null;
                  },
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
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo di contratto',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Il tipo di contratto è obbligatorio';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'Numero contratto',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data inizio',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La data di inizio è obbligatoria';
                    }

                    return null;
                  },
                  onTap: () {
                    _selectDate(_startDateController);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _expirationDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data scadenza',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La data di scadenza è obbligatoria';
                    }

                    final startDate = _parseDate(_startDateController.text);
                    final expirationDate = _parseDate(value);

                    if (startDate != null &&
                        expirationDate != null &&
                        expirationDate.isBefore(startDate)) {
                      return 'La data di scadenza non può essere precedente alla data di inizio';
                    }

                    return null;
                  },
                  onTap: () {
                    _selectDate(_expirationDateController);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Importo',
                    suffixText: '€',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    final amount = double.tryParse(value.replaceAll(',', '.'));

                    if (amount == null) {
                      return 'Inserisci un importo valido';
                    }

                    if (amount < 0) {
                      return 'L\'importo non può essere negativo';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedFrequency,
                  decoration: const InputDecoration(
                    labelText: 'Frequenza pagamento',
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
                    if (value != null) {
                      setState(() {
                        _selectedFrequency = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _agentController,
                  decoration: const InputDecoration(labelText: 'Agente'),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _codAgentController,
                  decoration: const InputDecoration(labelText: 'Codice agente'),
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Documento contratto',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _pickPdf,
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Seleziona PDF'),
                          ),

                          const SizedBox(width: 12),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              _getFileName() ?? 'Nessun documento selezionato',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _getFileName() == null
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ),

                          if (_getFileName() != null) ...[
                            IconButton(
                              tooltip: _isAnalyzingWithGemini
                                  ? 'Analisi in corso...'
                                  : 'Analizza con Gemini',
                              onPressed:
                                  _filePath == null || _isAnalyzingWithGemini
                                  ? null
                                  : _analyzeWithGemini,
                              icon: _isAnalyzingWithGemini
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                            ),
                            IconButton(
                              tooltip: 'Apri PDF',
                              onPressed: _openPdf,
                              icon: const Icon(Icons.picture_as_pdf_outlined),
                            ),
                            IconButton(
                              tooltip: 'Rimuovi documento',
                              onPressed: _removePdf,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);

            if (_newFilePath != null) {
              final newFile = File(_newFilePath!);

              if (await newFile.exists()) {
                await newFile.delete();
              }
            }

            navigator.pop();
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(_isEditing ? 'Salva modifiche' : 'Salva contratto'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _typeController.dispose();
    _startDateController.dispose();
    _expirationDateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _agentController.dispose();
    _codAgentController.dispose();

    super.dispose();
  }
}
