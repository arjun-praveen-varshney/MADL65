# IFPL Mobile

A cross-platform Flutter mobile application for **Shankh.ai** - a multilingual financial chatbot designed for Indian users. This app integrates with the existing Shankh.ai backend to provide RAG-enhanced responses, voice input/output, and multi-language support.

## 🚀 Features

- ✅ **Multilingual Support**: English and Hindi with easy language switching
- ✅ **RAG-Enhanced Chat**: Displays source citations from PDF documents
- ✅ **Real-time Communication**: WebSocket integration for instant responses
- ✅ **Voice Input**: Speech-to-text for hands-free interaction (STT)
- ✅ **Voice Output**: Text-to-speech for audio responses (TTS)
- ✅ **Message History**: Local persistence using SQLite
- ✅ **Follow-up Questions**: Suggested questions from assistant responses
- ✅ **Material 3 Design**: Modern, responsive UI with dark/light theme
- ✅ **Session Management**: Persistent chat sessions

## 📋 Prerequisites

- **Flutter SDK**: 3.0.0 or higher
- **Dart**: 3.0.0 or higher
- **Android Studio** / **VS Code** with Flutter extension
- **Backend Server**: Running instance of Shankh.ai backend (see below)

## 🛠️ Installation

### 1. Clone or Navigate to Project

```bash
cd path/to/ifpl_mobile
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Backend URL

Edit `lib/config.dart` and update the backend URLs:

```dart
/// For Android Emulator
static const String BASE_URL = 'http://10.0.2.2:4000';
static const String WS_URL = 'ws://10.0.2.2:4000';

/// For iOS Simulator
static const String BASE_URL = 'http://localhost:4000';
static const String WS_URL = 'ws://localhost:4000';

/// For Physical Device (use your computer's IP)
static const String BASE_URL = 'http://192.168.1.XXX:4000';
static const String WS_URL = 'ws://192.168.1.XXX:4000';
```

### 4. Setup Backend Server

The app requires the Shankh.ai backend to be running. Navigate to the backend repo:

```bash
# Start RAG Service (Terminal 1)
cd packages/rag_service
python server.py

# Start Backend (Terminal 2)
cd packages/backend
node server.js

# Verify services are running
# RAG: http://localhost:8000/status
# Backend: http://localhost:4000/status
```

### 5. Run the App

```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or run in debug mode
flutter run
```

## 📱 Platform-Specific Setup

### Android

**Permissions**: Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

**Network Security**: For local development, add to `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">10.0.2.2</domain>
        <domain includeSubdomains="true">localhost</domain>
    </domain-config>
</network-security-config>
```

Reference in `AndroidManifest.xml`:

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config">
```

### iOS

**Permissions**: Add to `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice input</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition for voice input</string>
```

## 🏗️ Project Structure

```
ifpl_mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config.dart               # Configuration (BASE_URL, etc.)
│   ├── models/
│   │   └── message.dart          # Message & Citation models
│   ├── services/
│   │   ├── api_service.dart      # HTTP & WebSocket client
│   │   ├── chat_provider.dart    # State management (Provider)
│   │   └── storage_service.dart  # SQLite persistence
│   ├── screens/
│   │   └── chat_screen.dart      # Main chat UI
│   ├── widgets/
│   │   ├── message_bubble.dart   # Message display
│   │   ├── citation_list.dart    # RAG source citations
│   │   └── language_selector.dart # Language switcher
│   └── l10n/                     # Localization files
├── test/                         # Unit & widget tests
├── pubspec.yaml                  # Dependencies
└── README.md
```

## 🔌 API Integration

The app communicates with the Shankh.ai backend via:

### REST Endpoints

- `POST /chat/sendText` - Send text message
- `POST /chat/sendAudio` - Upload audio for transcription
- `GET /chat/history/:sessionId` - Fetch chat history
- `DELETE /chat/session/:sessionId` - Clear session
- `GET /status` - Backend health check

### WebSocket Events

- `connect` - Establish connection
- `join` - Join session room
- `message` - Receive assistant responses
- `typing` - Typing indicators

## 🧪 Testing

### Run Unit Tests

```bash
flutter test
```

### Run Specific Tests

```bash
flutter test test/message_test.dart
flutter test test/api_service_test.dart
```

### Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🎨 Customization

### Theme

Edit `lib/main.dart` to customize colors:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change primary color
  brightness: Brightness.light,
),
```

### Languages

Add new languages in:

1. `lib/config.dart` - Update `SUPPORTED_LANGUAGES`
2. `lib/widgets/language_selector.dart` - Add menu items
3. `lib/l10n/` - Add ARB translation files

## 📝 Environment Variables

Create a `.env` file (optional) or configure `lib/config.dart`:

```dart
BASE_URL=http://10.0.2.2:4000
WS_URL=ws://10.0.2.2:4000
ENABLE_VOICE_INPUT=true
ENABLE_VOICE_OUTPUT=true
```

## 🐛 Troubleshooting

### "Connection refused" error

- ✅ Backend server is running (`http://localhost:4000/status`)
- ✅ Correct IP address for physical devices
- ✅ Android emulator uses `10.0.2.2` instead of `localhost`
- ✅ Network security config allows cleartext traffic (Android)

### Voice input not working

- ✅ Microphone permissions granted
- ✅ `speech_to_text` package initialized
- ✅ Check `flutter doctor` for issues

### Messages not persisting

- ✅ `sqflite` database initialized
- ✅ Check logs for storage errors: `flutter logs`

### WebSocket disconnects

- ✅ Backend WebSocket endpoint is accessible
- ✅ Session ID is valid
- ✅ Check network stability

## 📚 Dependencies

### Core

- `flutter`: SDK
- `provider`: ^6.1.1 - State management
- `http`: ^1.1.0 - HTTP client
- `socket_io_client`: ^2.0.3+1 - WebSocket

### Storage

- `shared_preferences`: ^2.2.2 - Key-value storage
- `sqflite`: ^2.3.0 - SQLite database
- `path_provider`: ^2.1.1 - File paths

### Speech

- `speech_to_text`: ^6.5.1 - STT
- `flutter_tts`: ^3.8.5 - TTS
- `permission_handler`: ^11.1.0 - Permissions

### UI & Utils

- `flutter_markdown`: ^0.6.18 - Markdown rendering
- `uuid`: ^4.2.2 - Unique IDs
- `timeago`: ^3.6.0 - Relative timestamps
- `intl`: ^0.18.1 - Internationalization

## 🚀 Deployment

### Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS IPA

```bash
flutter build ios --release
# Use Xcode to archive and submit to App Store
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is part of the IFPL/Shankh.ai ecosystem.

## 🔗 Related Links

- Backend Repository: [ifpl-cfs](https://github.com/arjun-praveen-varshney/ifpl-cfs)
- API Documentation: See backend `/docs`
- Flutter Documentation: [flutter.dev](https://flutter.dev/)

## 👥 Support

For issues or questions:

- Check the [Troubleshooting](#-troubleshooting) section
- Review backend logs for API errors
- Open an issue on GitHub

---

**Built with ❤️ for Indian financial inclusion**
