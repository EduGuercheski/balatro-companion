import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({super.key});

  @override
  State<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  final List<String> roles = ['standard', 'vip', 'admin'];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'role': newRole});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F7768),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final users = snapshot.data!.docs.where(
                (user) => user.id != currentUserId,
          );

          if (users.isEmpty) {
            return const Center(
              child: Text("Nenhum outro usuário encontrado.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: users.map((user) {
              final userId = user.id;
              final userEmail = user['email'] ?? 'sem email';
              final currentRole = user['role'] ?? 'standard';

              return Card(
                color: Colors.white10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: DropdownButton<String>(
                    dropdownColor: const Color(0xFF4F7768),
                    value: currentRole,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      if (value != null) {
                        updateUserRole(userId, value);
                      }
                    },
                    items: roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
