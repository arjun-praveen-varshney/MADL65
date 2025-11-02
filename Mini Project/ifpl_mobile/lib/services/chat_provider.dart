/// Chat Provider
///
/// Manages chat state using Provider for state management.
/// Handles messages, API calls, session management, and WebSocket events.

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../config.dart';

const _uuid = Uuid();

/// Chat state provider
class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Session
  String? _sessionId;
  String? get sessionId => _sessionId;

  // Messages
  List<Message> _messages = [];
  List<Message> get messages => List.unmodifiable(_messages);

  // UI State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _error;
  String? get error => _error;

  String _language = AppConfig.DEFAULT_LANGUAGE;
  String get language => _language;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _ttsEnabled = true;
  bool get ttsEnabled => _ttsEnabled;

  // Stream subscriptions
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  ChatProvider() {
    _initialize();
  }

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  Future<void> _initialize() async {
    // Load saved preferences
    await _loadPreferences();

    // Initialize session
    await _initializeSession();

    // Setup WebSocket listeners
    _setupWebSocketListeners();

    // Load message history
    await loadHistory();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _language =
          prefs.getString(AppConfig.PREF_LANGUAGE) ??
          AppConfig.DEFAULT_LANGUAGE;
      _ttsEnabled = prefs.getBool(AppConfig.PREF_TTS_ENABLED) ?? true;

      notifyListeners();
    } catch (e) {
      print('[ChatProvider] Failed to load preferences: $e');
    }
  }

  Future<void> _initializeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _sessionId = prefs.getString(AppConfig.PREF_SESSION_ID);

      if (_sessionId == null) {
        _sessionId = _uuid.v4();
        await prefs.setString(AppConfig.PREF_SESSION_ID, _sessionId!);
      }

      // Connect WebSocket
      _apiService.connectWebSocket(_sessionId!);

      print('[ChatProvider] Session initialized: $_sessionId');
    } catch (e) {
      print('[ChatProvider] Failed to initialize session: $e');
      _setError('Failed to initialize session');
    }
  }

  void _setupWebSocketListeners() {
    // Listen to WebSocket messages
    _messageSubscription = _apiService.messageStream.listen(
      (message) {
        print('[ChatProvider] Received message from WebSocket');
        _addMessage(message);
        _setLoading(false);
      },
      onError: (error) {
        print('[ChatProvider] WebSocket message error: $error');
        _setError('Connection error: $error');
        _setLoading(false);
      },
    );

    // Listen to connection status
    _connectionSubscription = _apiService.connectionStream.listen((connected) {
      _isConnected = connected;
      notifyListeners();
    });
  }

  // ============================================================================
  // MESSAGE OPERATIONS
  // ============================================================================

  /// Send text message
  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || _sessionId == null) return;

    _clearError();

    // Add user message
    final userMessage = Message(
      id: _uuid.v4(),
      role: MessageRole.user,
      text: text.trim(),
      timestamp: DateTime.now(),
      language: _language,
    );

    _addMessage(userMessage);
    _setLoading(true);

    try {
      // Send via API (response comes via WebSocket)
      await _apiService.sendTextMessage(
        sessionId: _sessionId!,
        text: text.trim(),
        language: _language,
      );

      // Typing indicator
      _apiService.sendTypingIndicator(_sessionId!, true);
    } catch (e) {
      _setError(e is ApiException ? e.message : 'Failed to send message');
      _setLoading(false);
    }
  }

  /// Send audio message
  Future<void> sendAudioMessage(File audioFile) async {
    if (_sessionId == null) return;

    _clearError();

    // Add placeholder message
    final placeholderMessage = Message(
      id: _uuid.v4(),
      role: MessageRole.user,
      text: '🎤 Transcribing audio...',
      timestamp: DateTime.now(),
      isTranscribing: true,
    );

    _addMessage(placeholderMessage);
    _setLoading(true);

    try {
      // Upload audio (response comes via WebSocket)
      await _apiService.sendAudioMessage(
        sessionId: _sessionId!,
        audioFile: audioFile,
        language: _language,
      );
    } catch (e) {
      _removeMessage(placeholderMessage.id);
      _setError(e is ApiException ? e.message : 'Failed to send audio');
      _setLoading(false);
    }
  }

  /// Add message to list
  void _addMessage(Message message) {
    _messages.add(message);
    notifyListeners();

    // Save to storage
    _storageService.saveMessage(message);
  }

  /// Remove message by ID
  void _removeMessage(String messageId) {
    _messages.removeWhere((m) => m.id == messageId);
    notifyListeners();
  }

  /// Clear all messages
  Future<void> clearMessages() async {
    _messages.clear();
    notifyListeners();

    // Clear from storage
    await _storageService.clearMessages();

    // Clear session on backend
    if (_sessionId != null) {
      try {
        await _apiService.clearSession(_sessionId!);
      } catch (e) {
        print('[ChatProvider] Failed to clear session on backend: $e');
      }
    }
  }

  /// Load message history
  Future<void> loadHistory() async {
    try {
      // Load from local storage first
      final localMessages = await _storageService.loadMessages();

      if (localMessages.isNotEmpty) {
        _messages = localMessages;
        notifyListeners();
      }

      // Optionally fetch from backend
      // Uncomment if you want to sync with backend on startup
      /*
      if (_sessionId != null) {
        final backendMessages = await _apiService.getHistory(_sessionId!);
        _messages = backendMessages;
        notifyListeners();
      }
      */
    } catch (e) {
      print('[ChatProvider] Failed to load history: $e');
    }
  }

  // ============================================================================
  // SETTINGS
  // ============================================================================

  /// Change language
  Future<void> setLanguage(String newLanguage) async {
    if (!AppConfig.SUPPORTED_LANGUAGES.contains(newLanguage)) return;

    _language = newLanguage;
    notifyListeners();

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.PREF_LANGUAGE, newLanguage);
    } catch (e) {
      print('[ChatProvider] Failed to save language: $e');
    }
  }

  /// Toggle TTS
  Future<void> toggleTTS() async {
    _ttsEnabled = !_ttsEnabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.PREF_TTS_ENABLED, _ttsEnabled);
    } catch (e) {
      print('[ChatProvider] Failed to save TTS setting: $e');
    }
  }

  /// Set recording state
  void setRecording(bool recording) {
    _isRecording = recording;
    notifyListeners();
  }

  // ============================================================================
  // STATE HELPERS
  // ============================================================================

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _apiService.dispose();
    super.dispose();
  }
}
