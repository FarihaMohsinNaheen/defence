import 'package:flutter/material.dart';
import 'package:nan_nestfinder/setting_page.dart';

class StudentAboutUsPage extends StatelessWidget {
  const StudentAboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF003366);
    const Color bgColor = Color(0xFFEAF4FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentSettingsPage()),
            );
          },
        ),
        title: const Text(
          "About Us", // 1. White title, same line
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // 1. App Logo + Name
            CircleAvatar(
              radius: 45,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(
                Icons.home_work_rounded,
                size: 55,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "NAN_NestFinder",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Find your perfect hostel, stress-free",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            // 2. About Text - BLUE BOX WITH WHITE TEXT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryBlue, // 2. Blue cardbox
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "NAN_NestFinder is built for students, by students. We make hostel hunting simple, safe, and transparent. No brokers, no fake listings. Just verified rooms near your campus.",
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: Colors.white, // 2. White text
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Key Features - SMALL/WIDE BOXES
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Key Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildFeatureTile(
              icon: Icons.search,
              title: "Smart Search",
              desc: "Filter hostels by price, location, facilities & seat type",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.chat_bubble_outline,
              title: "Direct Chat",
              desc: "Talk directly with hostel owners. No middleman.",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.book_online_outlined,
              title: "Easy Booking",
              desc: "Check seat availability & request booking in 2 taps",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.verified_outlined,
              title: "Verified Listings",
              desc: "All hostels are verified by our team for safety",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              desc: "Eye-friendly dark theme for night browsing",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.notifications_active_outlined,
              title: "Live Notifications",
              desc: "Get instant updates on booking & messages",
              color: primaryBlue,
            ),
            const SizedBox(height: 24),

            // 4. Version - GREY
            Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),

            // Made with ❤️ in Sylhet - RED ONLY
            Text(
              "Made with ❤️ in Sylhet",
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(desc, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}
