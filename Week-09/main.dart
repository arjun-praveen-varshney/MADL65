import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Firebase Configuration
Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    print('✅ Firebase Initialized Successfully');
  } catch (e) {
    print('❌ Firebase Initialization Error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Firestore Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FirebaseHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseHomePage extends StatefulWidget {
  const FirebaseHomePage({Key? key}) : super(key: key);

  @override
  State<FirebaseHomePage> createState() => _FirebaseHomePageState();
}

class _FirebaseHomePageState extends State<FirebaseHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
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
        title: const Text('Firebase Firestore Integration'),
        centerTitle: true,
        elevation: 2,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _selectedTab == 0 ? _buildProductsTab() : _buildUsersTab(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() => _selectedTab = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader('Products', 'Add and manage products', Icons.shopping_bag),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Add New Product'),
                const AddProductForm(),
                const SizedBox(height: 20),
                _buildSectionTitle('Products from Firestore'),
                ProductsList(firestore: _firestore),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader('Users', 'Add and manage users', Icons.people),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Add New User'),
                const AddUserForm(),
                const SizedBox(height: 20),
                _buildSectionTitle('Users from Firestore'),
                UsersList(firestore: _firestore),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// Add Product Form
class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      _showMessage('Please fill all required fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('products').add({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'inStock': true,
      });

      _nameController.clear();
      _priceController.clear();
      _categoryController.clear();
      _descriptionController.clear();

      _showMessage('✅ Product added to Firestore successfully!');
    } on FirebaseException catch (e) {
      _showMessage('❌ Error: ${e.message}');
    } catch (e) {
      _showMessage('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                prefixIcon: Icon(Icons.shopping_bag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price *',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Category *',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              enabled: !_isLoading,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addProduct,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload),
              label: Text(_isLoading ? 'Writing to Firestore...' : 'Write to Firestore'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Products List
class ProductsList extends StatelessWidget {
  final FirebaseFirestore firestore;

  const ProductsList({Key? key, required this.firestore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('products').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading products from Firestore...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            elevation: 2,
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        final products = snapshot.data?.docs ?? [];

        if (products.isEmpty) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  Icon(Icons.inbox, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No products found'),
                ],
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
                    const Text(
                      'Total Products',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text('${products.length}'),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final productData = products[index].data() as Map<String, dynamic>;
                  final docId = products[index].id;
                  final timestamp = productData['timestamp'] as Timestamp?;
                  final formattedTime = timestamp != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
                      : 'N/A';

                  return ListTile(
                    leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                    title: Text(productData['name'] ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${productData['category']} • \$${productData['price']}'),
                        Text(
                          'Added: $formattedTime',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(docId),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct(String docId) {
    firestore.collection('products').doc(docId).delete().then((_) {
      print('✅ Product deleted from Firestore');
    }).catchError((error) {
      print('❌ Error deleting product: $error');
    });
  }
}

// Add User Form
class AddUserForm extends StatefulWidget {
  const AddUserForm({Key? key}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty) {
      _showMessage('Please fill all required fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('users').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'age': int.parse(_ageController.text),
        'phone': _phoneController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'active': true,
      });

      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
      _phoneController.clear();

      _showMessage('✅ User added to Firestore successfully!');
    } on FirebaseException catch (e) {
      _showMessage('❌ Error: ${e.message}');
    } catch (e) {
      _showMessage('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              enabled: !_isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email *',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age *',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              enabled: !_isLoading,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addUser,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload),
              label: Text(_isLoading ? 'Writing to Firestore...' : 'Write to Firestore'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Users List
class UsersList extends StatelessWidget {
  final FirebaseFirestore firestore;

  const UsersList({Key? key, required this.firestore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('users').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading users from Firestore...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            elevation: 2,
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        final users = snapshot.data?.docs ?? [];

        if (users.isEmpty) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  Icon(Icons.inbox, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No users found'),
                ],
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
                    const Text(
                      'Total Users',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text('${users.length}'),
                      backgroundColor: Colors.green.shade100,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final userData = users[index].data() as Map<String, dynamic>;
                  final docId = users[index].id;
                  final timestamp = userData['timestamp'] as Timestamp?;
                  final formattedTime = timestamp != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
                      : 'N/A';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        (userData['name'] as String)[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(userData['name'] ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${userData['email']} • Age: ${userData['age']}'),
                        Text(
                          'Added: $formattedTime',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteUser(docId),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteUser(String docId) {
    firestore.collection('users').doc(docId).delete().then((_) {
      print('✅ User deleted from Firestore');
    }).catchError((error) {
      print('❌ Error deleting user: $error');
    });
  }
}