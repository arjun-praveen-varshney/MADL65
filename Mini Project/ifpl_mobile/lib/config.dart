/// Configuration file for IFPL Mobile App
///
/// Contains API URLs, environment settings, and app constants.
/// Update BASE_URL to point to your running backend server.

class AppConfig {
  // ============================================================================
  // BACKEND CONFIGURATION
  // ============================================================================

  /// Backend API base URL
  /// Development: http://localhost:4000 or http://10.0.2.2:4000 (Android emulator)
  /// Production: https://your-production-api.com
  static const String BASE_URL = 'http://10.243.201.149:4000';

  /// WebSocket URL for real-time chat
  /// Note: Use ws:// for http and wss:// for https
  static const String WS_URL = 'ws://10.243.201.149:4000';

  /// RAG Service URL (for direct queries if needed)
  static const String RAG_SERVICE_URL = 'http://10.243.201.149:8000';

  // ============================================================================
  // API ENDPOINTS
  // ============================================================================

  /// Chat endpoints
  static const String ENDPOINT_CHAT_TEXT = '/chat/sendText';
  static const String ENDPOINT_CHAT_AUDIO = '/chat/sendAudio';
  static const String ENDPOINT_CHAT_HISTORY = '/chat/history';
  static const String ENDPOINT_CHAT_SESSION = '/chat/session';

  /// Health check endpoints
  static const String ENDPOINT_HEALTH = '/health';
  static const String ENDPOINT_STATUS = '/status';

  // ============================================================================
  // APP SETTINGS
  // ============================================================================

  /// Default language
  static const String DEFAULT_LANGUAGE = 'en';

  /// Supported languages
  static const List<String> SUPPORTED_LANGUAGES = ['en', 'hi'];

  /// Request timeout duration
  static const Duration REQUEST_TIMEOUT = Duration(seconds: 60);

  /// Max audio recording duration (in seconds)
  static const int MAX_RECORDING_DURATION = 120; // 2 minutes

  /// Max messages to keep in memory
  static const int MAX_CONVERSATION_HISTORY = 50;

  /// WebSocket reconnection settings
  static const Duration WS_RECONNECT_DELAY = Duration(seconds: 5);
  static const int WS_MAX_RECONNECT_ATTEMPTS = 5;

  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================

  /// Enable voice input (STT)
  static const bool ENABLE_VOICE_INPUT = true;

  /// Enable voice output (TTS)
  static const bool ENABLE_VOICE_OUTPUT = true;

  /// Enable RAG citations display
  static const bool ENABLE_CITATIONS = true;

  /// Enable follow-up questions
  static const bool ENABLE_FOLLOW_UP = true;

  // ============================================================================
  // STORAGE KEYS
  // ============================================================================

  /// SharedPreferences keys
  static const String PREF_SESSION_ID = 'session_id';
  static const String PREF_LANGUAGE = 'language';
  static const String PREF_THEME_MODE = 'theme_mode';
  static const String PREF_TTS_ENABLED = 'tts_enabled';

  // ============================================================================
  // VALIDATION
  // ============================================================================

  /// Validate configuration
  static bool validateConfig() {
    if (BASE_URL.isEmpty) {
      throw Exception('BASE_URL is not configured');
    }
    if (WS_URL.isEmpty) {
      throw Exception('WS_URL is not configured');
    }
    return true;
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Get full API URL
  static String getApiUrl(String endpoint) {
    return '$BASE_URL$endpoint';
  }

  /// Check if URL is localhost
  static bool isLocalhost() {
    return BASE_URL.contains('localhost') ||
        BASE_URL.contains('127.0.0.1') ||
        BASE_URL.contains('10.0.2.2');
  }
}
