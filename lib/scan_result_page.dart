import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  final Map<String, dynamic> scanData;

  const ScanResultPage({super.key, required this.scanData});

  @override
  Widget build(BuildContext context) {
    final results = (scanData["results"] as List<dynamic>).cast<Map<String, dynamic>>();
    final geminiResult = scanData["GeminiResult"] ?? ""; // النص المختصر/الملاحظات من Gemini

    IconData getIcon(String condition) {
      final cond = condition.toLowerCase();
      if (cond.contains("anemia")) return Icons.bloodtype;
      if (cond.contains("stomach")) return Icons.sick;
      if (cond.contains("fatigue") || cond.contains("exhaustion")) return Icons.bedtime;
      if (cond.contains("healthy") || cond.contains("normal")) return Icons.check_circle;
      if (cond.contains("pale")) return Icons.face;
      return Icons.medical_services;
    }

    Color getColor(String condition) {
      final cond = condition.toLowerCase();
      if (cond.contains("anemia")) return Colors.red.shade300;
      if (cond.contains("stomach")) return Colors.orange.shade300;
      if (cond.contains("fatigue") || cond.contains("exhaustion")) return Colors.blue.shade300;
      if (cond.contains("healthy") || cond.contains("normal")) return Colors.green.shade300;
      if (cond.contains("pale")) return Colors.grey.shade400;
      return Colors.teal.shade200;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Results")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // عرض النتائج الرئيسية لكل كارد
          ...results.map((res) {
            final condition = res['Expected Condition'] ?? '';
            final symptom = res['Symptom'] ?? '';
            final recommendation = res['Recommendation'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: getColor(condition),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(getIcon(condition), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(symptom, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(condition, style: const TextStyle(fontSize: 14)),
                        if (recommendation.isNotEmpty)
                          Text("Recommendation: $recommendation", style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 24),
          // Reflection Chat Advices
          if (geminiResult.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Reflection Chat – Advices",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 8),
                  Text(
                    geminiResult,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // يمكنك إضافة Reflection Chat – Analyses بنفس الطريقة إذا أردت فصل التحليلات عن النصائح
        ],
      ),
    );
  }
}
