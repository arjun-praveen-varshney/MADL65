import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Demo',
      home: const DraggableScreen(),
    );
  }
}

class DraggableScreen extends StatefulWidget {
  const DraggableScreen({Key? key}) : super(key: key);

  @override
  State<DraggableScreen> createState() => _DraggableScreenState();
}

class _DraggableScreenState extends State<DraggableScreen> {
  Color _targetColor = Colors.grey;
  String _targetText = 'Drop Here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Draggable<Color>(
              data: Colors.blue,
              feedback: Opacity(
                opacity: 0.5,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Drag me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: 100,
                height: 100,
                color: Colors.blue.withOpacity(0.3),
                child: const Center(
                  child: Text(
                    'Dragging...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Drag me',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          DragTarget<Color>(
            onAccept: (color) {
              setState(() {
                _targetColor = color;
                _targetText = 'Item Dropped!';
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 200,
                height: 200,
                color: _targetColor,
                child: Center(
                  child: Text(
                    _targetText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}