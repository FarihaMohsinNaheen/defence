import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerHelpSupportPage extends StatefulWidget {
  const OwnerHelpSupportPage({super.key});

  @override
  State<OwnerHelpSupportPage> createState() => _OwnerHelpSupportPageState();
}

class _OwnerHelpSupportPageState extends State<OwnerHelpSupportPage> {
  bool faq1 = false;
  bool faq2 = false;
  bool faq3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      //  APP BAR 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      // BODY
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CONTACT OPTIONS 
          sectionTitle("Contact Us"),
          contactTile(
            Icons.email,
            "Email Support",
            "adminnannestfinder@gmail.com",
          ),
          contactTile(Icons.phone, "Call Us", "+8801712786543"),

          const SizedBox(height: 20),

          // FAQ 
          sectionTitle("Frequently Asked Questions"),
          faqTile(
            "How do I add a hostel?",
            faq1,
            () => setState(() => faq1 = !faq1),
            "Go to Add Hostel page and fill all required details then submit.",
          ),
          faqTile(
            "Why my listing is pending?",
            faq2,
            () => setState(() => faq2 = !faq2),
            "Your listing is under review by admin. It will be approved soon.",
          ),
          faqTile(
            "How to edit my hostel?",
            faq3,
            () => setState(() => faq3 = !faq3),
            "Go to Hostel List page and click edit button on your listing.",
          ),

          const SizedBox(height: 20),

          // ACCOUNT 
          sectionTitle("Account"),
          deleteAccountTile(),
        ],
      ),
    );
  }

  // SECTION TITLE 
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

  //CONTACT TILE 
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

  //  FAQ TILE
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

  // DELETE ACCOUNT TITLE 
  Widget deleteAccountTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: ListTile(
        leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
        title: Text(
          "Delete My Account",
          style: TextStyle(color: Colors.red.shade700),
        ),
        subtitle: const Text("This action cannot be undone"),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showDeleteAccountDialog(),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Account?"),
        content: const Text(
          "All your hostel data, bookings, and profile will be permanently deleted. This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _deleteAccount,
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    Navigator.pop(context); // close dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 1. Delete all hostels owned by this user
      final hostels = await FirebaseFirestore.instance
          .collection('hostels')
          .where('owner_id', isEqualTo: user.uid)
          .get();
      for (var doc in hostels.docs) {
        await doc.reference.delete();
      }

      // 2. Delete user doc
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // 3. Delete Firebase Auth user
      await user.delete();

      if (mounted) {
        Navigator.pop(context); // close loader
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // close loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'requires-recent-login'
                ? "Please login again to delete account"
                : "Error: ${e.message}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
