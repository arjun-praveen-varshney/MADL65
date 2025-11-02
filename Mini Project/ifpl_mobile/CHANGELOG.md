# Changelog

All notable changes to the IFPL Mobile project will be documented in this file.

## [1.0.0] - 2025-11-02

### Added

- ✨ Initial release of IFPL Mobile Flutter application
- 🎯 Multilingual chat interface (English, Hindi)
- 🔌 Integration with Shankh.ai backend API
- 💬 Real-time chat via WebSocket
- 📱 Message bubbles with user/assistant distinction
- 📚 RAG citation display with source files and page numbers
- 🎤 Voice input support (STT) - Speech-to-Text integration
- 🔊 Voice output support (TTS) - Text-to-Speech playback
- 💾 Local message persistence using SQLite
- 🔄 Session management with SharedPreferences
- 🌐 Language selector widget (English/Hindi)
- ❓ Follow-up question suggestions
- 🎨 Material 3 design with light/dark theme support
- ⚡ Connection status indicator
- ⚠️ Error handling and display
- 📝 Message timestamps with relative time
- 🔒 Verification warnings for unverified information
- 📦 State management using Provider pattern

### Technical Implementation

- **Backend API Integration**
  - REST endpoints: `/chat/sendText`, `/chat/sendAudio`, `/status`
  - WebSocket connection for real-time messages
  - Automatic reconnection handling
- **Data Models**

  - `Message` model with JSON serialization
  - `Citation` model for RAG sources
  - Role-based message types (user, assistant, system)

- **Services**

  - `ApiService`: HTTP & WebSocket client
  - `ChatProvider`: State management
  - `StorageService`: SQLite persistence

- **UI Components**
  - `ChatScreen`: Main chat interface
  - `MessageBubble`: Message display widget
  - `CitationList`: RAG source display
  - `LanguageSelector`: Language switcher

### Configuration

- Configurable backend URL in `lib/config.dart`
- Support for Android emulator, iOS simulator, and physical devices
- Environment-based configuration

### Dependencies

- Core: flutter, provider, http, socket_io_client
- Storage: shared_preferences, sqflite, path_provider
- Speech: speech_to_text, flutter_tts, permission_handler
- UI: flutter_markdown, uuid, timeago, intl

### Documentation

- Comprehensive README with setup instructions
- API integration documentation
- Platform-specific setup guides (Android/iOS)
- Troubleshooting section
- Project structure documentation

### Testing

- Unit test setup for Message model
- Unit test setup for ApiService
- Test helpers and mock objects

### Known Limitations

- Voice recording UI placeholder (full implementation pending)
- TTS playback UI placeholder (full implementation pending)
- Limited to 2 languages (extensible architecture)
- Requires running backend server

### Future Enhancements (TODOs)

- [ ] Complete voice recording implementation
- [ ] Complete TTS audio playback
- [ ] Add Marathi, Bengali, Tamil, Telugu, Kannada languages
- [ ] Offline mode with cached responses
- [ ] Push notifications for important updates
- [ ] User authentication and profiles
- [ ] Chat export functionality
- [ ] Advanced search in message history
- [ ] Rich media support (images, documents)
- [ ] Biometric authentication

---

## Version History

### v1.0.0 (Current)

- Initial release with core chat functionality
- Backend integration complete
- Multilingual support (English, Hindi)
- Local persistence
- WebSocket real-time updates

---

**Note**: This project follows [Semantic Versioning](https://semver.org/).
