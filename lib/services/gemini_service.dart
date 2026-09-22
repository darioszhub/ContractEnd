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
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'model': _model,
        'input': [
          {
            'type': 'text',
            'text': '''
Analizza questo contratto e restituisci esclusivamente i dati richiesti.

REGOLE IMPORTANTI:
- Non inventare mai informazioni.
- Non fare supposizioni.
- Non dedurre un valore se non è chiaramente presente nel documento.
- Se un dato non è presente, restituisci null.
- Se un dato non è leggibile o non può essere identificato con sufficiente certezza, restituisci null.
- Cerca le informazioni in tutto il documento, non soltanto nelle prime pagine.
- Se lo stesso dato compare più volte, utilizza quello riferito effettivamente al contratto.
- Per gli importi e gli altri valori numerici restituisci esclusivamente il numero, senza simboli o unità di misura.
- Per le date restituisci esclusivamente il formato DD/MM/YYYY.
- Non trasformare informazioni vaghe in valori precisi.
- Se il contratto è a tempo indeterminato e non è presente una vera data di scadenza, restituisci null per data_scadenza.
- Per frequenza_pagamento utilizza, quando possibile, uno dei seguenti valori:
  Mensile
  Trimestrale
  Semestrale
  Annuale
  Una tantum
- Per clientType utilizza, quando chiaramente identificabile, uno dei seguenti valori:
  Residenziale
  Micro
  SME
- Per offerType utilizza, quando chiaramente identificabile, uno dei seguenti valori:
  Prezzo Variabile
  Prezzo Fisso
  Prezzo Mix

Estrai i seguenti dati:
- tipo contratto
- numero contratto
- data inizio
- data scadenza
- importo
- frequenza pagamento
- agente
- codice agente
- tipo cliente
- categoria merceologica
- periodo fattura cliente
- potenza contatore
- volumi annui
- tipologia offerta prezzo
- spread nuova tariffa
- spread vecchia tariffa
- gestore attuale
- data acquisizione
- gestore precedente
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
                'description':
                    'Numero o codice identificativo del contratto.',
              },
              'data_inizio': {
                'type': ['string', 'null'],
                'description':
                    'Data di inizio del contratto nel formato DD/MM/YYYY.',
              },
              'data_scadenza': {
                'type': ['string', 'null'],
                'description':
                    'Data di scadenza del contratto nel formato DD/MM/YYYY. Null se non presente o se il contratto è a tempo indeterminato.',
              },
              'importo': {
                'type': ['number', 'null'],
                'description': 'Importo economico del contratto.',
              },
              'frequenza_pagamento': {
                'type': ['string', 'null'],
                'description':
                    'Frequenza di pagamento del contratto.',
              },
              'agente': {
                'type': ['string', 'null'],
                'description': 'Nome o identificativo dell’agente.',
              },
              'codice_agente': {
                'type': ['string', 'null'],
                'description': 'Codice identificativo dell’agente.',
              },
              'tipo_cliente': {
                'type': ['string', 'null'],
                'description':
                    'Tipologia del cliente: Residenziale, Micro oppure SME.',
              },
              'categoria_merceologica': {
                'type': ['string', 'null'],
                'description': 'Categoria merceologica del cliente.',
              },
              'periodo_fattura_cliente': {
                'type': ['string', 'null'],
                'description':
                    'Periodo della fattura cliente, se presente.',
              },
              'potenza_contatore': {
                'type': ['number', 'null'],
                'description':
                    'Potenza del contatore come valore numerico.',
              },
              'volumi_annui': {
                'type': ['number', 'null'],
                'description':
                    'Volume annuo come valore numerico.',
              },
              'tipologia_offerta': {
                'type': ['string', 'null'],
                'description':
                    'Tipologia di offerta: Prezzo Variabile, Prezzo Fisso oppure Prezzo Mix.',
              },
              'spread_nuova_tariffa': {
                'type': ['number', 'null'],
                'description':
                    'Spread relativo alla nuova tariffa.',
              },
              'spread_vecchia_tariffa': {
                'type': ['number', 'null'],
                'description':
                    'Spread relativo alla vecchia tariffa.',
              },
              'gestore_attuale': {
                'type': ['string', 'null'],
                'description': 'Gestore attuale.',
              },
              'data_acquisizione': {
                'type': ['string', 'null'],
                'description':
                    'Data di acquisizione nel formato DD/MM/YYYY.',
              },
              'gestore_precedente': {
                'type': ['string', 'null'],
                'description': 'Gestore precedente.',
              },
              'note': {
                'type': ['string', 'null'],
                'description':
                    'Informazioni aggiuntive rilevanti presenti nel contratto.',
              },
            },
            'required': [
              'tipo_contratto',
              'numero_contratto',
              'data_inizio',
              'data_scadenza',
              'importo',
              'frequenza_pagamento',
              'agente',
              'codice_agente',
              'tipo_cliente',
              'categoria_merceologica',
              'periodo_fattura_cliente',
              'potenza_contatore',
              'volumi_annui',
              'tipologia_offerta',
              'spread_nuova_tariffa',
              'spread_vecchia_tariffa',
              'gestore_attuale',
              'data_acquisizione',
              'gestore_precedente',
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