import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenServiceAnalysis {
  /// ترسل قائمة الأعراض وتحصل على تحليل Gemini كنص مقال منسق وجاهز للحفظ أو العرض
  static Future<String> analyzeSymptoms(List<String> symptoms) async {
    final message = symptoms.join(", ");

    String geminiApiKey = "AIzaSyC3kpt8k9KUXpLazPmqJMKd8Zkw6Jz9Y_w";
    if (geminiApiKey.isEmpty) return "API Key not set";

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": """
You are Reflection, a professional medical assistant.

Given the user's symptoms: $message

Write a clear, concise, and structured analysis as a short article.

Format requirements:
- Use headings for each section (Introduction, Likely Conditions, Recommendations, Important Notes, Key Takeaways).
- Present information in well-organized paragraphs and numbered or bulleted points.
- Do not use any asterisks, markdown symbols, or special formatting characters.
- The text should be fully human-readable, professional, and suitable for displaying directly in an app or storing in Firebase.

Sections to include:
1. Introduction: Brief overview of the symptoms.
2. Likely Conditions: Detailed description of possible conditions.
3. Recommendations: Practical tips, lifestyle suggestions, and precautions.
4. Important Notes: Warnings and when to seek medical attention.
5. Key Takeaways: Summary in bullet points or numbered list.
"""
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data["candidates"][0]["content"]["parts"][0]["text"];
      return text.trim(); // جاهز للحفظ أو العرض
    } else {
      throw Exception('Failed to fetch response from Gemini: ${response.body}');
    }
  }
}
