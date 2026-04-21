// InsightsPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
import 'scan_result_page.dart';
import 'home.dart';
import 'profailes.dart';
import 'chatbot.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatbotPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilesPage()));
        break;
    }
  }

  Future<void> _deleteScan(String scanId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final profileId = globals.currentProfileId;
    if (profileId == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("profiles")
        .doc(profileId)
        .collection("scans")
        .doc(scanId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final profileId = globals.currentProfileId;

    if (profileId == null) {
      return const Scaffold(
        body: Center(child: Text("No profile selected")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("profiles")
              .doc(profileId)
              .collection("scans")
              .orderBy("scanDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final scans = snapshot.data?.docs ?? [];

            if (scans.isEmpty) {
              return const Center(child: Text("No scans available"));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        "Insights",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D141C)),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),

                ...scans.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final scanDate = (data["scanDate"] as Timestamp).toDate();
                  final dayOfWeek = DateFormat('EEEE').format(scanDate);
                  final formattedDate = DateFormat('dd/MM/yyyy').format(scanDate);
                  final scanId = doc.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            // يذهب إلى صفحة عرض النتائج
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ScanResultPage(scanData: data),
                                ));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFCEDBE8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$dayOfWeek, $formattedDate",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0D141C)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Symptoms: ${(data["symptoms"] as List<dynamic>).cast<String>().join(", ")}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF0D141C)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // زر الحذف X
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              _deleteScan(scanId);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0D141C),
        unselectedItemColor: const Color(0xFF49739C),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Insights"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "Chatbot"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
