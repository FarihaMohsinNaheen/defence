import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/experiencedfeed_page.dart';
import 'package:nan_nestfinder/owner_booking_page.dart';
import 'package:nan_nestfinder/ownerpayment_page.dart';
import 'Owner_Help&Support_page.dart';
import 'owner_setting_page.dart';
import 'owner_notification_page.dart';
import 'owner_addhostel_page.dart';
import 'owner_hostellist_page.dart';
import 'owner_profile_page.dart';
import 'owner_chatlist_page.dart';
import 'roleselection_page.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int currentIndex = 0;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
      (route) => false,
    );
  }

  void onTabTapped(int index) {
    if (index == currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const OwnerDashboardPage();
        break;
      case 1:
        page = const MyListingsPage();
        break;
      case 2:
        page = const AddHostelPage();
        break;
      case 3:
        page = const OwnerProfilePage();
        break;

      default:
        page = const OwnerDashboardPage();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        title: const Text(
          "Owner Dashboard",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () => onTabTapped(3),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryBlue),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.home_work, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      "Owner Panel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
                color: primaryBlue,
              ),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OwnerNotificationPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: primaryBlue),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OwnerSettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: primaryBlue),
              title: const Text("Help & Support"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OwnerHelpsupportPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        color: primaryBlue,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Welcome back, ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    "Owner!",
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Row 1: Total Listings + Approved
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('hostels')
                          .where('owner_id', isEqualTo: uid)
                          .snapshots(),
                      builder: (context, snap) {
                        return statBox(
                          Icons.home_work,
                          snap.hasData ? "${snap.data!.docs.length}" : "0",
                          "Total Listings",
                          Colors.blue,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('hostels')
                          .where('owner_id', isEqualTo: uid)
                          .where('status', isEqualTo: 'approved')
                          .snapshots(),
                      builder: (context, snap) {
                        return statBox(
                          Icons.verified,
                          snap.hasData ? "${snap.data!.docs.length}" : "0",
                          "Approved",
                          Colors.green,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Pending + Bookings
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('hostels')
                          .where('owner_id', isEqualTo: uid)
                          .where('status', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snap) {
                        return statBox(
                          Icons.hourglass_bottom,
                          snap.hasData ? "${snap.data!.docs.length}" : "0",
                          "Pending",
                          Colors.orange,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bookings')
                          .where(
                            'owner_id',
                            isEqualTo: uid,
                          ) // ownerId na, owner_id
                          .where('status', isEqualTo: 'approved')
                          .snapshots(),
                      builder: (context, snap) {
                        return statBox(
                          Icons.book_online,
                          snap.hasData ? "${snap.data!.docs.length}" : "0",
                          "Bookings",
                          Colors.purple,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Quick Actions",
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.message_outlined,
                      label: "Messages",
                      color: primaryBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerChatListPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.payment,
                      label: "Payments",
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerPaymentPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.dynamic_feed,
                      label: "Reviews",
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExperienceFeedPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.book_online,
                      label: "Bookings",
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OwnerBookingsPage(owner_id: uid!),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Pull down to refresh",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "Hostels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget statBox(IconData icon, String number, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 10),
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
