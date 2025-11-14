// Place this file in: test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Text widget test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Hello'),
          ),
        ),
      ),
    );

    // Verify that the text 'Hello' is found on the screen
    expect(find.text('Hello'), findsOneWidget);
    
    // Verify that some other text is not found
    expect(find.text('Goodbye'), findsNothing);
  });
}