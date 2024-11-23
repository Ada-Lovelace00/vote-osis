import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPemilihPage extends StatefulWidget {
  @override
  _DataPemilihPageState createState() => _DataPemilihPageState();
}

class _DataPemilihPageState extends State<DataPemilihPage> {
  List<dynamic> voters = [];
  TextEditingController _nisnController = TextEditingController();
  TextEditingController _namaPemilihController = TextEditingController();
  TextEditingController _kelasController = TextEditingController();
  TextEditingController _jurusanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVoters();
  }

  // Fetch all voters
  Future<void> _fetchVoters() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/flutter-login-signup/pemilih.php'));
      if (response.statusCode == 200) {
        setState(() {
          voters = json.decode(response.body)['data'] ?? [];
        });
      } else {
        throw Exception('Failed to load voters');
      }
    } catch (e) {
      print("Error fetching voters: $e");
    }
  }

  // Update voter details
  Future<void> _updateVoter(String nisn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/updatepemilih.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nisn': nisn,  // Make sure to send the nisn for updating
          'nama_pemilih': _namaPemilihController.text,
          'kelas': _kelasController.text,
          'jurusan': _jurusanController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Voter updated successfully') {
          _fetchVoters(); // Reload the voters list
          Navigator.of(context).pop(); // Close the dialog after updating
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Voter updated successfully")),
          );
        } else {
          throw Exception('Failed to update voter');
        }
      } else {
        throw Exception('Failed to update voter');
      }
    } catch (e) {
      print("Error updating voter: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating voter")),
      );
    }
  }

  // Delete a voter
  Future<void> _deleteVoter(String nisn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/deletepemilih.php'),
        body: {
          'nisn': nisn, // Send the nisn here
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Voter deleted successfully') {
          _fetchVoters(); // Reload the voters list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Voter deleted successfully")),
          );
        } else {
          throw Exception('Failed to delete voter');
        }
      } else {
        throw Exception('Failed to delete voter');
      }
    } catch (e) {
      print("Error deleting voter: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting voter")),
      );
    }
  }

  // UI for the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Pemilih')),
      body: ListView.builder(
        itemCount: voters.length,
        itemBuilder: (context, index) {
          final voter = voters[index];
          final String nisn = voter['nisn'];
          final String namaPemilih = voter['nama_pemilih'];
          final String kelas = voter['kelas'];
          final String jurusan = voter['jurusan'];

          return ListTile(
            title: Text("NISN: $nisn"),
            subtitle: Text("Nama: $namaPemilih, Kelas: $kelas, Jurusan: $jurusan"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Open an in-place edit dialog to update voter
                    _nisnController.text = nisn;
                    _namaPemilihController.text = namaPemilih;
                    _kelasController.text = kelas;
                    _jurusanController.text = jurusan;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Edit Voter'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nisnController,
                                decoration: InputDecoration(labelText: 'NISN'),
                                readOnly: true,
                              ),
                              TextField(
                                controller: _namaPemilihController,
                                decoration: InputDecoration(labelText: 'Nama Pemilih'),
                              ),
                              TextField(
                                controller: _kelasController,
                                decoration: InputDecoration(labelText: 'Kelas'),
                              ),
                              TextField(
                                controller: _jurusanController,
                                decoration: InputDecoration(labelText: 'Jurusan'),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateVoter(nisn); // Update the voter
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
                    // Confirm before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Voter'),
                          content: Text('Are you sure you want to delete this voter?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteVoter(nisn); // Pass nisn to the delete function
                                Navigator.of(context).pop(); // Close the dialog
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
          Navigator.pushNamed(context, '/tambahpemilih'); // Navigate to the add voter page
        },
      ),
    );
  }
}
