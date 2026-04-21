import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // ===== AppBar مخصص =====
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 10, left: 16, right: 16),
            color: const Color(0xFFF1F5F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0D141C)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Reminders",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D141C),
                  ),
                ),
                const SizedBox(width: 48), // نفس المساحة اللي يأخذها زر الرجوع
              ],
            ),
          ),

          // ===== محتوى الصفحة =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ==== Medication Section ====
                const Text(
                  "Medication",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D141C),
                  ),
                ),
                const SizedBox(height: 8),
                ReminderCard(
                  icon: Icons.medical_services,
                  iconColor: Color(0xFF0D141C),
                  bgColor: const Color(0xFFE7EEF3),
                  title: "Vitamin D",
                  subtitle: "1 pill",
                  switchValue: true,
                ),
                ReminderCard(
                  icon: Icons.medical_services,
                  iconColor: Color(0xFF0D141C),
                  bgColor: const Color(0xFFE7EEF3),
                  title: "Calcium",
                  subtitle: "2 pills",
                  switchValue: false,
                ),

                const SizedBox(height: 16),

                // ==== Hydration Section ====
                const Text(
                  "Hydration",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D141C),
                  ),
                ),
                const SizedBox(height: 8),
                ReminderCard(
                  icon: Icons.local_drink,
                  iconColor: Color(0xFF0D141C),
                  bgColor: const Color(0xFFE7EEF3),
                  title: "Drink Water",
                  subtitle: "Every 2 hours",
                  switchValue: true,
                ),

                const SizedBox(height: 16),

                // ==== Exercise Section ====
                const Text(
                  "Exercise",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D141C),
                  ),
                ),
                const SizedBox(height: 8),
                ReminderCard(
                  icon: Icons.self_improvement,
                  iconColor: Color(0xFF0D141C),
                  bgColor: const Color(0xFFE7EEF3),
                  title: "Morning Yoga",
                  subtitle: "Every morning",
                  switchValue: false,
                ),
                ReminderCard(
                  icon: Icons.directions_walk,
                  iconColor: Color(0xFF0D141C),
                  bgColor: const Color(0xFFE7EEF3),
                  title: "Evening Walk",
                  subtitle: "Every evening",
                  switchValue: true,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFE7EEF3),
        child: const Icon(Icons.add, color: Color(0xFF0D141C)),
      ),
    );
  }
}

// ===== Widget للـ Reminder Card =====
class ReminderCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool switchValue;

  const ReminderCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.switchValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0D141C))),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF4C779A))),
                ],
              ),
            ),
            Switch(value: switchValue, onChanged: (val) {}),
          ],
        ),
      ),
    );
  }
}
