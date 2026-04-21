import 'package:flutter/material.dart';
import 'connect_page.dart';
import 'insights.dart';
import 'chatbot.dart';
import 'profailes.dart';
import 'reflection_page.dart';
import 'package:app1/RemindersPage.dart'; // ✅ استدعاء صفحة Reminders

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break; // Home, نفس الصفحة
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InsightsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatbotPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilesPage()),
        );
        break;
    }
  }

  Widget buildCard(String title, String subtitle, String imageUrl,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(color: Color(0xFF0D141C)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF0D141C)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الكبسة الأولى: Use Mirror
          buildCard(
            "Use Mirror",
            "Access your personalized health insights through your smart mirror.",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAt9RT2ZZWvur4XHhP8Fa1YK7bAmRhlZgiUNFd4_Ux9BfyJk_oIV3H_MbfrFan84J8KCUzQvYauDMDZTcvfktYLwdn4EMmTgJcVPgtDgyfA0lx3uahqgKJTLPsMQBCt2NLCRBdwmiYJIzkLB9rGNqQeDNPQ3KEO4-IqlRdlA_kWT1siiZa7LE1hV6tEst26ZZJDnTZoL_1KRht9fbADZXdRKX5gjcQ5325Sk4fVxW5SWAViIHIbTTEeEHHpl5AQ5GhYFsnbbyXuV5Q",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReflectionPage()),
              );
            },
          ),
          const SizedBox(height: 16),

          // كبسة Reminders
          buildCard(
            "Reminders",
            "Set up daily reminders for your wellness routines.",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuBbrn1QWfRH4rOrvozaPUKD7X5_JNXBkfQ7eJbylDJEGjFmCfNFwngTCkL35C1vdsFjmPJFj3svHk3LtYAEJRvFz9fop8ns4vitdwNUhXlFw3OunjTteeHT1gyYAyJyzVqIpfTq1ADbjwA4zf-8np53yunkan6wtVFO0gYrWbOhS38IZn_XBQrRMCvN5TzFAsjo18D7Qsbnd-uCaeQpQomPoQHLoVkMPB2ctjBlfkUSAz-jjGkPbMrsL_Gx6iPt3haQhWbK2j7-I3E",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RemindersPage()), // ✅ تروح على صفحة Reminders
              );
            },
          ),
          const SizedBox(height: 24),

          const Text(
            "Suggested Articles",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D141C),
            ),
          ),
          const SizedBox(height: 12),

          buildCard(
            "Mindful Eating: A Guide to Savoring Every Bite",
            "Learn how to eat more mindfully and enjoy your meals.",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDUf5994ymNhIzOcTFTfJs21QQdq5pGa7SW7ydRrGG24Yk3sRP5Do4VcsxkfAfhEs6DOAvyu6nQS-h67MxluSfccUe-Mt6xHvKIsf_N7MojQBU35FWeDZOSH-IuVYx85PJRHYAjlWBVCI_EIcYi2zsaGs2Th11_CleMXL2T5dXFHobyrA3hqKKDY0dibRMBBvfWgKHlWvWyxqSsipQLA-8nLZ_rM3LYv590ZjJhN02pcOO2nKntM2_x2fcrB9dd6IFcOnFSxhP55VI",
          ),
          const SizedBox(height: 16),

          buildCard(
            "The Science of Sleep: Optimizing Your Rest",
            "Discover the secrets to a good night's sleep and its impact on your health.",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAnmMBAsZjwOMYOw6R79L_MMgBnTSu2OO7MqaxnQTK5cdTGIsiASGp14JLMHnDh1BJawjwyjrG5vlXH1yh89-XwKH9VSVIeCHzmD736-ldCGNly5jeAXztSGAGPPLtWgj_jhRZRxr3YiBf-ODK4O2Oil4mSLFqD0d5lmdOHgo9cDfqsYSaCbFygJbel3E-AMZAZq64z9J4H5KrVHH53TvbfnX-VYRkFVgAh5OPmvYeW6YRlh7eDjLIXrsEq1tIeU1EkQPQmPrZcxm0",
          ),
          const SizedBox(height: 16),

          buildCard(
            "Stress Management Techniques for a Balanced Life",
            "Effective strategies to manage stress and improve your well-being.",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuD-nfBW52WpAYxwSI-LkLv4zUnjVMkY_RG3gxnHJGHoh1lJwZpmD8A1_2zd-JUqf3dJowIkqEdC8miqZpTitdGF6QkHVLnvhDaOR5LvR00PJaUbB_eCnUof9IVFC-NfhoZR8owC1y3f_xvyARyFMlSKn8Qt3OwmZxkGtHjiH0kSnuTZDJBn71JAd4aigC3VqFkdFkkNR1iwUv1ZW14qBv6Hi0rDvzGuDjsHnS-1FwfF9kXr36QPBbdTIWBEmLowAkRPx7yuoEubx78",
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
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
