/// Language Selector Widget
///
/// Dropdown to switch between supported languages (English, Hindi).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_provider.dart';
import '../config.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: 'Change Language',
          onSelected: (String languageCode) {
            provider.setLanguage(languageCode);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  if (provider.language == 'en')
                    const Icon(Icons.check, size: 16),
                  if (provider.language == 'en') const SizedBox(width: 8),
                  const Text('English'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'hi',
              child: Row(
                children: [
                  if (provider.language == 'hi')
                    const Icon(Icons.check, size: 16),
                  if (provider.language == 'hi') const SizedBox(width: 8),
                  const Text('हिन्दी (Hindi)'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
