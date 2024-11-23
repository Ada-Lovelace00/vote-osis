import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON encoding/decoding

class LoginpemilihPage extends StatefulWidget {
  const LoginpemilihPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginpemilihPage> {
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  
  bool _isLoading = false; // Loading indicator flag

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Jika ada argumen, isi NISN dan token
    if (args != null) {
      nisnController.text = args['nisn'] ?? '';
      tokenController.text = args['token_pemilih'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Pemilihan Osis',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nisnController,
                      decoration: const InputDecoration(
                        labelText: 'NISN',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Token',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator() // Tampilkan indikator loading
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color.fromARGB(255, 93, 173, 226),
                              shadowColor: Colors.blue.withOpacity(0.5),
                              elevation: 6,
                            ),
                            onPressed: () {
                              _login(context);
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup'); // Navigasi ke halaman signup
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    String nisn = nisnController.text.trim();
    String token = tokenController.text.trim();

    // Cek apakah input tidak kosong
    if (nisn.isEmpty || token.isEmpty) {
      _showErrorDialog(context, 'Masukkan NISN dan token.');
      return;
    }

    setState(() {
      _isLoading = true; // Set loading menjadi true
    });

    var url = Uri.parse('http://localhost/flutter-login-signup/loginpemilih.php'); // URL API Anda
    try {
      var response = await http.post(url, body: {
        "nisn": nisn,
        "token_pemilih": token,
      });

      // Cek respon dari server
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          // Navigasi ke dashboard jika login berhasil
          Navigator.pushReplacementNamed(context, '/dashboardpemilih');
        } else {
          _showErrorDialog(context, responseBody['message'] ?? 'NISN dan token tidak valid.');
        }
      } else {
        _showErrorDialog(context, 'Gagal terhubung ke server. Silakan coba lagi nanti.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false; // Set loading menjadi false terlepas dari berhasil atau gagal
      });
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
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}
