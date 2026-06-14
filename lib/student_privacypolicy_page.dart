import 'package:flutter/material.dart';

class StudentPrivacypolicyPage extends StatelessWidget {
  const StudentPrivacypolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF003366);
    const Color bgColor = Color(0xFFEAF4FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.privacy_tip, size: 40, color: primaryBlue),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Privacy Matters",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Sections as Cards
          _buildPolicyCard(
            icon: Icons.folder_outlined,
            title: "Information We Collect",
            content:
                "We collect your name, email, phone, and profile photo when you create an account. We also collect app usage data to improve your experience.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.shield_outlined,
            title: "How We Use Your Data",
            content:
                "• Create & manage your account\n• Connect you with hostels\n• Send booking/chat notifications\n• Improve app features & security",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.share_outlined,
            title: "Data Sharing",
            content:
                "We never sell your data. We only share your name, phone, and email with a hostel owner when you request a booking or start a chat.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.lock_outline,
            title: "Data Security",
            content:
                "Your data is stored securely using Firebase. Passwords are encrypted and we use industry-standard security practices.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.person_outline,
            title: "Your Rights",
            content:
                "You can view, update, or delete your personal information anytime from the Settings > Edit Profile page.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.mail_outline,
            title: "Contact Us",
            content:
                "Have questions? Email us at adminannestfinder@gmail.com and we’ll get back to you.",
            color: primaryBlue,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Reusable card for each policy section
  Widget _buildPolicyCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
