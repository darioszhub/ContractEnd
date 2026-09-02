import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ContractFormDialog extends StatefulWidget {
  final Map<String, dynamic>? contract;

  const ContractFormDialog({super.key, this.contract});

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
  final _formKey = GlobalKey<FormState>();

  String _selectedClient = 'Mario Rossi';
  String _selectedFrequency = 'Mensile';
  String? _filePath;

  bool get _isEditing => widget.contract != null;

  @override
  void initState() {
    super.initState();

    final contract = widget.contract;
    _filePath = contract?['filePath'];

    _numberController = TextEditingController(text: contract?['number'] ?? '');

    _typeController = TextEditingController(text: contract?['type'] ?? '');

    _startDateController = TextEditingController(
      text: contract?['startDate'] ?? '',
    );

    _expirationDateController = TextEditingController(
      text: contract?['expirationDate'] ?? '',
    );

    _amountController = TextEditingController(
      text: contract?['amount']?.toString() ?? '',
    );

    _notesController = TextEditingController(text: contract?['notes'] ?? '');

    if (contract != null) {
      _selectedClient = contract['client'];
      _selectedFrequency = contract['frequency'];
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contract = {
      'client': _selectedClient,
      'type': _typeController.text,
      'number': _numberController.text,
      'startDate': _startDateController.text,
      'expirationDate': _expirationDateController.text,
      'amount':
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0,
      'frequency': _selectedFrequency,
      'filePath': _filePath ?? '',
      'notes': _notesController.text,
    };

    Navigator.pop(context, contract);
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

    setState(() {
      _filePath = result.single.path;
    });
  }

  String? _getFileName() {
    if (_filePath == null || _filePath!.isEmpty) {
      return null;
    }

    return _filePath!.split('\\').last;
  }

  void _removePdf() {
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
                DropdownButtonFormField<String>(
                  initialValue: _selectedClient,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il cliente è obbligatorio';
                    }

                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Mario Rossi',
                      child: Text('Mario Rossi'),
                    ),
                    DropdownMenuItem(
                      value: 'Luca Bianchi',
                      child: Text('Luca Bianchi'),
                    ),
                    DropdownMenuItem(
                      value: 'Alfa S.r.l.',
                      child: Text('Alfa S.r.l.'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedClient = value;
                      });
                    }
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

                          if (_getFileName() != null)
                            IconButton(
                              tooltip: 'Rimuovi documento',
                              onPressed: _removePdf,
                              icon: const Icon(Icons.close),
                            ),
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
          onPressed: () => Navigator.pop(context),
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

    super.dispose();
  }
}
