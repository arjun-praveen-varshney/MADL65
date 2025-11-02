/// Message Model
///
/// Represents a chat message with support for text, citations, and attachments.
/// Includes JSON serialization for API communication and local persistence.

import 'package:intl/intl.dart';

/// Citation from RAG source
class Citation {
  final String filename;
  final int? pageNum;
  final String? excerpt;
  final double? score;

  const Citation({
    required this.filename,
    this.pageNum,
    this.excerpt,
    this.score,
  });

  /// Create Citation from JSON
  factory Citation.fromJson(Map<String, dynamic> json) {
    return Citation(
      filename: json['filename'] as String,
      pageNum: json['page_num'] as int?,
      excerpt: json['excerpt'] as String?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  /// Convert Citation to JSON
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      if (pageNum != null) 'page_num': pageNum,
      if (excerpt != null) 'excerpt': excerpt,
      if (score != null) 'score': score,
    };
  }

  @override
  String toString() => 'Citation($filename, page: $pageNum)';
}

/// Message role enumeration
enum MessageRole {
  user,
  assistant,
  system;

  String get displayName {
    switch (this) {
      case MessageRole.user:
        return 'You';
      case MessageRole.assistant:
        return 'Shankh.ai';
      case MessageRole.system:
        return 'System';
    }
  }
}

/// Chat Message
class Message {
  final String id;
  final MessageRole role;
  final String text;
  final DateTime timestamp;
  final String? language;
  final String? htmlFormatted;
  final List<Citation> citations;
  final List<String> followUpQuestions;
  final String? audioUrl;
  final bool needsVerification;
  final bool isTranscribing;

  const Message({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.language,
    this.htmlFormatted,
    this.citations = const [],
    this.followUpQuestions = const [],
    this.audioUrl,
    this.needsVerification = false,
    this.isTranscribing = false,
  });

  /// Create Message from JSON (API response)
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      role: _parseRole(json['role'] as String?),
      text: json['text'] as String? ?? json['content'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : DateTime.now(),
      language: json['language'] as String?,
      htmlFormatted: json['html_formatted'] as String?,
      citations:
          (json['rag_sources'] as List<dynamic>?)
              ?.map((c) => Citation.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      followUpQuestions:
          (json['follow_up_questions'] as List<dynamic>?)
              ?.map((q) => q as String)
              .toList() ??
          [],
      audioUrl: json['tts_audio_url'] as String?,
      needsVerification: json['needs_verification'] as bool? ?? false,
      isTranscribing: json['isTranscribing'] as bool? ?? false,
    );
  }

  /// Convert Message to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      if (language != null) 'language': language,
      if (htmlFormatted != null) 'html_formatted': htmlFormatted,
      'rag_sources': citations.map((c) => c.toJson()).toList(),
      'follow_up_questions': followUpQuestions,
      if (audioUrl != null) 'tts_audio_url': audioUrl,
      'needs_verification': needsVerification,
      'isTranscribing': isTranscribing,
    };
  }

  /// Parse role from string
  static MessageRole _parseRole(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
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

  /// Create a copy with updated fields
  Message copyWith({
    String? id,
    MessageRole? role,
    String? text,
    DateTime? timestamp,
    String? language,
    String? htmlFormatted,
    List<Citation>? citations,
    List<String>? followUpQuestions,
    String? audioUrl,
    bool? needsVerification,
    bool? isTranscribing,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      htmlFormatted: htmlFormatted ?? this.htmlFormatted,
      citations: citations ?? this.citations,
      followUpQuestions: followUpQuestions ?? this.followUpQuestions,
      audioUrl: audioUrl ?? this.audioUrl,
      needsVerification: needsVerification ?? this.needsVerification,
      isTranscribing: isTranscribing ?? this.isTranscribing,
    );
  }

  /// Get formatted timestamp
  String getFormattedTime() {
    return DateFormat('HH:mm').format(timestamp);
  }

  /// Get formatted date
  String getFormattedDate() {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }

  /// Check if message has citations
  bool get hasCitations => citations.isNotEmpty;

  /// Check if message has audio
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Check if message has follow-up questions
  bool get hasFollowUp => followUpQuestions.isNotEmpty;

  @override
  String toString() {
    return 'Message(id: $id, role: ${role.name}, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
