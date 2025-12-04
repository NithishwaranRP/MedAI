/// Configuration file example
/// 
/// For production use, create a config.dart file (add to .gitignore)
/// and store your API key there instead of hardcoding it.
/// 
/// Example config.dart:
/// 
/// class AppConfig {
///   static const String geminiApiKey = 'your_api_key_here';
///   static const String geminiModel = 'gemini-2.5-flash';
/// }
/// 
/// Then update lib/services/gemini_service.dart:
/// 
/// import '../config/config.dart';
/// 
/// static const String _apiKey = AppConfig.geminiApiKey;

class AppConfig {
  // TODO: Move API key to environment variables or secure storage
  // For now, API key is stored in gemini_service.dart
  // 
  // Recommended approach:
  // 1. Use flutter_dotenv package with .env file
  // 2. Or use flutter_secure_storage for sensitive data
  // 3. Never commit API keys to version control
  
  static const String geminiModel = 'gemini-2.5-flash';
}



