import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      home: const ImageGalleryScreen(),
    );
  }
}

class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                print('Image 1 tapped');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image 1 tapped')),
                );
              },
              child: Image.network(
                'https://via.placeholder.com/150/FF0000/FFFFFF?text=Image+1',
                width: 100,
                height: 100,
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Image 2 tapped');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image 2 tapped')),
                );
              },
              child: Image.network(
                'https://via.placeholder.com/150/00FF00/FFFFFF?text=Image+2',
                width: 100,
                height: 100,
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Image 3 tapped');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image 3 tapped')),
                );
              },
              child: Image.network(
                'https://via.placeholder.com/150/0000FF/FFFFFF?text=Image+3',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}