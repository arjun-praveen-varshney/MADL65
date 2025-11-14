import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabBar Demo',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TabBar Demo'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.chat),
                  text: 'Chats',
                ),
                Tab(
                  icon: Icon(Icons.info),
                  text: 'Status',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: Text(
                  'Chats Screen',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Center(
                child: Text(
                  'Status Screen',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}