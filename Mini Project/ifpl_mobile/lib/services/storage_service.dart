/// Storage Service
///
/// Handles local persistence of messages using SQLite.
/// Provides methods to save, load, and manage chat history.

import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/message.dart';

/// Storage service for message persistence
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Database? _database;

  /// Database name
  static const String _databaseName = 'ifpl_chat.db';
  static const int _databaseVersion = 1;

  /// Table name
  static const String _messagesTable = 'messages';

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_messagesTable (
        id TEXT PRIMARY KEY,
        role TEXT NOT NULL,
        text TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        language TEXT,
        html_formatted TEXT,
        citations TEXT,
        follow_up_questions TEXT,
        audio_url TEXT,
        needs_verification INTEGER DEFAULT 0,
        is_transcribing INTEGER DEFAULT 0
      )
    ''');

    // Create index on timestamp for sorting
    await db.execute('''
      CREATE INDEX idx_messages_timestamp 
      ON $_messagesTable (timestamp DESC)
    ''');

    print('[StorageService] Database tables created');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future schema changes here
    if (oldVersion < 2) {
      // Example migration for version 2
      // await db.execute('ALTER TABLE messages ADD COLUMN new_field TEXT');
    }
  }

  // ============================================================================
  // MESSAGE OPERATIONS
  // ============================================================================

  /// Save a message
  Future<void> saveMessage(Message message) async {
    try {
      final db = await database;

      await db.insert(
        _messagesTable,
        _messageToMap(message),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('[StorageService] Message saved: ${message.id}');
    } catch (e) {
      print('[StorageService] Failed to save message: $e');
    }
  }

  /// Load all messages
  Future<List<Message>> loadMessages({int? limit}) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTable,
        orderBy: 'timestamp ASC',
        limit: limit,
      );

      return maps.map((map) => _messageFromMap(map)).toList();
    } catch (e) {
      print('[StorageService] Failed to load messages: $e');
      return [];
    }
  }

  /// Delete a message by ID
  Future<void> deleteMessage(String id) async {
    try {
      final db = await database;

      await db.delete(_messagesTable, where: 'id = ?', whereArgs: [id]);

      print('[StorageService] Message deleted: $id');
    } catch (e) {
      print('[StorageService] Failed to delete message: $e');
    }
  }

  /// Clear all messages
  Future<void> clearMessages() async {
    try {
      final db = await database;

      await db.delete(_messagesTable);

      print('[StorageService] All messages cleared');
    } catch (e) {
      print('[StorageService] Failed to clear messages: $e');
    }
  }

  /// Get message count
  Future<int> getMessageCount() async {
    try {
      final db = await database;

      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_messagesTable'),
      );

      return count ?? 0;
    } catch (e) {
      print('[StorageService] Failed to get message count: $e');
      return 0;
    }
  }

  // ============================================================================
  // CONVERSION HELPERS
  // ============================================================================

  /// Convert Message to Map
  Map<String, dynamic> _messageToMap(Message message) {
    return {
      'id': message.id,
      'role': message.role.name,
      'text': message.text,
      'timestamp': message.timestamp.millisecondsSinceEpoch,
      'language': message.language,
      'html_formatted': message.htmlFormatted,
      'citations': jsonEncode(
        message.citations.map((c) => c.toJson()).toList(),
      ),
      'follow_up_questions': jsonEncode(message.followUpQuestions),
      'audio_url': message.audioUrl,
      'needs_verification': message.needsVerification ? 1 : 0,
      'is_transcribing': message.isTranscribing ? 1 : 0,
    };
  }

  /// Convert Map to Message
  Message _messageFromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      role: _parseRole(map['role'] as String),
      text: map['text'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      language: map['language'] as String?,
      htmlFormatted: map['html_formatted'] as String?,
      citations: _parseCitations(map['citations'] as String?),
      followUpQuestions: _parseFollowUp(map['follow_up_questions'] as String?),
      audioUrl: map['audio_url'] as String?,
      needsVerification: (map['needs_verification'] as int?) == 1,
      isTranscribing: (map['is_transcribing'] as int?) == 1,
    );
  }

  MessageRole _parseRole(String role) {
    switch (role) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  List<Citation> _parseCitations(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((c) => Citation.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  List<String> _parseFollowUp(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((q) => q as String).toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
