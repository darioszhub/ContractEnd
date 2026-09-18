import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _geminiApiKey = 'gemini_api_key';

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: _geminiApiKey, value: apiKey);
  }

  static Future<String?> getGeminiApiKey() async {
    return await _storage.read(key: _geminiApiKey);
  }

  static Future<void> deleteGeminiApiKey() async {
    await _storage.delete(key: _geminiApiKey);
  }
}
