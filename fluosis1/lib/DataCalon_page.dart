import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataCalonPage extends StatefulWidget {
  @override
  _DataCalonPageState createState() => _DataCalonPageState();
}

class _DataCalonPageState extends State<DataCalonPage> {
  List<dynamic> candidates = [];
  TextEditingController _namaKetosController = TextEditingController();
  TextEditingController _namaWaketosController = TextEditingController();
  TextEditingController _fotoPaslonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  // Fetch all candidates
  Future<void> _fetchCandidates() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/flutter-login-signup/calon.php'));
      if (response.statusCode == 200) {
        setState(() {
          candidates = json.decode(response.body)['data'] ?? [];
        });
      } else {
        throw Exception('Failed to load candidates');
      }
    } catch (e) {
      print("Error fetching candidates: $e");
    }
  }

  // Update candidate details
  Future<void> _updateCandidate(String noPaslon) async {
    try {
      String? updatedFotoPaslon = _fotoPaslonController.text.isNotEmpty
          ? _fotoPaslonController.text
          : null;

      if (_namaKetosController.text.isEmpty || _namaWaketosController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Nama Ketua and Nama Wakil Ketua cannot be empty")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/updatecalon.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'no_paslon': noPaslon,
          'nama_ketos': _namaKetosController.text,
          'nama_waketos': _namaWaketosController.text,
          'foto_paslon': updatedFotoPaslon,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Candidate updated successfully') {
          _fetchCandidates();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Candidate updated successfully")),
          );
        } else {
          throw Exception('Failed to update candidate');
        }
      } else {
        throw Exception('Failed to update candidate');
      }
    } catch (e) {
      print("Error updating candidate: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating candidate")),
      );
    }
  }

  // Delete a candidate
  Future<void> _deleteCandidate(String noPaslon) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/deletecalon.php'),
        body: {
          'no_paslon': noPaslon,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Candidate deleted successfully') {
          _fetchCandidates();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Candidate deleted successfully")),
          );
        } else {
          throw Exception('Failed to delete candidate');
        }
      } else {
        throw Exception('Failed to delete candidate');
      }
    } catch (e) {
      print("Error deleting candidate: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting candidate")),
      );
    }
  }

  // UI for the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Calon')),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];
          final String noPaslon = candidate['no_paslon'];
          final String namaKetos = candidate['nama_ketos'];
          final String namaWaketos = candidate['nama_waketos'];
          final String fotoPaslonBase64 = candidate['foto_paslon'];

          Uint8List? imageBytes;
          if (fotoPaslonBase64.isNotEmpty) {
            imageBytes = base64Decode(fotoPaslonBase64);
          }

          return ListTile(
            leading: imageBytes != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(imageBytes),
                    radius: 30,
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 30,
                  ),
            title: Text("No Paslon: $noPaslon"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ketua: $namaKetos"),
                Text("Wakil: $namaWaketos"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _namaKetosController.text = namaKetos;
                    _namaWaketosController.text = namaWaketos;
                    _fotoPaslonController.text = fotoPaslonBase64;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Edit Candidate'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _namaKetosController,
                                decoration: InputDecoration(labelText: 'Nama Ketua'),
                              ),
                              TextField(
                                controller: _namaWaketosController,
                                decoration: InputDecoration(labelText: 'Nama Wakil Ketua'),
                              ),
                              TextField(
                                controller: _fotoPaslonController,
                                decoration: InputDecoration(labelText: 'Foto Paslon (Base64 String)'),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateCandidate(noPaslon);
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Candidate'),
                          content: Text('Are you sure you want to delete this candidate?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteCandidate(noPaslon);
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/tambahcalon');
        },
      ),
    );
  }
}