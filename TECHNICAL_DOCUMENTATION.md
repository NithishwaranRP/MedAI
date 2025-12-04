# Med AI - Technical Documentation

## Technical Introduction

**Med AI** is a Flutter-based mobile application that provides AI-powered medicinal plant recommendations and interactive quiz functionality. The app leverages advanced AI technology to deliver personalized health information through an engaging, gamified user experience.

---

## Architecture Overview

### Platform
- **Target Platforms**: Android (Mobile Only)
- **Framework**: Flutter 3.x
- **Language**: Dart 3.0+
- **Architecture Pattern**: Stateful Widgets with Service Layer

### Application Structure
```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI Screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── chat_screen.dart
│   ├── quiz_screen.dart
│   ├── result_screen.dart
│   └── about_screen.dart
├── services/                 # Business Logic
│   └── gemini_service.dart   # AI API Integration
├── widgets/                  # Reusable Components
│   ├── app_logo.dart
│   ├── chat_bubble.dart
│   ├── plant_card.dart
│   ├── score_badge.dart
│   └── typing_indicator.dart
└── utils/                    # Utilities
    ├── app_colors.dart
    └── app_text_styles.dart
```

---

## Technology Stack

### Core Technologies
- **Flutter SDK**: 3.x
- **Dart**: 3.0+
- **AI API**: Advanced AI Technology (gemini-2.5-flash model)
- **State Management**: StatefulWidget with SharedPreferences

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  google_generative_ai: ^0.4.3    # AI API client
  shared_preferences: ^2.2.2     # Local data persistence
  confetti: ^0.7.0                # Achievement animations
  vibration: ^3.1.4               # Haptic feedback
  lottie: ^2.7.0                  # Animations (optional)
```

---

## Core Features & Implementation

### 1. AI-Powered Chat System

**Technology**: Advanced AI API (gemini-2.5-flash)

**Implementation**:
- Conversational AI with context retention
- Medical domain specialization
- Response length optimization (concise by default, detailed on request)
- Topic filtering (medicine-related only)

**Key Components**:
- `GeminiService.getChatResponse()`: Handles conversational flow
- Chat history management for context
- Error handling with user-friendly messages

**Technical Details**:
```dart
// Conversation history maintained in _chatHistory list
// System prompt defines AI identity as "Med AI"
// Responses limited to 50-100 words unless user requests elaboration
```

### 2. Dynamic Quiz System

**Technology**: AI-generated questions

**Implementation**:
- Questions generated dynamically via AI API
- 10 questions per quiz session
- Previous question tracking to avoid repetition
- Real-time scoring and streak tracking

**Key Components**:
- `GeminiService.generateQuizQuestion()`: Generates unique questions
- Question validation and JSON parsing
- Dynamic option rendering

**Technical Details**:
```dart
// Questions generated in JSON format:
// {question: '', options: ['','','',''], answer: ''}
// Previous questions passed to avoid repetition
```

### 3. Gamification System

**Implementation**:
- **Coins**: Earned only in Quiz mode (+10 per correct answer)
- **Streaks**: Tracked only for quiz correct answers
- **Achievements**: Bronze (10), Silver (20), Gold (30) streaks
- **Persistence**: SharedPreferences for data storage

**Technical Details**:
```dart
// Coins: Stored in SharedPreferences as 'coins'
// Streaks: Stored as 'streak' and 'highest_streak'
// Achievements: Boolean flags (achievement_bronze, etc.)
// Streak resets to 0 (hidden) on wrong answer
```

### 4. UI/UX Architecture

**Design System**:
- **Theme**: Herbal/Medical (Green palette)
- **Responsive**: Supports phones and tablets
- **Animations**: Confetti, fade, scale transitions
- **Components**: Reusable widget library

**Key UI Components**:
- `AppLogo`: Branded logo widget
- `ChatBubble`: WhatsApp-style message bubbles
- `PlantCard`: Detailed plant information dialog
- `ScoreBadge`: Coins and streak display
- `TypingIndicator`: Animated loading state

---

## API Integration

### AI Service Architecture

**Service Class**: `GeminiService`

**Methods**:
1. `getChatResponse(String query)`: Conversational chat
2. `generateQuizQuestion({previousQuestions})`: Dynamic quiz generation
3. `fetchPlantRecommendation(String query)`: Plant data (legacy, not used)

**Configuration**:
```dart
API Key: Configured in gemini_service.dart
Model: gemini-2.5-flash
Base URL: generativelanguage.googleapis.com
```

**Error Handling**:
- Network errors: User-friendly messages
- API failures: Fallback responses
- Connection issues: Clear troubleshooting guidance

**Security**:
- API key stored in code (production: use environment variables)
- No sensitive user data transmitted
- All communication over HTTPS

---

## Data Persistence

### Storage Mechanism
- **Technology**: SharedPreferences
- **Data Stored**:
  - User coins
  - Current streak
  - Highest streak
  - Achievement unlocks
  - Onboarding completion status
  - Total queries (chat mode)

### Data Structure
```dart
SharedPreferences Keys:
- 'coins': int
- 'streak': int
- 'highest_streak': int
- 'achievement_bronze': bool
- 'achievement_silver': bool
- 'achievement_gold': bool
- 'has_seen_onboarding': bool
- 'total_queries': int
```

---

## App Flow & Navigation

### Screen Flow
```
Splash Screen
    ↓
