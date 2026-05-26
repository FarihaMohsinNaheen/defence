import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerHelpsupportPage extends StatefulWidget {
  const OwnerHelpsupportPage({super.key});

  @override
  State<OwnerHelpsupportPage> createState() => _OwnerHelpSupportPageState();
}

class _OwnerHelpSupportPageState extends State<OwnerHelpsupportPage> {
  bool faq1 = false;
  bool faq2 = false;
  bool faq3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Help & Support",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          // ================= HEADER CARD =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How can we help you?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Find answers or contact support for any issue.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= CONTACT OPTIONS =================
          sectionTitle("Contact Us"),

          contactTile(Icons.email, "Email Support", "support@nanapp.com"),
          contactTile(Icons.phone, "Call Us", "+880 1XXX-XXXXXX"),
          contactTile(Icons.chat, "Live Chat", "Available 9AM - 9PM"),

          const SizedBox(height: 20),

          // ================= FAQ =================
          sectionTitle("Frequently Asked Questions"),

          faqTile(
            "How do I add a hostel?",
            faq1,
            () {
              setState(() {
                faq1 = !faq1;
              });
            },
            "Go to Add Hostel page and fill all required details then submit.",
          ),

          faqTile(
            "Why my listing is pending?",
            faq2,
            () {
              setState(() {
                faq2 = !faq2;
              });
            },
            "Your listing is under review by admin. It will be approved soon.",
          ),

          faqTile(
            "How to edit my hostel?",
            faq3,
            () {
              setState(() {
                faq3 = !faq3;
              });
            },
            "Go to Hostel List page and click edit button on your listing.",
          ),

          const SizedBox(height: 20),

          // ================= SUPPORT BOX =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Still need help?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryBlue,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Our support team will respond within 24 hours.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  // ================= CONTACT TILE =================
  Widget contactTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryBlue),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  // ================= FAQ TILE (STATEFUL EXPAND) =================
  Widget faqTile(
    String question,
    bool expanded,
    VoidCallback onTap,
    String answer,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: primaryBlue,
            ),
            onTap: onTap,
          ),

          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                answer,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
