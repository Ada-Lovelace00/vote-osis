import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HasilVotingPage extends StatefulWidget {
  @override
  _HasilVotingPageState createState() => _HasilVotingPageState();
}

class _HasilVotingPageState extends State<HasilVotingPage> {
  List<dynamic> votingResults = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchVotingResults();
  }

  Future<void> _fetchVotingResults() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/flutter-login-signup/hasilsuara.php'));
      if (response.statusCode == 200) {
        setState(() {
          votingResults = json.decode(response.body)['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load voting results. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching voting results: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Voting'),
        leading: Icon(Icons.poll),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : votingResults.isEmpty
                  ? Center(child: Text("Tidak ada data hasil voting."))
                  : ListView.builder(
                      itemCount: votingResults.length,
                      itemBuilder: (context, index) {
                        final result = votingResults[index];
                        final String noPaslon = result['no_paslon'].toString();
                        final String namaKetos = result['nama_ketos'];
                        final String namaWaketos = result['nama_waketos'];
                        final int jumlahSuara = result['votes'];

                        return ListTile(
                          leading: Icon(Icons.how_to_vote),
                          title: Text("Paslon $noPaslon - Ketua: $namaKetos"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Wakil: $namaWaketos"),
                              Text("Jumlah Suara: $jumlahSuara"),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
