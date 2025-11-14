import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Toggler',
      home: const ColorTogglerScreen(),
    );
  }
}

class ColorTogglerScreen extends StatefulWidget {
  const ColorTogglerScreen({Key? key}) : super(key: key);

  @override
  State<ColorTogglerScreen> createState() => _ColorTogglerScreenState();
}

class _ColorTogglerScreenState extends State<ColorTogglerScreen> {
  Color _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Color Toggler'),
      ),
      body: const Center(
        child: Text(
          'Tap the button to toggle background color',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _backgroundColor = _backgroundColor == Colors.white
                ? Colors.blue
                : Colors.white;
          });
        },
        child: const Icon(Icons.color_lens),
      ),
    );
  }
}