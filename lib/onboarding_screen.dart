import 'package:flutter/material.dart';
import 'roleselection_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Color primaryBlue = const Color(0xFF003366);

  int currentIndex = 0;
  bool _isRunning = true;
  bool _userInteracted = false;

  final List<Map<String, dynamic>> slides = [
    {
      "icon": Icons.home_work,
      "title": "Find Safe Hostels & Mess",
      "desc": "Discover affordable and verified places near you",
    },
    {
      "icon": Icons.verified_user_outlined,
      "title": "100% Verified Listings",
      "desc": "TrustScore ensures safety and reduces fake listings",
    },
    {
      "icon": Icons.star_outline,
      "title": "Real Reviews & Ratings",
      "desc": "See honest reviews and student experiences",
    },
    {
      "icon": Icons.payments_outlined,
      "title": "Easy Online Booking",
      "desc": "Book your seat instantly and pay securely online",
    },
  ];

  @override
  void initState() {
    super.initState();
    startAutoFlow();
  }

  Future<void> startAutoFlow() async {
    while (_isRunning && mounted) {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (_userInteracted) {
        break;
      }

      if (currentIndex < slides.length - 1) {
        setState(() {
          currentIndex++;
        });

        await Future.delayed(const Duration(milliseconds: 900));
      } else {
        break;
      }
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 115),

            const Text(
              "NAN Nest-Finder",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20), // adjust here
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 900),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeOut,

                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },

                    child: _buildSlide(currentIndex),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
                bool isActive = index == currentIndex;

                return GestureDetector(
                  onTap: () {
                    _userInteracted = true;

                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(int index) {
    final item = slides[index];

    return Container(
      key: ValueKey(index),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60), // ✅ FIXED POSITION

          Icon(item["icon"], color: Colors.white, size: 128),

          const SizedBox(height: 24),

          Text(
            item["title"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            item["desc"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 36),

          if (index == slides.length - 1)
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: goToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
