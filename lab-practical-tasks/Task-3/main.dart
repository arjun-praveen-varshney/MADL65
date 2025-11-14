import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Action Buttons',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Action Buttons'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.call, size: 40),
                color: Colors.green,
                onPressed: () {
                  print('Call button pressed');
                },
              ),
              IconButton(
                icon: const Icon(Icons.message, size: 40),
                color: Colors.blue,
                onPressed: () {
                  print('Message button pressed');
                },
              ),
              IconButton(
                icon: const Icon(Icons.email, size: 40),
                color: Colors.red,
                onPressed: () {
                  print('Email button pressed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}