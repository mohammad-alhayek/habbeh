import 'package:flutter/material.dart';
import 'verify_connect.dart';
import 'home.dart';
import 'insights.dart';
import 'chatbot.dart';
import 'profailes.dart';



class ConnectPage extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const ConnectPage({super.key, this.profileData});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  int _selectedIndex = 3; // Profile مختارة افتراضياً

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InsightsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatbotPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilesPage()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.profileData ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF094270),
        elevation: 3,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 8),
            Text(
              "Connect Mirror",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Mirror Status",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D151B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search, color: Colors.black87),
            ),
            title: const Text(
              "Smart Mirror",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF0D151B)),
            ),
            subtitle: const Text(
              "Not Connected",
              style: TextStyle(color: Color(0xFF4C779A)),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "How to Connect",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D151B),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "1. Ensure your smart mirror is powered on and connected to the same Wi-Fi network as your phone.\n"
                  "2. Open the app settings on your smart mirror and select 'Connect Device'.\n"
                  "3. In this app, tap the 'Connect' button below to initiate the pairing process.\n"
                  "4. Follow any on-screen prompts to complete the connection.",
              style: TextStyle(color: Color(0xFF0D151B), height: 1.5),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF094270),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(160, 44),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VerifyConnectPage(),
                  ),
                );
              },
              child: const Text(
                "Connect",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF4C779A),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Insights"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "Chatbot"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
