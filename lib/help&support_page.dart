import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/home_page.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final Color primaryBlue = const Color(0xFF003366);

  /// MASTER FAQ LIST
  final List<Map<String, String>> faqs = [
    {
      "q": "How do I book a hostel?",
      "a":
          "Open hostel details and go to the room which you want to book and tap 'Book Now'.",
    },
    {
      "q": "How can I contact hostel owner?",
      "a": "Use chat with owner inside room details.",
    },
    {
      "q": "How can i cancel my booking?",
      "a":
          "You can cancel your booking in my booing page if you cancel before 24 hours you will get a full refend otherwise no refund will be given  .",
    },
    {
      "q": "Can I save hostels?",
      "a": "Yes, tap the heart icon to save hostels.",
    },
  ];

  /// POPUP FUNCTION
  void showPopup(Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });
        return Center(
          child: Material(color: Colors.transparent, child: content),
        );
      },
    );
  }

  /// CONTACT INFO POPUP
  void showContactInfo(String title, String info, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryBlue, size: 55),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              info,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// DELETE CONFIRM DIALOG
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "This will permanently delete your account and all bookings. You cannot undo this.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ACTUALLY DELETE USER + DATA
  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Step 1: Delete all bookings for this user
      final bookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('student_id', isEqualTo: user.uid)
          .get();
      for (var doc in bookings.docs) {
        await doc.reference.delete();
      }

      // Step 2: Delete auth account
      await user.delete();

      if (mounted) {
        // Go to home and clear stack. Change to LoginPage if you have one
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        showPopup(
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 55),
                SizedBox(height: 10),
                Text("Account deleted successfully"),
              ],
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (mounted) {
          showPopup(
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "For security, please log in again before deleting.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          showPopup(Text("Error: ${e.message}"));
        }
      }
    } catch (e) {
      if (mounted) {
        showPopup(Text("Error: $e"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FAQ TITLE
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 15),

            /// FAQ LIST
            Column(
              children: faqs
                  .map((faq) => faqTile(faq["q"]!, faq["a"]!))
                  .toList(),
            ),

            const SizedBox(height: 25),

            /// CONTACT OPTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                contactCard(
                  Icons.email,
                  "Email",
                  () => showContactInfo(
                    "Email Us",
                    "adminnannestfinder@gmail.com",
                    Icons.email,
                  ),
                ),
                contactCard(
                  Icons.call,
                  "Call",
                  () =>
                      showContactInfo("Call Us", "+8801728765123", Icons.call),
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// DELETE ACCOUNT
            Text(
              "Danger Zone",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delete My Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This action is permanent and cannot be undone.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _showDeleteConfirmDialog,
                      child: const Text(
                        "Delete My Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FAQ TILE
  Widget faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(padding: const EdgeInsets.all(12), child: Text(answer)),
        ],
      ),
    );
  }

  /// CONTACT CARD
  Widget contactCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryBlue),
            const SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }
}
