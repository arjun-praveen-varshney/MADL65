/// Message Model Tests
///
/// Tests for Message and Citation model JSON serialization and methods.

import 'package:flutter_test/flutter_test.dart';
import 'package:ifpl_mobile/models/message.dart';

void main() {
  group('Citation', () {
    test('fromJson creates valid Citation', () {
      final json = {
        'filename': 'test.pdf',
        'page_num': 5,
        'excerpt': 'Sample excerpt text',
        'score': 0.85,
      };

      final citation = Citation.fromJson(json);

      expect(citation.filename, 'test.pdf');
      expect(citation.pageNum, 5);
      expect(citation.excerpt, 'Sample excerpt text');
      expect(citation.score, 0.85);
    });

    test('toJson creates valid JSON', () {
      final citation = Citation(
        filename: 'document.pdf',
        pageNum: 10,
        excerpt: 'Test excerpt',
        score: 0.9,
      );

      final json = citation.toJson();

      expect(json['filename'], 'document.pdf');
      expect(json['page_num'], 10);
      expect(json['excerpt'], 'Test excerpt');
      expect(json['score'], 0.9);
    });

    test('Citation with null fields', () {
      final citation = Citation(filename: 'minimal.pdf');

      final json = citation.toJson();

      expect(json['filename'], 'minimal.pdf');
      expect(json.containsKey('page_num'), false);
      expect(json.containsKey('excerpt'), false);
      expect(json.containsKey('score'), false);
    });
  });

  group('Message', () {
    test('fromJson creates valid Message', () {
      final json = {
        'id': 'msg-123',
        'role': 'user',
        'text': 'Hello world',
        'timestamp': 1699000000000,
        'language': 'en',
      };

      final message = Message.fromJson(json);

      expect(message.id, 'msg-123');
      expect(message.role, MessageRole.user);
      expect(message.text, 'Hello world');
      expect(message.language, 'en');
      expect(message.timestamp.millisecondsSinceEpoch, 1699000000000);
    });

    test('fromJson with citations', () {
      final json = {
        'id': 'msg-456',
        'role': 'assistant',
        'text': 'According to the document...',
        'timestamp': 1699000000000,
        'rag_sources': [
          {
            'filename': 'doc1.pdf',
            'page_num': 3,
            'excerpt': 'Important info',
            'score': 0.95,
          },
          {'filename': 'doc2.pdf', 'page_num': 7},
        ],
      };

      final message = Message.fromJson(json);

      expect(message.citations.length, 2);
      expect(message.citations[0].filename, 'doc1.pdf');
      expect(message.citations[0].pageNum, 3);
      expect(message.citations[1].filename, 'doc2.pdf');
      expect(message.hasCitations, true);
    });

    test('fromJson with follow-up questions', () {
      final json = {
        'id': 'msg-789',
        'role': 'assistant',
        'text': 'Here is your answer',
        'timestamp': 1699000000000,
        'follow_up_questions': [
          'What about fixed deposits?',
          'Tell me more about loans',
        ],
      };

      final message = Message.fromJson(json);

      expect(message.followUpQuestions.length, 2);
      expect(message.followUpQuestions[0], 'What about fixed deposits?');
      expect(message.hasFollowUp, true);
    });

    test('toJson creates valid JSON', () {
      final message = Message(
        id: 'test-id',
        role: MessageRole.user,
        text: 'Test message',
        timestamp: DateTime.fromMillisecondsSinceEpoch(1699000000000),
        language: 'hi',
        citations: [Citation(filename: 'test.pdf', pageNum: 1)],
        followUpQuestions: ['Question 1?'],
        audioUrl: '/audio/test.mp3',
        needsVerification: true,
      );

      final json = message.toJson();

      expect(json['id'], 'test-id');
      expect(json['role'], 'user');
      expect(json['text'], 'Test message');
      expect(json['timestamp'], 1699000000000);
      expect(json['language'], 'hi');
      expect(json['rag_sources'], isA<List>());
      expect(json['follow_up_questions'], ['Question 1?']);
      expect(json['tts_audio_url'], '/audio/test.mp3');
      expect(json['needs_verification'], true);
    });

    test('copyWith creates modified copy', () {
      final original = Message(
        id: 'original',
        role: MessageRole.user,
        text: 'Original text',
        timestamp: DateTime.now(),
      );

      final modified = original.copyWith(text: 'Modified text', language: 'hi');

      expect(modified.id, 'original');
      expect(modified.text, 'Modified text');
      expect(modified.language, 'hi');
      expect(modified.role, MessageRole.user);
    });

    test('MessageRole parsing', () {
      final userMsg = Message.fromJson({
        'role': 'user',
        'text': 'test',
        'timestamp': 1699000000000,
      });

      final assistantMsg = Message.fromJson({
        'role': 'assistant',
        'text': 'test',
        'timestamp': 1699000000000,
      });

      final systemMsg = Message.fromJson({
        'role': 'system',
        'text': 'test',
        'timestamp': 1699000000000,
      });

      expect(userMsg.role, MessageRole.user);
      expect(assistantMsg.role, MessageRole.assistant);
      expect(systemMsg.role, MessageRole.system);
    });

    test('Message equality', () {
      final msg1 = Message(
        id: 'same-id',
        role: MessageRole.user,
        text: 'Message 1',
        timestamp: DateTime.now(),
      );

      final msg2 = Message(
        id: 'same-id',
        role: MessageRole.assistant,
        text: 'Different text',
        timestamp: DateTime.now(),
      );

      final msg3 = Message(
        id: 'different-id',
        role: MessageRole.user,
        text: 'Message 3',
        timestamp: DateTime.now(),
      );

      expect(msg1 == msg2, true); // Same ID
      expect(msg1 == msg3, false); // Different ID
    });

    test('hasAudio, hasCitations, hasFollowUp flags', () {
      final message = Message(
        id: 'test',
        role: MessageRole.assistant,
        text: 'Test',
        timestamp: DateTime.now(),
        audioUrl: '/audio/test.mp3',
        citations: [Citation(filename: 'test.pdf')],
        followUpQuestions: ['Q1?'],
      );

      expect(message.hasAudio, true);
      expect(message.hasCitations, true);
      expect(message.hasFollowUp, true);
    });

    test('Empty audio/citations/followUp flags', () {
      final message = Message(
        id: 'test',
        role: MessageRole.user,
        text: 'Test',
        timestamp: DateTime.now(),
      );

      expect(message.hasAudio, false);
      expect(message.hasCitations, false);
      expect(message.hasFollowUp, false);
    });
  });

  group('MessageRole', () {
    test('displayName returns correct values', () {
      expect(MessageRole.user.displayName, 'You');
      expect(MessageRole.assistant.displayName, 'Shankh.ai');
      expect(MessageRole.system.displayName, 'System');
    });
  });
}
