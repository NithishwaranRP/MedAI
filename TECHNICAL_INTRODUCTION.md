# Med AI - Technical Introduction

## Overview

**Med AI** is a Flutter-based mobile application that leverages advanced AI technology to provide personalized medicinal plant recommendations and interactive educational quizzes. The app delivers a gamified learning experience through conversational AI and dynamic quiz generation.

---

## Technical Architecture

### Platform & Framework
- **Framework**: Flutter 3.x
- **Language**: Dart 3.0+
- **Target Platforms**: Android & iOS (Mobile Only)
- **Architecture**: Stateful Widgets with Service-Oriented Architecture

### Core Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **UI Framework** | Flutter | Cross-platform mobile development |
| **AI Integration** | Advanced AI API (gemini-2.5-flash) | Conversational AI & dynamic content |
| **Data Persistence** | SharedPreferences | Local storage for user progress |
| **Animations** | Confetti, Custom Painters | User engagement & feedback |
| **State Management** | StatefulWidget | Component-level state |

---

## Key Technical Features

### 1. AI-Powered Conversational System
- **Technology**: Advanced AI API with context retention
- **Implementation**: Chat history management for conversational flow
- **Response Strategy**: Concise by default (50-100 words), detailed on request
- **Domain**: Medical/Herbal medicine specialization
- **Filtering**: Medicine-related topics only

### 2. Dynamic Quiz Generation
- **Technology**: AI-generated questions in real-time
- **Format**: JSON-structured MCQ (4 options, 1 correct answer)
- **Uniqueness**: Previous question tracking prevents repetition
- **Volume**: 10 questions per quiz session

### 3. Gamification Engine
- **Coins System**: +10 coins per correct quiz answer
- **Streak Tracking**: Consecutive correct answers (resets on wrong)
- **Achievements**: Bronze (10), Silver (20), Gold (30) streak milestones
- **Persistence**: SharedPreferences for data retention

### 4. Responsive UI Architecture
- **Design System**: Herbal/Medical theme (Green palette)
- **Responsiveness**: Adaptive layouts for phones and tablets
- **Components**: Reusable widget library
- **Animations**: Confetti, fade, scale transitions

---

## Application Structure

```
lib/
├── main.dart                    # App entry & routing
├── screens/                     # UI Layer (7 screens)
│   ├── splash_screen.dart      # Animated splash
│   ├── onboarding_screen.dart  # 3-slide introduction
│   ├── home_screen.dart         # Main navigation hub
│   ├── chat_screen.dart         # AI conversation interface
│   ├── quiz_screen.dart         # Dynamic quiz system
│   ├── result_screen.dart       # Quiz results & stats
│   └── about_screen.dart       # App information
├── services/                    # Business Logic Layer
│   └── gemini_service.dart     # AI API integration
├── widgets/                     # Reusable Components
│   ├── app_logo.dart           # Branded logo widget
│   ├── chat_bubble.dart       # Message UI component
│   ├── plant_card.dart        # Plant info dialog
│   ├── score_badge.dart       # Coins/streak display
│   └── typing_indicator.dart  # Loading animation
└── utils/                      # Utilities
    ├── app_colors.dart        # Theme colors
    └── app_text_styles.dart   # Typography
```

---

## API Integration Details

### AI Service Configuration
```dart
Service: GeminiService
API Endpoint: generativelanguage.googleapis.com
Model: gemini-2.5-flash
Authentication: API Key
```

### Key Methods
1. **`getChatResponse(String query)`**
   - Maintains conversation history
   - Returns concise medical advice
   - Filters non-medical topics

2. **`generateQuizQuestion({previousQuestions})`**
   - Generates unique MCQ questions
   - Returns JSON format
   - Avoids question repetition

### Error Handling
- Network failures: User-friendly error messages
- API errors: Graceful fallback responses
- Connection issues: Clear troubleshooting guidance

---

## Data Flow

### Chat Flow
```
User Input → GeminiService.getChatResponse()
    ↓
AI Processing (with history context)
    ↓
Response Generation (concise/detailed)
    ↓
UI Update (ChatBubble widget)
```

