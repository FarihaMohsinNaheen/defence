import 'package:flutter/material.dart';
import 'package:nan_nestfinder/owner_setting_page.dart';

class OwnerPrivacyPolicyPage extends StatelessWidget {
  const OwnerPrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF003366);
    const Color bgColor = Color(0xFFEAF4FF);
    final String today =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OwnerSettingPage()),
          ),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
                        "Last updated: $today",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Sections as Cards - Owner specific
          _buildPolicyCard(
            icon: Icons.folder_outlined,
            title: "Information We Collect",
            content:
                "We collect your name, email, phone, NID, and hostel details when you create an owner account. We also collect listing data, booking records, and app usage data.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.shield_outlined,
            title: "How We Use Your Data",
            content:
                "• Verify your hostel listings\n• Connect you with students\n• Process bookings & payouts\n• Provide analytics & improve owner tools",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.share_outlined,
            title: "Data Sharing",
            content:
                "We never sell your data. We only share your hostel contact info with students when they request a booking or start a chat. Financial details are never shared.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.lock_outline,
            title: "Data Security",
            content:
                "Your data is stored securely using Firebase. NID and payout info are encrypted. We use industry-standard security practices to protect owner accounts.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.person_outline,
            title: "Your Rights & Responsibilities",
            content:
                "You must provide accurate hostel info. You can update, pause, or delete listings anytime. You can view, update, or delete your personal info from Settings > Edit Profile.",
            color: primaryBlue,
          ),
          _buildPolicyCard(
            icon: Icons.mail_outline,
            title: "Contact Us",
            content:
                "Have questions? Email us at ownersupport@nannestfinder.com and we’ll get back to you.",
            color: primaryBlue,
          ),
          const SizedBox(height: 20),

          // 3. Footer
          Center(
            child: Text(
              "Made with ❤️ in Sylhet",
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Reusable card for each policy section - same as student
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
