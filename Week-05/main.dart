import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Widgets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LayoutDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LayoutDemoPage extends StatefulWidget {
  const LayoutDemoPage({Key? key}) : super(key: key);

  @override
  State<LayoutDemoPage> createState() => _LayoutDemoPageState();
}

class _LayoutDemoPageState extends State<LayoutDemoPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Widgets'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 20),

              // Row Layout Demo
              _buildSectionTitle('Row Layout'),
              _buildRowDemo(),
              const SizedBox(height: 20),

              // Column Layout Demo
              _buildSectionTitle('Column Layout'),
              _buildColumnDemo(),
              const SizedBox(height: 20),

              // Stack Layout Demo
              _buildSectionTitle('Stack Layout'),
              _buildStackDemo(),
              const SizedBox(height: 20),

              // Container with Alignment Demo
              _buildSectionTitle('Container & Alignment'),
              _buildContainerDemo(),
              const SizedBox(height: 20),

              // Expanded & Flexible Demo
              _buildSectionTitle('Expanded & Flexible'),
              _buildExpandedFlexibleDemo(),
              const SizedBox(height: 20),

              // Wrap Layout Demo
              _buildSectionTitle('Wrap Layout'),
              _buildWrapDemo(),
              const SizedBox(height: 20),

              // ListView Demo
              _buildSectionTitle('ListView'),
              _buildListViewDemo(),
              const SizedBox(height: 20),

              // GridView Demo
              _buildSectionTitle('GridView'),
              _buildGridViewDemo(),
              const SizedBox(height: 20),

              // Padding & Margin Demo
              _buildSectionTitle('Padding & Margin'),
              _buildPaddingMarginDemo(),
              const SizedBox(height: 20),

              // AspectRatio & SizedBox Demo
              _buildSectionTitle('AspectRatio & SizedBox'),
              _buildAspectRatioDemo(),
              const SizedBox(height: 20),

              // Align & Center Demo
              _buildSectionTitle('Align & Center'),
              _buildAlignCenterDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            Icon(Icons.dashboard, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Layout Widgets Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Comprehensive layout examples',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildRowDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MainAxisAlignment.spaceEvenly',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorBox(Colors.red, '1'),
                _buildColorBox(Colors.green, '2'),
                _buildColorBox(Colors.blue, '3'),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'MainAxisAlignment.spaceBetween',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColorBox(Colors.orange, '1'),
                _buildColorBox(Colors.purple, '2'),
                _buildColorBox(Colors.teal, '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildColorBox(Colors.red, '1'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.green, '2'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.blue, '3'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Center', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildColorBox(Colors.orange, '1'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.purple, '2'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.teal, '3'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('End', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildColorBox(Colors.pink, '1'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.amber, '2'),
                const SizedBox(height: 5),
                _buildColorBox(Colors.cyan, '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.purple.shade300],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Top Left',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Top Right',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Center',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Bottom Left',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Bottom Right',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainerDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.red.shade300],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Container with Gradient & Shadow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite, color: Colors.white, size: 30),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.star, color: Colors.white, size: 30),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.thumb_up, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedFlexibleDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expanded widgets (equal space)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.red,
                    child: const Center(
                      child: Text('Expanded 1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.green,
                    child: const Center(
                      child: Text('Expanded 2', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Expanded 3', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Flexible with flex values (1:2:1)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Colors.orange,
                    child: const Center(
                      child: Text('Flex 1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 50,
                    color: Colors.purple,
                    child: const Center(
                      child: Text('Flex 2', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Colors.teal,
                    child: const Center(
                      child: Text('Flex 1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrapDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wrap auto-arranges children when space runs out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: const Text('Flutter'),
                  backgroundColor: Colors.blue.shade100,
                ),
                Chip(
                  label: const Text('Dart'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: const Text('Widgets'),
                  backgroundColor: Colors.orange.shade100,
                ),
                Chip(
                  label: const Text('Layout'),
                  backgroundColor: Colors.purple.shade100,
                ),
                Chip(
                  label: const Text('Responsive'),
                  backgroundColor: Colors.red.shade100,
                ),
                Chip(
                  label: const Text('UI Design'),
                  backgroundColor: Colors.teal.shade100,
                ),
                Chip(
                  label: const Text('Animation'),
                  backgroundColor: Colors.pink.shade100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewDemo() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ListView with ListTile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: Text('${index + 1}'),
                ),
                title: Text('List Item ${index + 1}'),
                subtitle: Text('Subtitle for item ${index + 1}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridViewDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GridView with 3 columns',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                6,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaddingMarginDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Padding affects internal spacing',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.blue,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'With Padding',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Margin affects external spacing',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.green.shade100,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                color: Colors.green,
                height: 50,
                child: const Center(
                  child: Text(
                    'With Margin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectRatioDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AspectRatio maintains width:height ratio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          '16:9',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'SizedBox with fixed dimensions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              height: 100,
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    '150x100',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignCenterDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Align widget with different alignments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: _buildColorBox(Colors.red, 'TL'),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _buildColorBox(Colors.green, 'TC'),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: _buildColorBox(Colors.blue, 'TR'),
                  ),
                  Center(
                    child: _buildColorBox(Colors.orange, 'C'),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: _buildColorBox(Colors.purple, 'BL'),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildColorBox(Colors.teal, 'BC'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _buildColorBox(Colors.pink, 'BR'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String text) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}