import 'package:flutter/material.dart';

class DashboardadminPage extends StatelessWidget {
  const DashboardadminPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 93, 173, 226),
              ),
              child: Center(
                child: Image(
                  image: AssetImage('images/logo.png'),
                  height: 100,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Data Calon'),
              onTap: () {
                Navigator.pushNamed(context, '/datacalon');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Data Pemilih'),
              onTap: () {
                Navigator.pushNamed(context, '/datapemilih');
              },
            ),
             ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context,'/profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: <Widget>[
            DashboardItem(
              icon: Icons.bar_chart,
              label: 'Hasil Voting',
              onTap: () {
                Navigator.pushNamed(context, '/HasilVote');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout function to navigate back to the login page
  Future<void> _logout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class DashboardItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _updatePressedState(true), // When the button is pressed
      onTapUp: (_) => _updatePressedState(false),  // When the button is released
      onTapCancel: () => _updatePressedState(false), // When the tap is canceled
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0, // Scale animation effect
        duration: const Duration(milliseconds: 100),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(widget.icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update the pressed state to handle the visual feedback
  void _updatePressedState(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }
}