Onboarding (First time only)
    ↓
Home Screen
    ├──→ Chat Screen
    │       └──→ About Screen
    └──→ Quiz Screen
            └──→ Result Screen
                    └──→ Home Screen
```

### Navigation Pattern
- **Stack Navigation**: Standard Flutter Navigator
- **State Preservation**: SharedPreferences
- **Deep Linking**: Not implemented

---

## Build Configuration

### Android Configuration
```kotlin
Application ID: com.rpntechworld.medai
Min SDK: 21 (Android 5.0+)
Target SDK: Latest
Package Name: com.rpntechworld.medai
App Name: Med AI - Medicinal Plants
```

### Build Commands
```bash
# Development
flutter run

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

### App Icons
- **Source**: `assets/logo/app_logo.png` (1024x1024)
- **Generator**: flutter_launcher_icons
- **Config**: `flutter_launcher_icons.yaml`

---

## Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Questions generated on-demand
2. **Caching**: Chat history maintained in memory
3. **Image Optimization**: Logo widget (no external images)
4. **State Management**: Minimal rebuilds with setState optimization

### Memory Management
- Chat history cleared on app restart
- Widget disposal properly handled
- No memory leaks in animations

---

## Security & Privacy

### Data Security
- **API Key**: Currently hardcoded (production: use .env)
- **User Data**: Stored locally only (SharedPreferences)
- **Network**: All API calls over HTTPS
- **No Backend**: Fully client-side application

### Privacy
- No user data collection
- No analytics tracking
- No third-party services (except AI API)
- Local storage only

---

## Error Handling

### Network Errors
- Connection failures: User-friendly messages
- Timeout handling: Automatic retry guidance
- API errors: Fallback responses

### UI Errors
- Graceful degradation
- Loading states for async operations
- Error dialogs with actionable messages

---

## Testing & Quality Assurance

### Code Quality
- **Linter**: flutter_lints ^3.0.0
- **Analysis**: No linter errors
- **Code Style**: Consistent formatting

### Manual Testing Checklist
- [ ] Splash screen animation
- [ ] Onboarding flow
- [ ] Chat functionality
- [ ] Quiz generation
- [ ] Coin/streak system
- [ ] Achievement unlocks
- [ ] Error handling
- [ ] Responsive design

---

## Deployment

### Pre-Deployment Checklist
1. ✅ API key configured
2. ✅ App icons generated
3. ✅ App name and package ID set
4. ✅ Permissions configured (Internet)
5. ✅ Version number set (1.0.0+1)
6. ✅ Build configuration verified

### Release Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

---

## Known Limitations

1. **Internet Required**: All AI features require active connection
2. **API Rate Limits**: Subject to AI API rate limits
3. **No Offline Mode**: Chat and quiz require internet
4. **Platform**: Mobile only (Android/iOS)

---

## Future Enhancements

### Potential Improvements
- Offline mode with cached responses
- User profiles and progress tracking
- Social features (leaderboards)
- Plant image gallery
- Favorites/bookmarks system
- Export quiz results
- Dark mode toggle

---

## Developer Information

**Developed by**: RPN Tech World
- **Contact**: +91 9751448561
- **Email**: helo@rpntechworld.com
- **Website**: www.rpntechworld.com

**Version**: 1.0.0+1
**Last Updated**: 2024

---

## Technical Support

### Common Issues

**Network Errors**:
- Check internet connection
- Verify API key validity
- Check firewall settings

**Build Errors**:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Icon Issues**:
```bash
flutter pub run flutter_launcher_icons
```

---

## License & Disclaimer

**⚠️ Important Disclaimer**:
- All information is AI-generated
- Not a substitute for professional medical advice
- Always consult a qualified healthcare provider
- Educational purposes only

---

## Code Examples

### Chat Implementation
```dart
// Send message
final response = await _geminiService.getChatResponse(userQuery);
// Response is concise (50-100 words) unless user asks to elaborate
```

### Quiz Implementation
```dart
// Generate question
final question = await _geminiService.generateQuizQuestion(
  previousQuestions: _questions,
);
// Returns JSON with question, options, and answer
```

### Achievement System
```dart
// Check achievements
if (streak >= 10) {
  await prefs.setBool('achievement_bronze', true);
  _showAchievementUnlocked('Bronze', '🏅', AppColors.orange);
}
```

---

## Conclusion

Med AI is a modern, AI-powered mobile application built with Flutter, providing users with an interactive way to learn about medicinal plants through conversational AI and gamified quizzes. The app emphasizes user engagement through rewards, achievements, and a clean, responsive UI design.

**Key Strengths**:
- ✅ Modern Flutter architecture
- ✅ AI-powered dynamic content
- ✅ Engaging gamification
- ✅ Responsive design
- ✅ Clean code structure
- ✅ Comprehensive error handling

---

*For technical questions or support, contact RPN Tech World.*

