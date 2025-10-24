import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Main entry point of the Expense Tracker app
void main() {
  runApp(const MyApp());
}

// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.teal),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.tealAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          filled: true,
          fillColor: Color(0xFFE0F7FA),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: Colors.teal),
          hintStyle: TextStyle(color: Colors.tealAccent),
        ),
        // Use CardThemeData for ThemeData.cardTheme (Flutter 3.22+)
        cardTheme: const CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          shadowColor: Color.fromRGBO(0, 150, 136, 0.3), // Teal with opacity
        ),
      ),
      home:
          const HomeScreen(), // Removed 'const' to fix non-constant expression error
    );
  }
}

// Home Screen to input income and navigate to Expense Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _incomeController = TextEditingController();
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Color(0xFF00695C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: _buildHomeBody(context)),
      ),
    );
  }

  // Builds the main content of the Home Screen
  Widget _buildHomeBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInAnimation(
            child: Text(
              'Welcome, Hammad!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          FadeInAnimation(child: _buildIncomeInput()),
          const SizedBox(height: 24),
          FadeInAnimation(child: _buildNavigateButton(context)),
        ],
      ),
    );
  }

  // Income input field with validation
  Widget _buildIncomeInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _incomeController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Monthly Income (PKR)',
            prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
            hintText: 'e.g., 50000',
            errorText:
                _incomeController.text.isNotEmpty &&
                    double.tryParse(_incomeController.text) == null
                ? 'Invalid amount'
                : null,
          ),
        ),
      ),
    );
  }

  // Button to navigate to Expense Screen with animation
  Widget _buildNavigateButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) => setState(() => _isButtonPressed = false),
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton(
          onPressed: () {
            final double? income = double.tryParse(_incomeController.text);
            if (income != null && income > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddExpenseScreen(name: 'Hammad', income: income),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid income'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              );
            }
          },
          child: const Text('Add Expenses'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }
}

// Expense Screen to input and calculate expenses
class AddExpenseScreen extends StatefulWidget {
  final String name;
  final double income;

  const AddExpenseScreen({super.key, required this.name, required this.income});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final List<String> _categories = [
    'Grocery',
    'Electricity & Gas Bill',
    'Internet',
    'Education',
    'Entertainment',
    'Savings',
    'Travel',
  ];
  late Map<String, TextEditingController> _controllers;
  String? _message;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var category in _categories) category: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Calculate total expenses and display result
  void _calculateExpenses() {
    double totalExpenses = 0.0;
    bool hasInvalidInput = false;
    for (var controller in _controllers.values) {
      final input = controller.text.trim();
      if (input.isNotEmpty) {
        final double? amount = double.tryParse(input);
        if (amount != null && amount >= 0) {
          totalExpenses += amount;
        } else {
          hasInvalidInput = true;
        }
      }
    }
    if (hasInvalidInput) {
      setState(() {
        _message = 'Please enter valid numbers for expenses.';
      });
      return;
    }
    final double remaining = widget.income - totalExpenses;
    setState(() {
      _message = remaining >= 0
          ? 'You saved PKR ${remaining.toStringAsFixed(0)} this month!'
          : 'You overspent by PKR ${remaining.abs().toStringAsFixed(0)} this month.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4DB6AC), Color(0xFF00695C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: _buildExpenseBody(context)),
      ),
    );
  }

  // Main content of the Expense Screen
  Widget _buildExpenseBody(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(child: _buildIncomeDisplay(context)),
                const SizedBox(height: 24),
                FadeInAnimation(child: _buildCategoryList()),
                const SizedBox(height: 24),
                FadeInAnimation(child: _buildSubmitButton()),
                const SizedBox(height: 24),
                FadeInAnimation(child: _buildResultMessage()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Custom AppBar with user name
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF004D40),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Expenses for ${widget.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Display non-editable income
  Widget _buildIncomeDisplay(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.account_balance, color: Colors.teal, size: 28),
            const SizedBox(width: 16),
            Text(
              'Monthly Income: PKR ${widget.income.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  // List of category inputs with animations
  Widget _buildCategoryList() {
    return Column(
      children: _categories.asMap().entries.map((entry) {
        return FadeInAnimation(
          delay: Duration(milliseconds: 100 * entry.key),
          child: _buildCategoryItem(entry.value),
        );
      }).toList(),
    );
  }

  // Individual category input field
  Widget _buildCategoryItem(String category) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                category,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: _controllers[category],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  prefixIcon: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.teal,
                  ),
                  errorText:
                      _controllers[category]!.text.isNotEmpty &&
                          double.tryParse(_controllers[category]!.text) == null
                      ? 'Invalid amount'
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Submit button with animation
  Widget _buildSubmitButton() {
    bool isPressed = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedScale(
            scale: isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: ElevatedButton(
              onPressed: _calculateExpenses,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF00796B),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 20),
                  SizedBox(width: 8),
                  Text('Submit'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Display result message with animation
  Widget _buildResultMessage() {
    if (_message == null) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _message!.contains('saved')
            ? Colors.green[100]
            : Colors.red[100],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _message!.contains('saved') ? Icons.savings : Icons.warning,
            color: _message!.contains('saved')
                ? Colors.green[800]
                : Colors.red[800],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _message!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _message!.contains('saved')
                    ? Colors.green[800]
                    : Colors.red[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for fade-in animation
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(widget.delay, () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