### Quiz Flow
```
Quiz Start → Generate 10 Questions (async)
    ↓
User Answers → Validate against AI response
    ↓
Update Score/Coins/Streak
    ↓
Check Achievements → Unlock if milestone reached
    ↓
Result Screen → Display performance
```

---

## Performance Characteristics

### Optimization Strategies
- **Lazy Loading**: Questions generated on-demand
- **Memory Management**: Proper widget disposal
- **State Optimization**: Minimal rebuilds
- **Network Efficiency**: Single API call per request

### Resource Usage
- **Storage**: Minimal (SharedPreferences only)
- **Memory**: Efficient (chat history in memory)
- **Network**: API-dependent (requires internet)

---

## Build & Deployment

### Configuration
```yaml
Application ID: com.rpntechworld.medai
App Name: Med AI - Medicinal Plants
Version: 1.0.0+1
Min SDK: 21 (Android 5.0+)
```

### Build Process
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

### Output
- **APK Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: ~25-30 MB (estimated)
- **Target**: Android devices (API 21+)

---

## Security Considerations

### Current Implementation
- API key: Hardcoded in service file
- Data storage: Local only (SharedPreferences)
- Network: HTTPS encrypted
- User data: No collection or transmission

### Production Recommendations
- Move API key to environment variables (.env)
- Implement secure storage for sensitive data
- Add API rate limiting
- Implement request timeout handling

---

## Technical Specifications

### Dependencies
```yaml
google_generative_ai: ^0.4.3  # AI API client
shared_preferences: ^2.2.2    # Local storage
confetti: ^0.7.0              # Animations
vibration: ^3.1.4             # Haptic feedback
```

### System Requirements
- **Android**: 5.0+ (API 21+)
- **iOS**: 12.0+ (if implemented)
- **Internet**: Required for AI features
- **Storage**: ~50 MB

---

## Code Quality

### Standards
- **Linter**: flutter_lints ^3.0.0
- **Code Style**: Consistent Dart formatting
- **Error Handling**: Comprehensive try-catch blocks
- **Documentation**: Inline comments for complex logic

### Best Practices
- Widget composition over inheritance
- Separation of concerns (UI/Logic/Services)
- Reusable component library
- Responsive design patterns

---

## Key Technical Decisions

### 1. State Management
**Choice**: StatefulWidget over Provider/Bloc
**Reason**: Simplicity for current scope, easy to migrate if needed

### 2. Data Persistence
**Choice**: SharedPreferences over SQLite
**Reason**: Simple key-value storage sufficient for current needs

### 3. AI Integration
**Choice**: Direct API calls over backend proxy
**Reason**: No backend required, fully client-side

### 4. Quiz Generation
**Choice**: Dynamic AI generation over static database
**Reason**: Unlimited question variety, always fresh content

---

## Testing Strategy

### Manual Testing
- Functional testing for all features
- UI/UX testing across devices
- Network error scenarios
- Achievement unlock verification

### Automated Testing
- Unit tests: Service layer (recommended)
- Widget tests: Component validation (recommended)
- Integration tests: End-to-end flows (recommended)

---

## Maintenance & Updates

### Version Management
- Semantic versioning (1.0.0+1)
- Changelog tracking
- Feature flags for gradual rollouts

### Update Strategy
- Hot fixes: Patch version increment
- Features: Minor version increment
- Major changes: Major version increment

---

## Technical Support

### Development Environment
- Flutter SDK: 3.x
- Dart SDK: 3.0+
- Android Studio / VS Code
- Android SDK: API 21+

### Common Commands
```bash
# Run app
flutter run

# Build APK
flutter build apk --release

# Generate icons
flutter pub run flutter_launcher_icons

# Analyze code
flutter analyze
```

---

## Conclusion

Med AI represents a modern approach to mobile health education, combining:
- **Advanced AI** for personalized content
- **Gamification** for user engagement
- **Clean Architecture** for maintainability
- **Responsive Design** for accessibility

The application demonstrates best practices in Flutter development while providing a seamless, educational user experience.

---

**Developer**: RPN Tech World  
**Contact**: +91 9751448561 | helo@rpntechworld.com  
**Version**: 1.0.0+1

