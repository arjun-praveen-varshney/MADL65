import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define JSON string
    String jsonString = '[{"name":"Apple"}, {"name":"Banana"}, {"name":"Orange"}, {"name":"Mango"}]';
    
    // Parse JSON
    List<dynamic> fruits = json.decode(jsonString);

    return MaterialApp(
      title: 'JSON Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fruit List'),
        ),
        body: ListView.builder(
          itemCount: fruits.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.apple),
              title: Text(fruits[index]['name']),
            );
          },
        ),
      ),
    );
  }
}