import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icons, Images & Charts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MediaDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MediaDemoPage extends StatefulWidget {
  const MediaDemoPage({Key? key}) : super(key: key);

  @override
  State<MediaDemoPage> createState() => _MediaDemoPageState();
}

class _MediaDemoPageState extends State<MediaDemoPage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons, Images & Charts'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSectionTitle('Material Icons'),
            _buildIconsDemo(),
            const SizedBox(height: 20),
            _buildSectionTitle('Animated Icons'),
            _buildAnimatedIconsDemo(),
            const SizedBox(height: 20),
            _buildSectionTitle('Icon Buttons & Actions'),
            _buildIconButtonsDemo(),
            const SizedBox(height: 20),
            _buildSectionTitle('Network Images'),
            _buildNetworkImagesDemo(),
            const SizedBox(height: 20),
            _buildSectionTitle('Image Shapes & Decorations'),
            _buildImageShapesDemo(),
            const SizedBox(height: 20),
            _buildSectionTitle('Bar Chart'),
            _buildBarChart(),
            const SizedBox(height: 20),
            _buildSectionTitle('Pie Chart'),
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildSectionTitle('Line Chart'),
            _buildLineChart(),
            const SizedBox(height: 20),
            _buildSectionTitle('Progress Indicators'),
            _buildProgressIndicators(),
            const SizedBox(height: 20),
            _buildSectionTitle('Custom Painted Chart'),
            _buildCustomPaintDemo(),
          ],
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
            Icon(Icons.image, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Media Elements Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Icons, Images & Charts',
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

  Widget _buildIconsDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home, size: 40, color: Colors.blue),
                Icon(Icons.favorite, size: 40, color: Colors.red),
                Icon(Icons.star, size: 40, color: Colors.amber),
                Icon(Icons.shopping_cart, size: 40, color: Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.notifications, size: 40, color: Colors.orange),
                Icon(Icons.email, size: 40, color: Colors.purple),
                Icon(Icons.phone, size: 40, color: Colors.teal),
                Icon(Icons.camera, size: 40, color: Colors.pink),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.cloud, size: 40, color: Colors.lightBlue),
                Icon(Icons.wb_sunny, size: 40, color: Colors.yellow),
                Icon(Icons.music_note, size: 40, color: Colors.deepPurple),
                Icon(Icons.local_fire_department, size: 40, color: Colors.deepOrange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIconsDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                RotationTransition(
                  turns: _rotationController,
                  child: const Icon(Icons.refresh, size: 50, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                const Text('Rotating'),
              ],
            ),
            Column(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: const Icon(Icons.favorite, size: 50, color: Colors.red),
                ),
                const SizedBox(height: 8),
                const Text('Pulsing'),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, size: 50, color: Colors.amber),
                ),
                const SizedBox(height: 8),
                const Text('Highlighted'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButtonsDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  iconSize: 35,
                  color: Colors.blue,
                  onPressed: () => _showMessage('Liked!'),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  iconSize: 35,
                  color: Colors.green,
                  onPressed: () => _showMessage('Shared!'),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  iconSize: 35,
                  color: Colors.orange,
                  onPressed: () => _showMessage('Bookmarked!'),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  iconSize: 35,
                  color: Colors.purple,
                  onPressed: () => _showMessage('Downloaded!'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Tap any icon to interact', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImagesDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://picsum.photos/400/200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Network Image with BoxFit.cover',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageShapesDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://picsum.photos/100/100?random=1',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Rounded', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    'https://picsum.photos/100/100?random=2',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Circle', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/100/100?random=3'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Bordered', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final data = [
      {'label': 'Mon', 'value': 65.0, 'color': Colors.blue},
      {'label': 'Tue', 'value': 80.0, 'color': Colors.green},
      {'label': 'Wed', 'value': 45.0, 'color': Colors.orange},
      {'label': 'Thu', 'value': 90.0, 'color': Colors.purple},
      {'label': 'Fri', 'value': 70.0, 'color': Colors.red},
      {'label': 'Sat', 'value': 55.0, 'color': Colors.teal},
      {'label': 'Sun', 'value': 85.0, 'color': Colors.pink},
    ];

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Sales (in units)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map((item) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${item['value']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 35,
                        height: (item['value'] as double) * 2,
                        decoration: BoxDecoration(
                          color: item['color'] as Color,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['label'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final data = [
      {'label': 'Electronics', 'value': 35, 'color': Colors.blue},
      {'label': 'Clothing', 'value': 25, 'color': Colors.green},
      {'label': 'Food', 'value': 20, 'color': Colors.orange},
      {'label': 'Books', 'value': 15, 'color': Colors.purple},
      {'label': 'Others', 'value': 5, 'color': Colors.red},
    ];

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales by Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 150,
                    child: CustomPaint(
                      painter: PieChartPainter(data),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${item['label']}\n${item['value']}%',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Revenue Trend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: LineChartPainter(),
                child: Container(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Jan', style: TextStyle(fontSize: 12)),
                Text('Feb', style: TextStyle(fontSize: 12)),
                Text('Mar', style: TextStyle(fontSize: 12)),
                Text('Apr', style: TextStyle(fontSize: 12)),
                Text('May', style: TextStyle(fontSize: 12)),
                Text('Jun', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Completion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildProgressRow('Design', 0.85, Colors.blue),
            const SizedBox(height: 15),
            _buildProgressRow('Development', 0.65, Colors.green),
            const SizedBox(height: 15),
            _buildProgressRow('Testing', 0.40, Colors.orange),
            const SizedBox(height: 15),
            _buildProgressRow('Deployment', 0.20, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomPaintDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Radial Chart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: RadialChartPainter(0.75),
                  child: const Center(
                    child: Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text('Overall Performance', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    double startAngle = -math.pi / 2;

    for (var item in data) {
      final sweepAngle = 2 * math.pi * (item['value'] as int) / 100;
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.15),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadialChartPainter extends CustomPainter {
  final double percentage;

  RadialChartPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    canvas.drawCircle(center, radius - 10, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}