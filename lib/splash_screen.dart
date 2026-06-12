import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class NanColors {
  static const Color navyDark = Color(0xFF0D1B3E);
  static const Color whiteSoft = Color(0xFFE8EAF0);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NanColors.navyDark,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.home_work, color: Colors.white, size: 85),

              SizedBox(height: 20),

              Text(
                "NAN Nestfinder",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Smart Hostel & Mess Finder",
                style: TextStyle(color: NanColors.whiteSoft, fontSize: 14),
              ),

              SizedBox(height: 60),

              CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),

              SizedBox(height: 12),

              Text(
                "Loading...",
                style: TextStyle(color: NanColors.whiteSoft, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
