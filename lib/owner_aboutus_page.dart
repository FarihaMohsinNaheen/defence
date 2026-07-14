import 'package:flutter/material.dart';
import 'package:nan_nestfinder/owner_setting_page.dart'; 

class OwnerAboutUsPage extends StatelessWidget {
  const OwnerAboutUsPage({super.key});

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
              MaterialPageRoute(builder: (_) => const OwnerSettingPage()),
            );
          },
        ),
        title: const Text(
          "About Us",
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
              "List your hostel, find students easily", 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

          
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "NAN_NestFinder helps hostel owners manage listings, connect with students, and fill seats faster. No agent fees, no fake requests. Just verified students looking for rooms near your hostel.",
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

           
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
              icon: Icons.list_alt_outlined,
              title: "Easy Listing",
              desc: "Add, edit, and manage your hostel details in minutes",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.chat_bubble_outline,
              title: "Direct Chat",
              desc: "Talk directly with students. No middleman commission.",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.book_online_outlined,
              title: "Booking Management",
              desc: "Accept, reject, or track booking requests in one place",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.verified_outlined,
              title: "Verified Students",
              desc: "Connect only with verified students for trust & safety",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              desc: "Eye-friendly dark theme for night management",
              color: primaryBlue,
            ),
            _buildFeatureTile(
              icon: Icons.notifications_active_outlined,
              title: "Live Notifications",
              desc: "Get instant alerts for new bookings & messages",
              color: primaryBlue,
            ),
            const SizedBox(height: 24),

            Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),

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
