import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'owner_dashboard_page.dart';
import 'admin_panel.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<String?> getRole(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return doc.data()?['role'];
    } catch (e) {
      debugPrint("Role Fetch Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    /// NOT LOGGED IN
    if (user == null) {
      return const LoginPage(role: "student");
    }

    /// LOGGED IN → CHECK ROLE
    return FutureBuilder<String?>(
      future: getRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;

        if (role == "student") {
          return const HomePage();
        }

        if (role == "owner") {
          return const OwnerDashboardPage();
        }

        if (role == "admin") {
          return const AdminPanelPage();
        }

        return const Scaffold(body: Center(child: Text("Role not found")));
      },
    );
  }
}
