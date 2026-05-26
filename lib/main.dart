import 'package:flutter/material.dart';
// import 'package:nan_nestfinder/home_page.dart';
// import 'package:nan_nestfinder/owner_dashboard_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'roleselection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://chgxphrfxnhvcifdiyxq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoZ3hwaHJmeG5odmNpZmRpeXhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3Mjk4NzcsImV4cCI6MjA5NTMwNTg3N30.qiy_cPG9I0K-gq63gbPzCDopgy3pZqFVL-g_Qhv_1Jk',
  );
  runApp(const NAN_NestFinder());
}

class NAN_NestFinder extends StatelessWidget {
  const NAN_NestFinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NAN_NestFinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
      ),
      home: const RoleSelectionPage(),
    );
  }
}
