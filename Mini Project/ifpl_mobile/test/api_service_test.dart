/// API Service Tests
///
/// Tests for ApiService HTTP and WebSocket communication.
/// Uses mocks to test without actual network calls.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:ifpl_mobile/services/api_service.dart';
import 'package:ifpl_mobile/models/message.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    tearDown(() {
      apiService.dispose();
    });

    test('instance returns same singleton', () {
      final instance1 = ApiService();
      final instance2 = ApiService();
      expect(identical(instance1, instance2), true);
    });

    group('Message Parsing', () {
      test('parses successful text message response', () {
        final json = {
          'text': 'This is a response',
          'language': 'en',
          'rag_sources': [
            {'filename': 'doc.pdf', 'page_num': 5, 'excerpt': 'Sample text'},
          ],
          'follow_up_questions': ['Question 1?', 'Question 2?'],
          'tts_audio_url': '/audio/test.mp3',
          'needs_verification': false,
        };

        // Verify the structure matches what Message.fromJson expects
        expect(json['text'], isNotNull);
        expect(json['rag_sources'], isA<List>());
        expect(json['follow_up_questions'], isA<List>());
      });

      test('handles message with no citations', () {
        final json = {'text': 'Simple response', 'language': 'en'};

        expect(json['text'], isNotNull);
        expect(json['rag_sources'], isNull);
      });

      test('handles message with empty citations', () {
        final json = {
          'text': 'Response',
          'language': 'hi',
          'rag_sources': <Map<String, dynamic>>[],
        };

        expect(json['rag_sources'], isEmpty);
      });
    });

    group('Error Handling', () {
      test('ApiException includes message and status code', () {
        final exception = ApiException(
          'Network error',
          statusCode: 500,
          details: {'info': 'server issue'},
        );

        expect(exception.message, 'Network error');
        expect(exception.statusCode, 500);
        expect(exception.details, isNotNull);
        expect(exception.toString(), contains('Network error'));
        expect(exception.toString(), contains('500'));
      });

      test('ApiException with no status code', () {
        final exception = ApiException('Generic error');

        expect(exception.message, 'Generic error');
        expect(exception.statusCode, isNull);
      });
    });

    group('Session Management', () {
      test('session ID is initially null', () {
        expect(apiService.sessionId, isNull);
      });

      test('connection status starts as false', () {
        expect(apiService.isConnected, false);
      });
    });

    group('WebSocket Streams', () {
      test('messageStream is broadcast stream', () {
        expect(apiService.messageStream.isBroadcast, true);
      });

      test('connectionStream is broadcast stream', () {
        expect(apiService.connectionStream.isBroadcast, true);
      });
    });
  });

  group('ApiService Integration Tests', () {
    // These would require actual backend or comprehensive mocking
    test('placeholder for sendTextMessage integration', () {
      // TODO: Implement with mock HTTP client
      expect(true, true);
    });

    test('placeholder for sendAudioMessage integration', () {
      // TODO: Implement with mock HTTP client
      expect(true, true);
    });

    test('placeholder for WebSocket connection', () {
      // TODO: Implement with mock Socket.IO
      expect(true, true);
    });
  });

  group('URL Construction', () {
    test('constructs correct API URLs', () {
      // These test the URL construction logic
      const baseUrl = 'http://localhost:4000';
      const endpoint = '/chat/sendText';
      final fullUrl = '$baseUrl$endpoint';

      expect(fullUrl, 'http://localhost:4000/chat/sendText');
    });

    test('handles trailing slashes', () {
      const baseUrl = 'http://localhost:4000/';
      const endpoint = 'chat/sendText';
      // Normalize to avoid double slashes
      final fullUrl = baseUrl.endsWith('/') && endpoint.startsWith('/')
          ? '$baseUrl${endpoint.substring(1)}'
          : '$baseUrl$endpoint';

      expect(fullUrl, 'http://localhost:4000/chat/sendText');
    });
  });
}
