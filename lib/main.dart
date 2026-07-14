
import 'package:flutter/material.dart';
import 'package:nan_nestfinder/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// NEW: Global theme notifier. No Provider needed
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NAN_NestFinder());
}

class NAN_NestFinder extends StatelessWidget {
  const NAN_NestFinder({super.key});

  @override
  Widget build(BuildContext context) {
    // NEW: Listen to themeNotifier for live theme change
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NAN_NestFinder',

          // NEW: Light theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFE3F2FD),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            brightness: Brightness.light,
          ),

          // NEW: Dark theme
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            brightness: Brightness.dark,
          ),

          themeMode: currentMode, // This changes when you toggle in Settings
          home: const SplashScreen(),
        );
      },
    );
  }
}
