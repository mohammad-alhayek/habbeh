import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  String gender = '';
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final occupationController = TextEditingController();
  final chronicDiseasesController = TextEditingController();
  final medicationsController = TextEditingController();
  String physicalActivity = '';
  String dietaryHabits = '';
  final allergiesController = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser!.uid;

  File? _imageFile;
  String? _imageUrl;
  bool _uploading = false;

  // صورة افتراضية
  final String defaultImage =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  // Pick image



  // Upload image to Firebase Storage
  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    setState(() => _uploading = true);

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);

      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;
        print('Upload is $progress% complete.');
      });

      await uploadTask;
      final url = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = url;
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')));
    } catch (e) {
      setState(() => _uploading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  void saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'fullName': fullNameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': gender,
        'height': double.tryParse(heightController.text) ?? 0,
        'weight': double.tryParse(weightController.text) ?? 0,
        'occupation': occupationController.text,
        'chronicDiseases': chronicDiseasesController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'medications': medicationsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'physicalActivity': physicalActivity,
        'dietaryHabits': dietaryHabits,
        'allergies': allergiesController.text,
        'imageUrl': _imageUrl ?? defaultImage, // صورة مرفوعة أو افتراضية
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('profiles')
          .add(profileData);

      if (mounted) Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF094270),
        elevation: 3,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.person_add_alt_1, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Add Profile",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              const SizedBox(height: 8),
              if (_imageFile != null && _imageUrl == null)
                ElevatedButton.icon(
                  onPressed: uploadImage,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Image'),
                ),
              const SizedBox(height: 16),

              // Full Name
              TextFormField(
                controller: fullNameController,
                decoration: _inputDecoration('Full Name', Icons.person),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Age
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Age', Icons.cake),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Gender
              DropdownButtonFormField<String>(
                value: gender.isEmpty ? null : gender,
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                decoration: _inputDecoration('Gender', Icons.wc),
                onChanged: (value) => setState(() => gender = value!),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Height & Weight
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Height (cm)', Icons.height),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration:
                      _inputDecoration('Weight (kg)', Icons.monitor_weight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Occupation
              TextFormField(
                controller: occupationController,
                decoration: _inputDecoration('Occupation', Icons.work),
              ),
              const SizedBox(height: 12),

              // Chronic Diseases
              TextFormField(
                controller: chronicDiseasesController,
                decoration: _inputDecoration(
                    'Chronic Diseases (comma separated)',
                    Icons.local_hospital),
              ),
              const SizedBox(height: 12),

              // Medications
              TextFormField(
                controller: medicationsController,
                decoration: _inputDecoration(
                    'Medications (comma separated)', Icons.medication),
              ),
              const SizedBox(height: 12),

              // Physical Activity
              DropdownButtonFormField<String>(
                value: physicalActivity.isEmpty ? null : physicalActivity,
                items: ['Low', 'Medium', 'High']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                decoration:
                _inputDecoration('Physical Activity Level', Icons.fitness_center),
                onChanged: (value) => setState(() => physicalActivity = value!),
              ),
              const SizedBox(height: 12),

              // Dietary Habits
              DropdownButtonFormField<String>(
                value: dietaryHabits.isEmpty ? null : dietaryHabits,
                items: ['Balanced', 'Vegetarian', 'Vegan', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                decoration:
                _inputDecoration('Dietary Habits', Icons.restaurant),
                onChanged: (value) => setState(() => dietaryHabits = value!),
              ),
              const SizedBox(height: 12),

              // Allergies
              TextFormField(
                controller: allergiesController,
                maxLines: 3,
                decoration: _inputDecoration('Allergies', Icons.warning),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Save Profile',
                    style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
