import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPemilihPage extends StatefulWidget {
  @override
  _DashboardPemilihPageState createState() => _DashboardPemilihPageState();
}

class _DashboardPemilihPageState extends State<DashboardPemilihPage> {
  String? _kandidatTerpilih;
  List<dynamic> candidates = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/flutter-login-signup/calon.php'));

      if (response.body.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Received empty response from server';
        });
        return;
      }

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data.containsKey('data') && data['data'] is List) {
            setState(() {
              candidates = data['data'];
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'Unexpected data format from server';
            });
          }
        } catch (jsonError) {
          setState(() {
            isLoading = false;
            errorMessage = 'Error decoding JSON: $jsonError';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load candidates. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _tambahSuara(String noPaslon) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter-login-signup/tambahsuara.php'),
        body: {'no_paslon': noPaslon},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Vote added successfully') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Suara Anda telah dikirim!')),
          );
        } else {
          throw Exception('Failed to add vote');
        }
      } else {
        throw Exception('Failed to add vote');
      }
    } catch (e) {
      print("Error adding vote: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _pilihKandidat(String nomorKandidat) {
    setState(() {
      _kandidatTerpilih = nomorKandidat;
    });
  }

  void _konfirmasiSuara() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Anda telah memilih kandidat No. $_kandidatTerpilih. Apakah Anda yakin?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_kandidatTerpilih != null) {
                  _tambahSuara(_kandidatTerpilih!);
                }
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pemilih'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];
                    final String fotoPaslon = candidate['foto_paslon'] ?? '';
                    final Uint8List? imageBytes = fotoPaslon.isNotEmpty
                        ? base64Decode(fotoPaslon.split(',').last)
                        : null;

                    return CandidateCard(
                      candidateNumber: candidate['no_paslon'] ?? 'N/A',
                      candidateImage: imageBytes,
                      isSelected: _kandidatTerpilih == candidate['no_paslon'],
                      onTap: () {
                        _pilihKandidat(candidate['no_paslon']);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _kandidatTerpilih == null
                  ? null
                  : () {
                      _konfirmasiSuara();
                    },
              child: const Text('Kirim Suara'),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateCard extends StatelessWidget {
  final String candidateNumber;
  final Uint8List? candidateImage;
  final bool isSelected;
  final VoidCallback onTap;

  const CandidateCard({
    required this.candidateNumber,
    required this.candidateImage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: isSelected ? Colors.lightBlueAccent : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            candidateImage != null
                ? Image.memory(
                    candidateImage!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
            const SizedBox(height: 10),
            Text(
              'No. $candidateNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
