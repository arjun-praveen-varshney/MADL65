import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ARFinancialChatbotApp());
}

class ARFinancialChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Financial Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLanguage = 'English';
  final List<String> supportedLanguages = [
    'English',
    'हिंदी (Hindi)',
    'বাংলা (Bengali)', 
    'தமிழ் (Tamil)',
    'తెలుగు (Telugu)',
    'ಕನ್ನಡ (Kannada)',
    'മലയാളം (Malayalam)',
    'ગુજરાતી (Gujarati)',
    'ਪੰਜਾਬੀ (Punjabi)',
    'मराठी (Marathi)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Financial Assistant'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 60,
                        color: Colors.indigo,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'AR Financial Chatbot',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Your AI-powered financial assistant in Indian languages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Language Selection
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Language / भाषा चुनें',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.language, color: Colors.indigo),
                        ),
                        items: supportedLanguages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Feature Cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.camera_alt,
                        title: 'AR Chat',
                        subtitle: 'Start AR conversation',
                        color: Colors.green,
                        onTap: () => _navigateToARChat(),
                      ),
                      _buildFeatureCard(
                        icon: Icons.account_balance,
                        title: 'Banking Help',
                        subtitle: 'Account queries',
                        color: Colors.blue,
                        onTap: () => _navigateToFinancialHelp('banking'),
                      ),
                      _buildFeatureCard(
                        icon: Icons.trending_up,
                        title: 'Investment',
                        subtitle: 'Investment guidance',
                        color: Colors.purple,
                        onTap: () => _navigateToFinancialHelp('investment'),
                      ),
                      _buildFeatureCard(
                        icon: Icons.calculate,
                        title: 'Loan Calculator',
                        subtitle: 'EMI calculations',
                        color: Colors.orange,
                        onTap: () => _navigateToLoanCalculator(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToARChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARChatScreen(language: selectedLanguage),
      ),
    );
  }

  void _navigateToFinancialHelp(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinancialHelpScreen(
          category: category,
          language: selectedLanguage,
        ),
      ),
    );
  }

  void _navigateToLoanCalculator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoanCalculatorScreen(language: selectedLanguage),
      ),
    );
  }
}

class ARChatScreen extends StatefulWidget {
  final String language;

  ARChatScreen({required this.language});

  @override
  _ARChatScreenState createState() => _ARChatScreenState();
}

