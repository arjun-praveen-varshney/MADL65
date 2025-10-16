import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widgets Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isChecked = false;
  bool _isSwitched = false;
  double _sliderValue = 50;
  String _selectedOption = 'Option 1';
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Dialog'),
        content: const Text('This is an example of an AlertDialog widget'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Flutter Widgets'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showSnackBar('Info button pressed'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.widgets, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Navigation Drawer',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Counter Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Counter Example',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_counter',
                        style: const TextStyle(fontSize: 48, color: Colors.blue),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _incrementCounter,
                        icon: const Icon(Icons.add),
                        label: const Text('Increment'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Text Input Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Text Input',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter text',
                          hintText: 'Type something...',
                          prefixIcon: Icon(Icons.edit),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            _showSnackBar('You entered: ${_textController.text}');
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Interactive Widgets Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interactive Widgets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CheckboxListTile(
                        title: const Text('Checkbox'),
                        value: _isChecked,
                        onChanged: (val) => setState(() => _isChecked = val ?? false),
                      ),
                      SwitchListTile(
                        title: const Text('Switch'),
                        value: _isSwitched,
                        onChanged: (val) => setState(() => _isSwitched = val),
                      ),
                      const SizedBox(height: 10),
                      Text('Slider Value: ${_sliderValue.toInt()}'),
                      Slider(
                        value: _sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 10,
                        label: _sliderValue.toInt().toString(),
                        onChanged: (val) => setState(() => _sliderValue = val),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _selectedOption,
                        isExpanded: true,
                        items: ['Option 1', 'Option 2', 'Option 3']
                            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedOption = val!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Buttons Row
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Button Types',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: () => _showSnackBar('Elevated Button'),
                            child: const Text('Elevated'),
                          ),
                          OutlinedButton(
                            onPressed: () => _showSnackBar('Outlined Button'),
                            child: const Text('Outlined'),
                          ),
                          TextButton(
                            onPressed: () => _showSnackBar('Text Button'),
                            child: const Text('Text'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                            onPressed: () => _showSnackBar('Icon Button'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Image & Icons Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Images & Icons',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.star, size: 40, color: Colors.amber),
                          Icon(Icons.favorite, size: 40, color: Colors.red),
                          Icon(Icons.thumb_up, size: 40, color: Colors.blue),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.purple,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dialog Button
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dialogs & Feedback',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _showAlertDialog,
                        icon: const Icon(Icons.message),
                        label: const Text('Show Dialog'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSnackBar('FAB Pressed!'),
        tooltip: 'Floating Action Button',
        child: const Icon(Icons.add),
      ),
    );
  }
}