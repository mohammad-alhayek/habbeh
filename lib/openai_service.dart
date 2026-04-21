import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> sendMessageToGemini(String message) async {
  String geminiApiKey ="AIzaSyC3kpt8k9KUXpLazPmqJMKd8Zkw6Jz9Y_w";
  if (geminiApiKey.isEmpty) return "API Key not set";

  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey",
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
              "You are Reflection, a **medical assistant**. Answer health-related questions (symptoms, treatments, prevention, medicines). Be professional, clear, and safe. If needed, ask clarifying questions. Always remind the user to consult a real doctor for serious issues.\n\nUser: $message"
            }
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["candidates"][0]["content"]["parts"][0]["text"];
  } else {
    throw Exception('Failed to fetch response from Gemini: ${response.body}');
  }
}