class _ARChatScreenState extends State<ARChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isARActive = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    Map<String, String> welcomeMessages = {
      'English': 'Hello! I\'m your AR financial assistant. How can I help you today?',
      'हिंदी (Hindi)': 'नमस्ते! मैं आपका AR वित्तीय सहायक हूं। आज मैं आपकी कैसे मदद कर सकता हूं?',
      'বাংলা (Bengali)': 'হ্যালো! আমি আপনার AR আর্থিক সহায়ক। আজ আমি কীভাবে আপনাকে সাহায্য করতে পারি?',
      'தமிழ் (Tamil)': 'வணக்கம்! நான் உங்கள் AR நிதி உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்?',
    };

    String welcome = welcomeMessages[widget.language] ?? welcomeMessages['English']!;
    
    setState(() {
      _messages.add(ChatMessage(
        text: welcome,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Financial Chat'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isARActive ? Icons.camera_alt : Icons.camera_alt_outlined),
            onPressed: _toggleAR,
          ),
        ],
      ),
      body: Column(
        children: [
          // AR Status Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            color: _isARActive ? Colors.green.shade100 : Colors.grey.shade100,
            child: Text(
              _isARActive ? 'AR Mode: Active 📷' : 'AR Mode: Inactive',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isARActive ? Colors.green.shade800 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask your financial question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.indigo : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String userMessage = _messageController.text.trim();
    
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    
    // Simulate AI response
    Future.delayed(Duration(seconds: 1), () {
      _generateResponse(userMessage);
    });
  }

  void _generateResponse(String userMessage) {
    String response = _getFinancialResponse(userMessage, widget.language);
    
    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  String _getFinancialResponse(String message, String language) {
    // Simple keyword-based responses for demo
    String lowerMessage = message.toLowerCase();
    
    Map<String, Map<String, String>> responses = {
      'English': {
        'loan': 'For loans, check your credit score, compare interest rates, and ensure you have steady income. EMI should not exceed 40% of your income.',
        'investment': 'Start with SIP in mutual funds, consider PPF for tax benefits, and diversify your portfolio. Always invest based on your risk tolerance.',
        'savings': 'Maintain an emergency fund of 6 months expenses. Use high-interest savings accounts and consider FDs for secure returns.',
        'default': 'I can help with loans, investments, savings, banking, insurance, and tax queries. What specific financial topic interests you?'
      },
      'हिंदी (Hindi)': {
        'loan': 'लोन के लिए अपना क्रेडिट स्कोर जांचें, ब्याज दरों की तुलना करें। EMI आपकी आय के 40% से अधिक नहीं होनी चाहिए।',
        'investment': 'म्यूचुअल फंड में SIP शुरू करें, टैक्स बेनिफिट के लिए PPF पर विचार करें। जोखिम के अनुसार निवेश करें।',
        'savings': '6 महीने के खर्च का इमरजेंसी फंड रखें। हाई इंटरेस्ट सेविंग अकाउंट का उपयोग करें।',
        'default': 'मैं लोन, निवेश, बचत, बैंकिंग, बीमा और टैक्स के बारे में मदद कर सकता हूं। कौन सा विषय चाहिए?'
      }
    };

    Map<String, String> langResponses = responses[language] ?? responses['English']!;
    
    if (lowerMessage.contains('loan') || lowerMessage.contains('लोन')) {
      return langResponses['loan']!;
    } else if (lowerMessage.contains('invest') || lowerMessage.contains('निवेश')) {
      return langResponses['investment']!;
    } else if (lowerMessage.contains('saving') || lowerMessage.contains('बचत')) {
      return langResponses['savings']!;
    } else {
      return langResponses['default']!;
    }
  }

  void _toggleAR() {
    setState(() {
      _isARActive = !_isARActive;
    });
    
    HapticFeedback.mediumImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isARActive ? 'AR Mode Activated' : 'AR Mode Deactivated'),
        backgroundColor: _isARActive ? Colors.green : Colors.grey,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class FinancialHelpScreen extends StatelessWidget {
  final String category;
  final String language;

  FinancialHelpScreen({required this.category, required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.toUpperCase()} Help'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Help - $category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _getHelpContent(category, language),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getHelpContent(String category, String language) {
    if (category == 'banking') {
      return [
        _buildHelpCard(
          'Account Opening',
          'Learn how to open different types of bank accounts and required documents.',
          Icons.account_balance,
          Colors.blue,
        ),
        _buildHelpCard(
          'ATM Services',
          'Understand ATM operations, charges, and safety tips.',
          Icons.atm,
          Colors.green,
        ),
        _buildHelpCard(
          'Online Banking',
          'Setup and use mobile banking safely and efficiently.',
          Icons.phone_android,
          Colors.purple,
        ),
      ];
    } else if (category == 'investment') {
      return [
        _buildHelpCard(
          'Mutual Funds',
          'Learn about SIP, NAV, and different types of mutual funds.',
          Icons.trending_up,
          Colors.green,
        ),
        _buildHelpCard(
          'Stock Market',
          'Basic concepts of share trading and market analysis.',
          Icons.show_chart,
          Colors.red,
        ),
        _buildHelpCard(
          'Fixed Deposits',
          'Compare FD rates and understand tax implications.',
          Icons.savings,
          Colors.orange,
        ),
      ];
    }
    return [];
  }

  Widget _buildHelpCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  final String language;

  LoanCalculatorScreen({required this.language});

  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  
  double _emi = 0.0;
  double _totalAmount = 0.0;
  double _totalInterest = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'EMI Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
            ),
            SizedBox(height: 30),
            
            _buildInputField(
              controller: _loanAmountController,
              label: 'Loan Amount (₹)',
              hint: 'Enter loan amount',
            ),
            SizedBox(height: 15),
            
            _buildInputField(
              controller: _interestRateController,
              label: 'Interest Rate (% per annum)',
              hint: 'Enter interest rate',
            ),
            SizedBox(height: 15),
            
            _buildInputField(
              controller: _tenureController,
              label: 'Tenure (Years)',
              hint: 'Enter loan tenure',
            ),
            SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: _calculateEMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Calculate EMI',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            
            SizedBox(height: 30),
            
            if (_emi > 0) ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  children: [
                    _buildResultRow('Monthly EMI', '₹${_emi.toStringAsFixed(2)}'),
                    _buildResultRow('Total Amount', '₹${_totalAmount.toStringAsFixed(2)}'),
                    _buildResultRow('Total Interest', '₹${_totalInterest.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.indigo.shade800,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateEMI() {
    if (_loanAmountController.text.isEmpty ||
        _interestRateController.text.isEmpty ||
        _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    double principal = double.parse(_loanAmountController.text);
    double annualRate = double.parse(_interestRateController.text);
    int tenureYears = int.parse(_tenureController.text);

    double monthlyRate = annualRate / (12 * 100);
    int tenureMonths = tenureYears * 12;

    double emi = (principal * monthlyRate * 
        (1 + monthlyRate) * tenureMonths) / 
        ((1 + monthlyRate) * tenureMonths - 1);

    double totalAmount = emi * tenureMonths;
    double totalInterest = totalAmount - principal;

    setState(() {
      _emi = emi;
      _totalAmount = totalAmount;
      _totalInterest = totalInterest;
    });
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}