import 'package:flutter/material.dart';
import 'home.dart'; // تأكد أنك استوردت صفحة HomePage

class VerifyConnectPage extends StatelessWidget {
  const VerifyConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // bg-slate-50
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // زر X يرجع للـ HomePage مباشرة
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF0D141C)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                              (route) => false,
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "Verify your identity",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D141C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // عشان يوازن مكان الأيقونة
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Use Face ID with Smart Mirror",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D141C),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Position yourself in front of the smart mirror to verify your identity.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0D141C),
                    ),
                  ),
                ),
              ],
            ),

            // صورة Face Scan
            Expanded(
              child: Center(
                child: Container(
                  width: 250,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBCueEmDjOUphtCE6_LaxHLO-naLh3JShQ9f-V8ERez2AbWRWUui8ItLcbOrIEpW8lycUj2ra9MwFmhudvXGkaRUZLW6zgsFR9yLEb1bsso30pgY_wpxaSqYd9XLSuWN0Z07QrLQZIPn3qazLNiRs9YqZuTWFfRcIIuzQ2CFZvhg-6hu1F4AjDbjibNa5oLwLYeBjP8ZOXJG7pZK4gU8lXAcobLTheE5-Yq3a_G8DQrIMRjXUlBwCUTfGsaPIg8FrtVhjAGGkHfoaA",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
