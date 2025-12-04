# AI-Powered Medicinal Plant Recommendation System

A complete Flutter mobile app with gamified features, powered by advanced AI technology.

**Built by RPN Tech World**
- Contact: +91 9751448561
- Email: helo@rpntechworld.com
- Website: www.rpntechworld.com

## Features

- 🌱 **Chat Recommendation Mode**: Get AI-powered medicinal plant recommendations for any health concern
- 🎯 **Quiz Mode**: Test your knowledge with dynamically generated MCQ questions
- 🎮 **Gamification**: Earn coins, build streaks, and unlock achievements
- ✨ **Beautiful UI**: Modern herbal theme with smooth animations
- 🤖 **AI-Powered**: All responses generated dynamically using AI

## Tech Stack

- Flutter 3.x
- Advanced AI API
- No backend/database required - everything runs client-side

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure API Key

The API key is currently hardcoded in `lib/services/gemini_service.dart`. 

**For production**, you should:

1. Install `flutter_dotenv` package:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

2. Create a `.env` file in the root directory:
```
AI_API_KEY=your_api_key_here
```

3. Add `.env` to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - .env
```

4. Update `lib/services/gemini_service.dart` to load from environment:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static const String _apiKey = dotenv.env['AI_API_KEY'] ?? '';
```

5. Load `.env` in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MedicinalPlantApp());
}
```

### 3. Run the App

```bash
flutter run
```

## App Structure

```
lib/
  main.dart                    # App entry point
  screens/
    splash_screen.dart         # Animated splash screen
    onboarding_screen.dart    # 3-slide onboarding
    home_screen.dart          # Main home with mode selection
    chat_screen.dart          # Chat recommendation mode
    quiz_screen.dart          # Quiz mode with MCQ
    result_screen.dart        # Quiz results screen
    about_screen.dart         # About page
  services/
    gemini_service.dart       # AI API integration
  widgets/
    chat_bubble.dart          # Chat message bubbles
    plant_card.dart           # Plant information card
    score_badge.dart          # Coins/streak badge
    typing_indicator.dart     # Loading indicator
  utils/
    app_colors.dart           # Color constants
    app_text_styles.dart      # Text style constants
```

## Gamification System

- **Coins**: Earn +10 coins per valid query/correct answer
- **Streaks**: Build consecutive correct answers
- **Bonuses**: 
  - 3-correct streak in quiz = +20 bonus coins
  - Every 3 queries in chat = +5 bonus coins
- **Penalties**: Wrong answers deduct coins (-5 in quiz, -2 in chat)

## API Integration

The app uses advanced AI API for:

1. **Plant Recommendations**: Returns JSON with plant_name, uses, benefits, preparation, precautions
2. **Quiz Questions**: Returns JSON with question, options (4), and answer

Both methods include error handling with fallback responses.

## Important Disclaimer

⚠️ **CAUTION**: All information provided in this app is fully AI-generated. Do NOT depend solely on this AI for medical decisions.

This app provides educational information about medicinal plants. It is NOT a substitute for professional medical advice, diagnosis, or treatment. ALWAYS consult with a qualified healthcare provider or real doctor before using any medicinal plants.

## Building APK

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## Notes

- All data is generated dynamically from AI API
- No backend, database, or external services required
- Works completely offline after initial API calls (cached responses)
- Responsive design supports phones and tablets

## License

Developed by RPN Tech World
- Contact: +91 9751448561
- Email: helo@rpntechworld.com
- Website: www.rpntechworld.com

---

**⚠️ IMPORTANT DISCLAIMER**: This app is for educational purposes only. All information is AI-generated and may contain errors. Always consult a qualified healthcare professional or real doctor before using any medicinal plants. Do NOT depend solely on this AI for medical decisions.
# MedAI
