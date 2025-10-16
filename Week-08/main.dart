import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libraries & File Handling',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// User Model Class
class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, age: $age}';
  }
}

// Product Model Class
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'inStock': inStock,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      inStock: json['inStock'] as bool,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // In-memory storage (simulating file storage)
  List<User> _users = [];
  List<Product> _products = [];
  String _jsonData = '';
  String _parsedData = '';
  
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _animController.forward();
    
    _loadSampleData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    setState(() {
      _users = [
        User(id: '1', name: 'John Doe', email: 'john@example.com', age: 28),
        User(id: '2', name: 'Jane Smith', email: 'jane@example.com', age: 32),
        User(id: '3', name: 'Bob Johnson', email: 'bob@example.com', age: 25),
      ];
      
      _products = [
        Product(id: 'P1', name: 'Laptop', price: 999.99, category: 'Electronics', inStock: true),
        Product(id: 'P2', name: 'Phone', price: 699.99, category: 'Electronics', inStock: true),
        Product(id: 'P3', name: 'Headphones', price: 149.99, category: 'Audio', inStock: false),
      ];
    });
  }

  void _saveUserData() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _ageController.text.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      email: _emailController.text,
      age: int.parse(_ageController.text),
    );

    setState(() {
      _users.add(newUser);
    });

    _nameController.clear();
    _emailController.clear();
    _ageController.clear();

    _showMessage('User saved successfully!');
  }

  void _exportToJson() {
    final data = {
      'users': _users.map((u) => u.toJson()).toList(),
      'products': _products.map((p) => p.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
      'totalUsers': _users.length,
      'totalProducts': _products.length,
    };

    final jsonString = JsonEncoder.withIndent('  ').convert(data);

    setState(() {
      _jsonData = jsonString;
    });

    _showMessage('Data exported to JSON');
  }

  void _parseJsonData() {
    try {
      final jsonString = '''
      {
        "id": "100",
        "name": "Alice Williams",
        "email": "alice@example.com",
        "age": 30
      }
      ''';

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final user = User.fromJson(jsonMap);

      setState(() {
        _parsedData = 'Parsed User:\n${user.toString()}';
      });

      _showMessage('JSON parsed successfully');
    } catch (e) {
      _showMessage('Error parsing JSON: $e');
    }
  }

  void _deleteUser(String id) {
    setState(() {
      _users.removeWhere((user) => user.id == id);
    });
    _showMessage('User deleted');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libraries & File Handling'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSectionTitle('Dart Libraries Demo'),
              _buildLibrariesDemo(),
              const SizedBox(height: 20),
              _buildSectionTitle('JSON Serialization'),
              _buildJsonDemo(),
              const SizedBox(height: 20),
              _buildSectionTitle('Add User (File Storage Simulation)'),
              _buildAddUserForm(),
              const SizedBox(height: 20),
              _buildSectionTitle('Stored Users'),
              _buildUsersList(),
              const SizedBox(height: 20),
              _buildSectionTitle('Products Database'),
              _buildProductsList(),
              const SizedBox(height: 20),
              _buildSectionTitle('Export & Import Operations'),
              _buildFileOperations(),
              const SizedBox(height: 20),
              _buildSectionTitle('JSON Data View'),
              _buildJsonViewer(),
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
            Icon(Icons.folder, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Libraries & File Handling',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Working with JSON & Data Persistence',
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

  Widget _buildLibrariesDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Built-in Dart Libraries Used:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            _buildLibraryItem('dart:convert', 'JSON encoding/decoding', Icons.code),
            _buildLibraryItem('dart:math', 'Mathematical operations', Icons.functions),
            _buildLibraryItem('dart:core', 'Core Dart functionality', Icons.settings),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calculate, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  'Random Number: ${math.Random().nextInt(100)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.square_foot, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  'Square Root of 64: ${math.sqrt(64).toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.orange),
                const SizedBox(width: 10),
                Text(
                  'PI value: ${math.pi.toStringAsFixed(4)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryItem(String library, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  library,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'JSON Operations:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _parseJsonData,
              icon: const Icon(Icons.input),
              label: const Text('Parse JSON String'),
            ),
            const SizedBox(height: 10),
            if (_parsedData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  _parsedData,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddUserForm() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _saveUserData,
              icon: const Icon(Icons.save),
              label: const Text('Save User'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    if (_users.isEmpty) {
      return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: const [
                Icon(Icons.inbox, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text('No users stored', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Users: ${_users.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('${_users.length}'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user.name),
                subtitle: Text('${user.email} • Age: ${user.age}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('${_products.length}'),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = _products[index];
              return ListTile(
                leading: Icon(
                  Icons.shopping_bag,
                  color: product.inStock ? Colors.green : Colors.red,
                ),
                title: Text(product.name),
                subtitle: Text('${product.category} • \$${product.price.toStringAsFixed(2)}'),
                trailing: Chip(
                  label: Text(
                    product.inStock ? 'In Stock' : 'Out of Stock',
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: product.inStock ? Colors.green.shade100 : Colors.red.shade100,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFileOperations() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _exportToJson,
              icon: const Icon(Icons.upload_file),
              label: const Text('Export All Data to JSON'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _jsonData = '';
                  _parsedData = '';
                });
                _showMessage('Views cleared');
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear JSON View'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJsonViewer() {
    if (_jsonData.isEmpty) {
      return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: const [
                Icon(Icons.description, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No JSON data to display',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  'Click "Export All Data to JSON" to view',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exported JSON Data:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _showMessage('JSON copied to clipboard (simulated)'),
                  tooltip: 'Copy JSON',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _jsonData,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}