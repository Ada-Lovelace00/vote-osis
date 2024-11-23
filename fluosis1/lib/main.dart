import 'package:flutter/material.dart';

import 'main_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'dashboardpemilih.dart';
import 'dashboardadmin.dart';
import 'loginpemilih_page.dart';
import 'HasilVote_page.dart';
import 'DataCalon_page.dart';
import 'DataPemilih_page.dart';
import 'addcalon_page.dart';
import 'profile_page.dart';
import 'tambahpemilih_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSIS',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/tambahpemilih': (context) => TambahPemilihPage(),
        '/admin': (context) => DashboardadminPage(),
        '/dashboardpemilih': (context) => DashboardPemilihPage(),
        '/loginpemilih': (context) => LoginpemilihPage(),
        '/datapemilih': (context) => DataPemilihPage(),
        '/datacalon': (context) => DataCalonPage(),
        '/tambahcalon': (context) => AddCalonPage(),
        '/profil': (context) => ProfilePage(),
        '/HasilVote': (context) => HasilVotingPage(),
      },
    );
  }
}
