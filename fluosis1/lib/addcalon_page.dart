import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddCalonPage extends StatefulWidget {
  @override
  _AddCalonPageState createState() => _AddCalonPageState();
}

class _AddCalonPageState extends State<AddCalonPage> {
  final TextEditingController noPaslonController = TextEditingController();
  final TextEditingController ketosController = TextEditingController();
  final TextEditingController waketosController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // Method to pick image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // Add candidate function
  Future<void> _addCandidate() async {
    final String noPaslon = noPaslonController.text.trim();
    final String ketos = ketosController.text.trim();
    final String waketos = waketosController.text.trim();

    // Validate fields
    if (noPaslon.isEmpty || ketos.isEmpty || waketos.isEmpty || _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields and select an image.")));
      return;
    }

    final String fotoBase64 = base64Encode(_imageBytes!);

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/addcalon.php'),
        body: {
          'no_paslon': noPaslon,
          'nama_ketos': ketos,
          'nama_waketos': waketos,
          'foto_paslon': fotoBase64, // Send the base64 encoded image here
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['status'] == 'success' ? "Candidate added successfully" : "Error: ${responseBody['message']}")),
        );

        // Navigate to DataCalonPage after adding candidate
        Navigator.pushReplacementNamed(context, '/datacalon');
      } else {
        throw Exception("Failed to add candidate.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding candidate: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Calon',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  children: [
                    Text(
                      'Tambah Calon',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: noPaslonController,
                      decoration: InputDecoration(
                        labelText: 'No Paslon',
                        prefixIcon: Icon(Icons.assignment, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: ketosController,
                      decoration: InputDecoration(
                        labelText: 'Nama Ketua',
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: waketosController,
                      decoration: InputDecoration(
                        labelText: 'Nama Wakil',
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(height: 10),
                    _imageBytes != null
                        ? Image.memory(_imageBytes!, height: 100, width: 100)
                        : Text("No image selected", style: TextStyle(color: Colors.grey)),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text("Select Image"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addCandidate,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text("Add Calon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueAccent)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        shadowColor: Colors.blue.withOpacity(0.5),
                        elevation: 6,
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
