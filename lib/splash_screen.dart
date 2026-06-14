// import 'package:flutter/material.dart';
// import 'onboarding_screen.dart';

// class NanColors {
//   static const Color navyDark = Color(0xFF003366);
//   static const Color whiteSoft = Color(0xFFE8EAF0);
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fade;

//   @override
//   void initState() {
//     super.initState();

//     // Fade animation
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

//     _controller.forward();

//     // Navigate after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: NanColors.navyDark,
//       body: FadeTransition(
//         opacity: _fade,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.home_work, color: Colors.white, size: 140), // was 85

//               SizedBox(height: 30), // was 20

//               Text(
//                 "NAN Nestfinder",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 38, // was 28
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),

//               SizedBox(height: 12), // was 8

//               Text(
//                 "Smart Hostel & Mess Finder",
//                 style: TextStyle(
//                   color: NanColors.whiteSoft,
//                   fontSize: 18, // was 14
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(height: 80), // was 60

//               CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 3.5,
//               ), // was 2.5

//               SizedBox(height: 16), // was 12

//               Text(
//                 "Loading...",
//                 style: TextStyle(color: NanColors.whiteSoft, fontSize: 13),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'onboarding_screen.dart';

// class NanColors {
//   static const Color navyDark = Color(0xFF003366);
//   static const Color whiteSoft = Color(0xFFE8EAF0);
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fade;

//   @override
//   void initState() {
//     super.initState();

//     // Fade animation - SAME LOGIC
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

//     _controller.forward();

//     // Navigate after 3 seconds - SAME LOGIC
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: NanColors.navyDark,
//       body: FadeTransition(
//         opacity: _fade,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 // Bigger icon + glow effect
//                 Icon(Icons.home_work, color: Colors.white, size: 140),

//                 SizedBox(height: 32),

//                 // App name - bigger + letter spacing
//                 Text(
//                   "NAN NestFinder",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 38,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),

//                 SizedBox(height: 12),

//                 // Tagline - bigger + better weight
//                 Text(
//                   "Smart Hostel & Mess Finder",
//                   style: TextStyle(
//                     color: NanColors.whiteSoft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 0.3,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(height: 80),

//                 // Loader - slightly thicker
//                 CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 3.5,
//                 ),

//                 SizedBox(height: 16),

//                 // Loading text - bigger
//                 Text(
//                   "Loading...",
//                   style: TextStyle(
//                     color: NanColors.whiteSoft,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class NanColors {
  static const Color navyDark = Color(0xFF003366);
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

    // Fade animation - SAME LOGIC
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Navigate after 3 seconds - SAME LOGIC
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F3F), Color(0xFF00509D), Color(0xFF034078)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glassmorphism logo badge - makes it look premium
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_work,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App name - bigger + shadow
                  const Text(
                    "NAN NestFinder",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    "Smart Hostel Finder",
                    // Where Comfort Meets Convenience",
                    style: TextStyle(
                      color: NanColors.whiteSoft,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    "Where Comfort Meets Convenience",
                    style: TextStyle(
                      color: NanColors.whiteSoft,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // No spinner/loading text - cleaner splash
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
