/// Chat Screen
///
/// Main chat interface with message list, input field, and voice recording.
/// Displays RAG citations, follow-up questions, and provides TTS playback.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_provider.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/language_selector.dart';
import '../widgets/citation_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto-scroll when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendText(ChatProvider provider) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    provider.sendTextMessage(text);
    _textController.clear();

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        // Auto-scroll when messages change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  provider.isConnected ? Icons.cloud_done : Icons.cloud_off,
                  size: 16,
                  color: provider.isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Shankh.ai'),
              ],
            ),
            actions: [
              const LanguageSelector(),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(context),
                tooltip: 'About',
              ),
            ],
          ),

          body: Column(
            children: [
              // Connection status banner
              if (!provider.isConnected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade100,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Connecting to server...',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

              // Error banner
              if (provider.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          // Clear error (would need to add this to provider)
                        },
                      ),
                    ],
                  ),
                ),

              // Messages list
              Expanded(
                child: provider.messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final message = provider.messages[index];
                          return MessageBubble(
                            message: message,
                            onFollowUpTap: (question) {
                              _textController.text = question;
                            },
                          );
                        },
                      ),
              ),

              // Loading indicator
              if (provider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Thinking...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

              // Input area
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text input
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: provider.language == 'hi'
                                  ? 'अपना संदेश टाइप करें...'
                                  : 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _handleSendText(provider),
                            enabled: !provider.isLoading,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Voice button (placeholder for now)
                        // TODO: Implement voice recording
                        IconButton(
                          icon: Icon(
                            provider.isRecording ? Icons.stop : Icons.mic,
                            color: provider.isRecording ? Colors.red : null,
                          ),
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  // TODO: Implement voice recording
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Voice input coming soon!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Send button
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: provider.isLoading
                              ? null
                              : () => _handleSendText(provider),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Shankh.ai',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your multilingual financial assistant',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('What is a fixed deposit?'),
                _buildSuggestionChip('Loan eligibility criteria'),
                _buildSuggestionChip('Types of savings accounts'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return ActionChip(
          label: Text(text),
          onPressed: () {
            _textController.text = text;
            _handleSendText(provider);
          },
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Shankh.ai'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IFPL Mobile v1.0.0'),
              SizedBox(height: 8),
              Text(
                'A multilingual financial chatbot powered by RAG '
                'and AI, designed for Indian users.',
              ),
              SizedBox(height: 16),
              Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Multilingual support (English, Hindi)'),
              Text('• RAG-enhanced responses with citations'),
              Text('• Voice input and output'),
              Text('• Real-time chat via WebSocket'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
