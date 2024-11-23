import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  
import 'dart:convert';  

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  
  String? selectedKelas;
  String? selectedJurusan;

  bool _isLoading = false; // Indicator for loading state

  final List<String> kelasOptions = ['10', '11', '12'];
  final List<String> jurusanOptions = ['PPLG','DKV','TJKT','ULP','PM','MPLB','AKUNTANSI'];

  Future<void> _signUp() async {
    String nisn = nisnController.text.trim();
    String name = nameController.text.trim();
    String kelas = selectedKelas ?? '';
    String jurusan = selectedJurusan ?? '';

    if (nisn.isEmpty || name.isEmpty || kelas.isEmpty || jurusan.isEmpty) {
      _showErrorDialog("All fields are required!");
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('http://localhost/flutter-login-signup/register.php'); 
      var response = await http.post(url, body: {
        "nisn": nisn,
        "nama_pemilih": name,
        "kelas": kelas,
        "jurusan": jurusan,
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody["status"] == "success") {
          // Extract token from NISN by removing leading zeros
          String token = _extractToken(nisn);

          _showSuccessDialog(
            "Registrasi sukses!:\n\n"
            "NISN: $nisn\n"
            "Name: $name\n"
            "Kelas: $kelas\n"
            "Jurusan: $jurusan\n"
            "Token: $token\n"
            "Screenshoot pesan ini!",
            () {
              Navigator.pushReplacementNamed(context, '/');
            },
          );
        } else {
          _showErrorDialog(responseBody["message"]);
        }
      } else {
        _showErrorDialog("Failed to connect to the server. Please try again later.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _extractToken(String nisn) {
    // Remove leading zeros and return the remaining string
    return nisn.replaceFirst(RegExp(r'^00'), '');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message, Function onOkPressed) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(ctx).pop(); 
              onOkPressed(); 
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrasi Pemilihan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 320,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              elevation: 8,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Registrasi pemilihan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nisnController,
                      decoration: InputDecoration(
                        labelText: 'Nisn',
                        prefixIcon: Icon(Icons.assignment, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedKelas,
                      hint: Text('Select Kelas'),
                      items: kelasOptions.map((String kelas) {
                        return DropdownMenuItem<String>(
                          value: kelas,
                          child: Text(kelas),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedKelas = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.class_, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedJurusan,
                      hint: Text('Select Jurusan'),
                      items: jurusanOptions.map((String jurusan) {
                        return DropdownMenuItem<String>(
                          value: jurusan,
                          child: Text(jurusan),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedJurusan = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: const Color.fromARGB(255, 93, 173, 226),
                        shadowColor: Colors.blue.withOpacity(0.5),
                        elevation: 6,
                      ),
                      onPressed: _isLoading ? null : _signUp, // Disable button if loading
                      child: _isLoading 
                          ? CircularProgressIndicator() // Show loading indicator
                          : Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginpemilih');
                      },
                      child: Text(
                        'Sudah punya akun? Login',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 16),
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
}
