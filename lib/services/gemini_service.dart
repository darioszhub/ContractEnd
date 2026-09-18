import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'secure_storage_service.dart';

class GeminiService {
  static const String _model = 'gemini-3.6-flash';

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/interactions';

  static Future<Map<String, dynamic>> analyzeContract(String filePath) async {
    final apiKey = await SecureStorageService.getGeminiApiKey();

    if (apiKey == null || apiKey.trim().isEmpty) {
      throw Exception('API Key Gemini non configurata.');
    }

    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('Il file PDF non esiste.');
    }

    final pdfBytes = await file.readAsBytes();
    final pdfBase64 = base64Encode(pdfBytes);

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': apiKey},
      body: jsonEncode({
        'model': _model,
        'input': [
          {
            'type': 'text',
            'text': '''
              Analizza questo contratto e restituisci esclusivamente i dati richiesti.
              Non inventare informazioni che non sono presenti nel documento.
              Se un dato non è presente o non è leggibile, restituisci null.

              Estrai:
              - tipo contratto
              - numero contratto
              - data inizio
              - data scadenza
              - importo
              - frequenza pagamento
              - note
              ''',
          },
          {
            'type': 'document',
            'data': pdfBase64,
            'mime_type': 'application/pdf',
          },
        ],
        'response_format': {
          'type': 'text',
          'mime_type': 'application/json',
          'schema': {
            'type': 'object',
            'properties': {
              'tipo_contratto': {
                'type': ['string', 'null'],
                'description': 'Tipo o categoria del contratto.',
              },
              'numero_contratto': {
                'type': ['string', 'null'],
                'description': 'Numero o codice identificativo del contratto.',
              },
              'data_inizio': {
                'type': ['string', 'null'],
                'description': 'Data di inizio del contratto, preferibilmente nel formato YYYY-MM-DD.',
              },
              'data_scadenza': {
                'type': ['string', 'null'],
                'description': 'Data di scadenza del contratto, preferibilmente nel formato YYYY-MM-DD.',
              },
              'importo': {
                'type': ['number', 'null'],
                'description': 'Importo economico del contratto.',
              },
              'frequenza_pagamento': {
                'type': ['string', 'null'],
                'description': 'Frequenza di pagamento, ad esempio mensile, trimestrale o annuale.',
              },
              'note': {
                'type': ['string', 'null'],
                'description': 'Eventuali informazioni aggiuntive rilevanti presenti nel contratto.',
              },
            },
            'required': [
              'tipo_contratto',
              'numero_contratto',
              'data_inizio',
              'data_scadenza',
              'importo',
              'frequenza_pagamento',
              'note',
            ],
          },
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Errore Gemini (${response.statusCode}): ${response.body}',
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    final steps = responseData['steps'] as List<dynamic>?;

    if (steps == null) {
      throw Exception('Risposta Gemini non valida: nessuno step trovato.');
    }

    for (final step in steps) {
      if (step is! Map<String, dynamic>) {
        continue;
      }

      if (step['type'] != 'model_output') {
        continue;
      }

      final content = step['content'] as List<dynamic>?;

      if (content == null) {
        continue;
      }

      for (final item in content) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        if (item['type'] != 'text') {
          continue;
        }

        final text = item['text'];

        if (text is! String || text.trim().isEmpty) {
          continue;
        }

        final extractedData = jsonDecode(text);

        if (extractedData is Map<String, dynamic>) {

          return extractedData;
        }
      }
    }

    throw Exception('Gemini non ha restituito dati strutturati.');
  }
}
