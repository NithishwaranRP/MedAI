# Quick Setup Guide

**Built by RPN Tech World**
- Contact: +91 9751448561
- Email: helo@rpntechworld.com
- Website: www.rpntechworld.com

## Prerequisites
- Flutter 3.x installed
- Android Studio / VS Code with Flutter extensions
- AI API key (already configured in the code)

## Installation Steps

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Build APK (for Android)
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## API Key Configuration

The API key is currently hardcoded in `lib/services/gemini_service.dart`:
```dart
static const String _apiKey = 'AIzaSyAoTQfXOWo5vGFQEu4rt447wQ3rpontkQI';
```

### For Production (Recommended):

1. Install `flutter_dotenv`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

2. Create `.env` file in root:
```
AI_API_KEY=your_api_key_here
```

3. Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - .env
```

4. Update `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MedicinalPlantApp());
}
```

5. Update `gemini_service.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static String _apiKey = dotenv.env['AI_API_KEY'] ?? '';
```

## Features Implemented

✅ Splash screen with animation  
✅ Onboarding screens (3 slides)  
✅ Home screen with Chat & Quiz modes  
✅ Chat Recommendation Mode with AI  
✅ Quiz Mode with AI-generated questions  
✅ Gamification (coins, streaks, rewards)  
✅ Confetti animations  
✅ Typing indicators  
✅ Plant cards with detailed information  
✅ Result screen after quiz  
✅ About page  
✅ Score badge on AppBar  
✅ Responsive design (phone & tablet)  

## Testing

1. **Chat Mode**: Type any disease/health concern (e.g., "Fever", "Cough", "Diabetes")
2. **Quiz Mode**: Answer 10 AI-generated questions
3. **Gamification**: Earn coins and build streaks

## Troubleshooting

- **API Errors**: Check internet connection and API key validity
- **Build Errors**: Run `flutter clean` then `flutter pub get`
- **Import Errors**: Ensure all files are in correct directories

## Notes

- All responses come from AI API (no static data)
- No backend or database required
- Works completely client-side
- Data persists using SharedPreferences

## Important Disclaimer

⚠️ **CAUTION**: All information provided in this app is fully AI-generated. Do NOT depend solely on this AI for medical decisions.

This app provides educational information about medicinal plants. It is NOT a substitute for professional medical advice, diagnosis, or treatment. ALWAYS consult with a qualified healthcare provider or real doctor before using any medicinal plants.

