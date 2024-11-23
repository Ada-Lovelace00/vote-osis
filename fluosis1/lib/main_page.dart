import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OSIS SMKN 1 KOTA BENGKULU',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 230, 164, 164),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Home':
                  Navigator.pushNamed(context, '/');
                  break;
                case 'Login':
                  Navigator.pushNamed(context, '/login');
                  break;
                case 'Sign Up':
                  Navigator.pushNamed(context, '/signup');
                  break;
                case 'Dashboard pemilihan':
                  Navigator.pushNamed(context, '/loginpemilih');
                  break;
                case 'Hasil Voting':
                  Navigator.pushNamed(context, '/HasilVote');
                  break;
              }
            },
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Home',
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.blueAccent),
                    title: Text('Home'),
                  ),
                ),
                PopupMenuItem(
                  value: 'Login',
                  child: ListTile(
                    leading: Icon(Icons.login, color: Colors.blueAccent),
                    title: Text('Login admin'),
                  ),
                ),
                PopupMenuItem(
                  value: 'Sign Up',
                  child: ListTile(
                    leading: Icon(Icons.app_registration, color: Colors.blueAccent),
                    title: Text('Sign Up Pemilih'),
                  ),
                ),
                PopupMenuItem(
                  value: 'Dashboard pemilihan',
                  child: ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.blueAccent),
                    title: Text('Pemilihan Ketua OSIS'),
                  ),
                ),
                PopupMenuItem(
                  value: 'Hasil Voting',
                  child: ListTile(
                    leading: Icon(Icons.bar_chart, color: Colors.blueAccent),
                    title: Text('Hasil Voting'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/logoosis.png',
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'OSIS APP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 93, 173, 226),
                    shadowColor: Colors.blue.withOpacity(0.5),
                    elevation: 6,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginpemilih');
                  },
                  child: Text(
                    'Pemilihan Ketua OSIS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 93, 173, 226),
                    shadowColor: Colors.blue.withOpacity(0.5),
                    elevation: 6,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Registrasi Pemilih',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(height: 10),
                Text(
                  'By Annisa Zahra Salsabila',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
