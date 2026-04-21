import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'addprofile_page.dart';
import 'connect_page.dart';
import 'globals.dart' as globals;

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF094270),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profiles",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout from your account?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes")),
                  ],
                ),
              );
              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('profiles')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final profiles = snapshot.data?.docs ?? [];

            List<Widget> profileCards = profiles.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  globals.currentProfileId = doc.id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConnectPage()),
                  );
                },
                child: ProfileCard(
                  docId: doc.id,
                  imageUrl: data['imageUrl'] ?? '',
                  name: data['fullName'] ?? '',
                  uid: uid,
                  onDelete: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete Profile"),
                        content: const Text("Are you sure you want to delete this profile? This action cannot be undone."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes")),
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('profiles')
                          .doc(doc.id)
                          .delete();
                    }
                  },
                ),
              );
            }).toList();

            // زر إضافة بروفايل
            if (profiles.length < 5) {
              profileCards.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddProfilePage(),
                      ),
                    );
                  },
                  child: const ProfileCard(
                    imageUrl: 'https://icon-library.com/images/add-icon-png/add-icon-png-28.jpg',
                    name: 'Add Profile',
                  ),
                ),
              );
            }

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: profileCards,
            );
          },
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback? onDelete;
  final String? docId;
  final String? uid;

  const ProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.onDelete,
    this.docId,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final defaultImage = "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          if (onDelete != null)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              imageUrl.isNotEmpty ? imageUrl : defaultImage,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  defaultImage,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name.isNotEmpty ? name : "Unknown",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D151B),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
