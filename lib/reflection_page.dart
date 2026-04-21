import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart';
import 'insights.dart';
import 'package:app1/OpenServiceAnalysis.dart'; // تأكد من استيراد OpenServiceAnalysis

import 'globals.dart' as globals;

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  final List<String> allSymptoms = ["Dizziness", "Nausea", "Fatigue", "Paleness", "Headache"];
  List<String> selectedSymptoms = [];

  bool _loading = false;
  List<Map<String, dynamic>> _results = [];

  static const String abiBaseUrl = "https://mohammad5555.pythonanywhere.com";

  Future<void> _pickImage(ImageSource source) async {
    final img = await _picker.pickImage(source: source, imageQuality: 90);
    if (img != null) setState(() => _pickedImage = img);
  }

  Future<List<Map<String, dynamic>>> _sendToABI() async {
    var uri = Uri.parse("$abiBaseUrl/analyze");
    var request = http.MultipartRequest('POST', uri);

    if (selectedSymptoms.isNotEmpty) {
      request.fields['symptoms'] = jsonEncode(selectedSymptoms);
    }

    if (_pickedImage != null) {
      final bytes = await _pickedImage!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: _pickedImage!.name),
      );
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(respStr) as List;
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Failed to fetch ABI result");
    }
  }

  Future<DocumentReference> _saveToFirebaseCurrentProfile(List<Map<String, dynamic>> results) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final userId = user.uid;

    final profileId = globals.currentProfileId;
    if (profileId == null) throw Exception("No profile selected");

    final now = Timestamp.now();
    final data = {
      "scanDate": now,
      "analysisDate": now,
      "symptoms": selectedSymptoms,
      "results": results,
    };

    final docRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("profiles")
        .doc(profileId)
        .collection("scans")
        .add(data);

    return docRef;
  }

  Future<void> _analyzeCurrentProfile() async {
    if (selectedSymptoms.isEmpty && _pickedImage == null) return;

    setState(() {
      _loading = true;
      _results = [];
    });

    try {
      // 1️⃣ إرسال للـ ABI
      final abiResults = await _sendToABI();
      setState(() => _results = abiResults);

      // 2️⃣ حفظ النتائج في Firebase
      final docRef = await _saveToFirebaseCurrentProfile(abiResults);

      // 3️⃣ إرسال نتائج ABI لـ Gemini
      final abiResultsText = abiResults.map((e) => e['Symptom'] ?? '').join(", ");
      final geminiResult = await OpenServiceAnalysis.analyzeSymptoms([abiResultsText]);

      // 4️⃣ تحديث نفس المستند مع حقل GeminiResult
      await docRef.update({"GeminiResult": geminiResult});

    } catch (e) {
      setState(() => _results = [
        {
          "Symptom": "Error",
          "Expected Condition": "",
          "Recommendation": e.toString(),
          "Source": ""
        }
      ]);
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _symptomChips() {
    return Wrap(
      spacing: 8,
      children: allSymptoms.map((s) {
        final selected = selectedSymptoms.contains(s);
        return ChoiceChip(
          label: Text(s),
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              if (value) selectedSymptoms.add(s);
              else selectedSymptoms.remove(s);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _previewImage() {
    if (_pickedImage == null) return const SizedBox.shrink();
    return FutureBuilder<Uint8List>(
      future: _pickedImage!.readAsBytes(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox(height: 160);
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Image.memory(snap.data!, height: 220, fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _resultView() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_results.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        ..._results.map((res) {
          String emoji = "";
          Color cardColor = Colors.teal.shade50;
          String cond = res['Expected Condition'] ?? "";

          if (cond.toLowerCase().contains("anemia")) {
            emoji = "🩸";
            cardColor = Colors.red.shade100;
          } else if (cond.toLowerCase().contains("stomach")) {
            emoji = "🤢";
            cardColor = Colors.orange.shade100;
          } else if (cond.toLowerCase().contains("fatigue") || cond.toLowerCase().contains("exhaustion")) {
            emoji = "😴";
            cardColor = Colors.blue.shade100;
          } else if (cond.toLowerCase().contains("healthy") || cond.toLowerCase().contains("normal")) {
            emoji = "✅";
            cardColor = Colors.green.shade100;
          } else if (cond.toLowerCase().contains("pale")) {
            emoji = "😶‍🌫️";
            cardColor = Colors.yellow.shade100;
          } else {
            emoji = "🩺";
            cardColor = Colors.grey.shade200;
          }

          String conditionText = cond.isNotEmpty && cond.toLowerCase() != "unknown"
              ? " $cond"
              : "No specific condition detected";

          return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$emoji ${res['Symptom'] ?? ''}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(conditionText, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(res['Recommendation'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InsightsPage()),
            );
          },
          icon: const Icon(Icons.bar_chart),
          label: const Text("Show the insights"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(title: const Text('Reflection Scanner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Select your symptoms:"),
          const SizedBox(height: 8),
          _symptomChips(),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text('Pick from gallery'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera),
                label: const Text('Take a photo'),
              ),
            ],
          ),
          _previewImage(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _analyzeCurrentProfile,
            icon: const Icon(Icons.analytics),
            label: const Text('Analyze'),
          ),
          const SizedBox(height: 16),
          _resultView(),
        ],
      ),
    );
  }
}
