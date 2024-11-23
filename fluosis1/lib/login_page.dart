import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      emailController.text = args['email'] ?? '';
      passwordController.text = args['pass'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Admin',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 320,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 8,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(emailController, 'Email', Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField(passwordController, 'Password', Icons.lock, obscureText: true),
                    const SizedBox(height: 20),
                    _isLoading ? const CircularProgressIndicator() : _buildLoginButton(context),
                    const SizedBox(height: 10),
                    _buildSignupButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: const Color.fromARGB(255, 93, 173, 226),
        shadowColor: Colors.blue.withOpacity(0.5),
        elevation: 6,
      ),
      onPressed: () => _login(context),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _buildSignupButton() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, '/signup'),
      child: const Text(
        'Belum punya akun? Daftar',
        style: TextStyle(color: Colors.blueAccent, fontSize: 16),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showErrorDialog(context, 'Masukkan email dan password.');
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost/flutter-login-signup/login.php');
    try {
      final response = await http.post(url, body: {"email": email, "pass": pass});
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        Navigator.pushReplacementNamed(
          context,
          '/admin',
          arguments: {'email': email, 'pass': pass},
        );
      } else {
        _showErrorDialog(context, responseBody['message'] ?? 'Email dan password tidak valid.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}
