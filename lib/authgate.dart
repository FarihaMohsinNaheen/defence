// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'login_page.dart';
// import 'home_page.dart';
// import 'owner_dashboard_page.dart';

// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   final supabase = Supabase.instance.client;

//   Future<String?> getRole(String userId) async {
//     final data = await supabase
//         .from('users')
//         .select('role')
//         .eq('id', userId)
//         .single();

//     return data['role'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final session = supabase.auth.currentSession;

//     // ❌ NOT LOGGED IN
//     if (session == null) {
//       return const LoginPage(role: "Student");
//     }

//     // ⏳ LOGGED IN BUT WAITING ROLE
//     return FutureBuilder<String?>(
//       future: getRole(session.user.id),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final role = snapshot.data;

//         // ✅ ROLE CHECK
//         if (role == "Student") {
//           return const HomePage();
//         } else {
//           return const OwnerDashboardPage();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'owner_dashboard_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final supabase = Supabase.instance.client;

  /// GET USER ROLE FROM SUPABASE
  Future<String?> getRole(String userId) async {
    try {
      final data = await supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      return data['role'];
    } catch (e) {
      debugPrint("Role Fetch Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    /// USER NOT LOGGED IN
    if (session == null) {
      return const LoginPage(role: "Student");
    }

    /// USER LOGGED IN
    return FutureBuilder<String?>(
      future: getRole(session.user.id),

      builder: (context, snapshot) {
        /// LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ERROR
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }

        final role = snapshot.data;

        /// STUDENT
        if (role == "Student") {
          return const HomePage();
        }

        /// OWNER
        if (role == "Owner") {
          return const OwnerDashboardPage();
        }

        /// ROLE NOT FOUND
        return const Scaffold(body: Center(child: Text("Role not found")));
      },
    );
  }
}
