/// API Service
///
/// Handles HTTP communication with the Shankh.ai backend.
/// Provides methods for chat, audio transcription, and session management.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config.dart';
import '../models/message.dart';

/// API Service Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

/// API Service for backend communication
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _httpClient = http.Client();
  IO.Socket? _socket;

  /// Message stream controller
  final _messageController = StreamController<Message>.broadcast();
  Stream<Message> get messageStream => _messageController.stream;

  /// Connection status stream
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Current session ID
  String? _sessionId;
  String? get sessionId => _sessionId;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // ============================================================================
  // HTTP METHODS
  // ============================================================================

  /// Send text message
  ///
  /// Sends a text message to the chat endpoint and returns the response.
  /// The actual assistant response will arrive via WebSocket.
  Future<Map<String, dynamic>> sendTextMessage({
    required String sessionId,
    required String text,
    String language = 'en',
  }) async {
    try {
      final url = Uri.parse(AppConfig.getApiUrl(AppConfig.ENDPOINT_CHAT_TEXT));

      final response = await _httpClient
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'sessionId': sessionId,
              'text': text,
              'language': language,
            }),
          )
          .timeout(AppConfig.REQUEST_TIMEOUT);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        'Network error. Please check your internet connection.',
      );
    } on TimeoutException {
      throw ApiException('Request timeout. Please try again.');
    } catch (e) {
      throw ApiException('Failed to send message: $e');
    }
  }

  /// Send audio message
  ///
  /// Uploads an audio file for transcription and chat processing.
  Future<Map<String, dynamic>> sendAudioMessage({
    required String sessionId,
    required File audioFile,
    String? language,
  }) async {
    try {
      final url = Uri.parse(AppConfig.getApiUrl(AppConfig.ENDPOINT_CHAT_AUDIO));

      final request = http.MultipartRequest('POST', url);
      request.fields['sessionId'] = sessionId;
      if (language != null) {
        request.fields['language'] = language;
      }

      // Add audio file
      final audioBytes = await audioFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'audio',
          audioBytes,
          filename: 'recording.wav',
        ),
      );

      final streamedResponse = await request.send().timeout(
        AppConfig.REQUEST_TIMEOUT,
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        'Network error. Please check your internet connection.',
      );
    } on TimeoutException {
      throw ApiException('Request timeout. Audio processing takes time.');
    } catch (e) {
      throw ApiException('Failed to send audio: $e');
    }
  }

  /// Get conversation history
  Future<List<Message>> getHistory(String sessionId) async {
    try {
      final url = Uri.parse(
        AppConfig.getApiUrl('${AppConfig.ENDPOINT_CHAT_HISTORY}/$sessionId'),
      );

      final response = await _httpClient
          .get(url)
          .timeout(AppConfig.REQUEST_TIMEOUT);

      final data = _handleResponse(response);
      final history = data['history'] as List<dynamic>;

      return history
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException('Failed to load history: $e');
    }
  }

  /// Clear session
  Future<void> clearSession(String sessionId) async {
    try {
      final url = Uri.parse(
        AppConfig.getApiUrl('${AppConfig.ENDPOINT_CHAT_SESSION}/$sessionId'),
      );

      await _httpClient.delete(url).timeout(AppConfig.REQUEST_TIMEOUT);
    } catch (e) {
      throw ApiException('Failed to clear session: $e');
    }
  }

  /// Check backend status
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final url = Uri.parse(AppConfig.getApiUrl(AppConfig.ENDPOINT_STATUS));

      final response = await _httpClient
          .get(url)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to check status: $e');
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorData = jsonDecode(response.body);
      throw ApiException(
        errorData['error'] ?? 'Request failed',
        statusCode: response.statusCode,
        details: errorData['details'],
      );
    }
  }

  // ============================================================================
  // WEBSOCKET METHODS
  // ============================================================================

  /// Connect to WebSocket
  void connectWebSocket(String sessionId) {
    _sessionId = sessionId;

    // Disconnect existing socket
    disconnectWebSocket();

    print('[WebSocket] Connecting to ${AppConfig.WS_URL}');

    _socket = IO.io(
      AppConfig.WS_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('[WebSocket] Connected');
      _isConnected = true;
      _connectionController.add(true);

      // Join session room
      _socket!.emit('join', sessionId);
    });

    _socket!.onDisconnect((_) {
      print('[WebSocket] Disconnected');
      _isConnected = false;
      _connectionController.add(false);
    });

    _socket!.on('joined', (data) {
      print('[WebSocket] Joined session: ${data['sessionId']}');
    });

    _socket!.on('message', (data) {
      print('[WebSocket] Received message');
      try {
        final message = Message.fromJson(data as Map<String, dynamic>);
        _messageController.add(message);
      } catch (e) {
        print('[WebSocket] Error parsing message: $e');
      }
    });

    _socket!.on('error', (error) {
      print('[WebSocket] Error: $error');
    });

    _socket!.onConnectError((error) {
      print('[WebSocket] Connection error: $error');
      _isConnected = false;
      _connectionController.add(false);
    });

    // Connect
    _socket!.connect();
  }

  /// Disconnect WebSocket
  void disconnectWebSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  /// Send typing indicator
  void sendTypingIndicator(String sessionId, bool isTyping) {
    if (_socket != null && _isConnected) {
      _socket!.emit('typing', {'sessionId': sessionId, 'isTyping': isTyping});
    }
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Dispose resources
  void dispose() {
    disconnectWebSocket();
    _messageController.close();
    _connectionController.close();
    _httpClient.close();
  }
}
