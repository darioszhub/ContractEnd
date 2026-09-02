import 'package:flutter/material.dart';

class ClientFormDialog extends StatefulWidget {
  final Map<String, dynamic>? client;

  const ClientFormDialog({super.key, this.client});

  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _companyController;
  late final TextEditingController _taxCodeController;
  late final TextEditingController _vatController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _notesController;

  bool get _isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();

    final client = widget.client;

    _nameController = TextEditingController(text: client?['name'] ?? '');

    _surnameController = TextEditingController(text: client?['surname'] ?? '');

    _companyController = TextEditingController(text: client?['company'] ?? '');

    _taxCodeController = TextEditingController(text: client?['taxCode'] ?? '');

    _vatController = TextEditingController(text: client?['vat'] ?? '');

    _phoneController = TextEditingController(text: client?['phone'] ?? '');

    _emailController = TextEditingController(text: client?['email'] ?? '');

    _addressController = TextEditingController(text: client?['address'] ?? '');

    _cityController = TextEditingController(text: client?['city'] ?? '');

    _notesController = TextEditingController(text: client?['notes'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _companyController.dispose();
    _taxCodeController.dispose();
    _vatController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final client = {
      'name': _nameController.text.trim(),
      'surname': _surnameController.text.trim(),
      'company': _companyController.text.trim(),
      'taxCode': _taxCodeController.text.trim(),
      'vat': _vatController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'notes': _notesController.text.trim(),
      'contracts': widget.client?['contracts'] ?? 0,
    };

    Navigator.pop(context, client);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Modifica cliente' : 'Nuovo cliente'),
      content: SizedBox(
        width: 650,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameController,
                        decoration: const InputDecoration(labelText: 'Cognome'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Ragione sociale',
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _taxCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Codice fiscale',
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _vatController,
                        decoration: const InputDecoration(
                          labelText: 'Partita IVA',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefono',
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Indirizzo'),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'Città'),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
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
          child: Text(_isEditing ? 'Salva modifiche' : 'Salva cliente'),
        ),
      ],
    );
  }
}
