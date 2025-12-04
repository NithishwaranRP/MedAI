/// Configuration file for API keys
/// 
/// IMPORTANT: This file should be added to .gitignore for production
/// Never commit API keys to version control!
/// 
/// For production use:
/// 1. Copy this file and remove the .example extension
/// 2. Replace the API key with your actual key
/// 3. Add config.dart to .gitignore
/// 
/// Alternative: Use flutter_dotenv with .env file (recommended)
class AppConfig {
  // API key is currently stored in gemini_service.dart
  // For better security, you can move it here:
  // static const String geminiApiKey = 'your_api_key_here';
  
  static const String geminiModel = 'gemini-2.5-flash';
  
  // You can add other configuration values here
  // static const String appVersion = '1.0.0';
  // static const bool isProduction = bool.fromEnvironment('dart.vm.product');
}

