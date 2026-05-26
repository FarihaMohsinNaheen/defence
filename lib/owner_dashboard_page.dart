// import 'package:flutter/material.dart';
// import 'package:nan_nestfinder/Owner_Help&Support_page.dart';
// import 'package:nan_nestfinder/Owner_setting_page.dart';
// import 'package:nan_nestfinder/owner_notification_page.dart';

// import 'owner_addhostel_page.dart';
// import 'owner_hostellist_page.dart';
// import 'owner_profile_page.dart';

// class OwnerDashboardPage extends StatefulWidget {
//   const OwnerDashboardPage({super.key});

//   @override
//   State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
// }

// class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   int currentIndex = 0;

//   // static data for now
//   int totalListings = 3;
//   int approvedListings = 2;
//   int pendingListings = 1;
//   double rating = 4.5;

//   void onTabTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//       );
//     } else if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AddHostelPage()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MyListingsPage()),
//       );
//     } else if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       // ================= APP BAR =================
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: primaryBlue),
//         title: Text(
//           "Owner Dashboard",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       // ================= DRAWER MENU =================
//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: primaryBlue),
//               child: const Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Menu",
//                   style: TextStyle(color: Colors.white, fontSize: 22),
//                 ),
//               ),
//             ),

//             ListTile(
//               leading: const Icon(Icons.notifications),
//               title: const Text("Notifications"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const OwnerNotificationPage(),
//                   ),
//                 );
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text("Settings"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const OwnerSettingPage()),
//                 );
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.help),
//               title: const Text("Help & Support"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const OwnerHelpsupportPage(),
//                   ),
//                 );
//               },
//             ),

//             const Spacer(),

//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text("Logout", style: TextStyle(color: Colors.red)),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),

//       // ================= BODY =================
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),

//         child: Column(
//           children: [
//             buildCard("Total Listings", "$totalListings", Icons.home_work),
//             const SizedBox(height: 12),
//             buildCard(
//               "Approved",
//               "$approvedListings",
//               Icons.verified,
//               color: Colors.green,
//             ),
//             const SizedBox(height: 12),
//             buildCard(
//               "Pending",
//               "$pendingListings",
//               Icons.pending_actions,
//               color: Colors.orange,
//             ),
//             const SizedBox(height: 12),
//             buildCard("Reviews", "$rating ⭐", Icons.star, color: Colors.amber),
//           ],
//         ),
//       ),

//       // ================= BOTTOM NAV =================
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: onTabTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: "Dashboard",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Hostel"),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "Hostel List"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   /// CARD UI
//   Widget buildCard(
//     String title,
//     String value,
//     IconData icon, {
//     Color color = const Color(0xFF003366),
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 40, color: color),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// import 'owner_addhostel_page.dart';
// import 'owner_hostellist_page.dart';
// import 'owner_profile_page.dart';

// const Color primaryBlue = Color(0xFF003366);

// class OwnerDashboardPage extends StatefulWidget {
//   const OwnerDashboardPage({super.key});

//   @override
//   State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
// }

// class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
//   int currentIndex = 0;

//   void onTabTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//       );
//     } else if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AddHostelPage()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MyListingsPage()),
//       );
//     } else if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F7FC),

//       // ================= APP BAR =================
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: primaryBlue),
//         title: Text(
//           "Owner Dashboard",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       // ================= DRAWER MENU =================
//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(color: primaryBlue),
//               child: const Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Menu",
//                   style: TextStyle(color: Colors.white, fontSize: 22),
//                 ),
//               ),
//             ),

//             ListTile(
//               leading: const Icon(Icons.notifications),
//               title: const Text("Notifications"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text("Settings"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.help),
//               title: const Text("Help & Support"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             const Spacer(),

//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text("Logout"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),

//       // ================= BODY (YOUR ORIGINAL UI - UNCHANGED) =================
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Welcome back, Owner!",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),

//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 statBox("🏠", "3", "Total Listings"),
//                 const SizedBox(width: 10),
//                 statBox("✅", "2", "Approved"),
//               ],
//             ),

//             const SizedBox(height: 10),

//             Row(
//               children: [
//                 statBox("⏳", "1", "Pending Approval"),
//                 const SizedBox(width: 10),
//                 statBox("⭐", "24", "Reviews Received"),
//               ],
//             ),

//             const SizedBox(height: 18),

//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Quick Actions",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 14),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryBlue,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const AddHostelPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "+ Add New Listing",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: OutlinedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const MyListingsPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "☰ View My Listings",
//                         style: TextStyle(color: primaryBlue),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 18),
//             Icon(
//   Icons.star,
//   color: Colors.amber,
//   size: 32,
// ),
//             const Text(
//               " Recent Reviews",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             reviewBox("Rahim Ahmed", "Excellent hostel! Highly recommended."),
//             const SizedBox(height: 12),
//             reviewBox("Sarah Khan", "Good facilities and clean rooms."),

//             const SizedBox(height: 18),

//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFDCE8FF),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "📋 Listing Status",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "✅ Approved listings are visible to students",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     "⏳ Pending listings await admin verification",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     "🔒 Verified listings get TrustScore badge",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // ================= BOTTOM NAV =================
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: onTabTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: "Dashboard",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Hostel"),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "Hostel List"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   // ================= WIDGETS (UNCHANGED) =================
//   Widget statBox(String icon, String number, String title) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(icon),
//             const SizedBox(height: 6),
//             Text(
//               number,
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(title, style: const TextStyle(fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget reviewBox(String name, String review) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//               const Text("⭐⭐⭐⭐⭐"),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(review, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nan_nestfinder/Owner_Help&Support_page.dart';
import 'package:nan_nestfinder/Owner_setting_page.dart';
import 'package:nan_nestfinder/owner_notification_page.dart';

import 'owner_addhostel_page.dart';
import 'owner_hostellist_page.dart';
import 'owner_profile_page.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AddHostelPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyListingsPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
      );
    }
  }

  void openDrawerPage(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        title: Text(
          "Owner Dashboard",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      // ================= DRAWER (WORKING MENU) =================
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: primaryBlue),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.notifications, color: primaryBlue),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OwnerNotificationPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: primaryBlue),
              title: const Text("Settings"),
              onTap: () {
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
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back, Owner!",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                statBox(Icons.home_work, "3", "Total Listings"),
                const SizedBox(width: 10),
                statBox(Icons.verified, "2", "Approved"),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                statBox(Icons.hourglass_bottom, "1", "Pending"),
                const SizedBox(width: 10),
                statBox(Icons.star, "24", "Reviews"),
              ],
            ),

            const SizedBox(height: 18),

            // QUICK ACTIONS
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddHostelPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "+ Add New Listing",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyListingsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "☰ View My Listings",
                        style: TextStyle(color: primaryBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // REVIEWS TITLE (FIXED ICON)
            Row(
              children: const [
                Icon(Icons.star_rate, color: Colors.amber, size: 22),
                SizedBox(width: 6),
                Text(
                  "Recent Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            reviewBox("Rahim Ahmed", "Excellent hostel! Highly recommended."),
            const SizedBox(height: 12),
            reviewBox("Sarah Khan", "Good facilities and clean rooms."),

            const SizedBox(height: 18),

            // LISTING STATUS (WITH PROPER ICONS)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.list_alt, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Listing Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Approved listings are visible to students",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.hourglass_bottom,
                        color: Colors.orange,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Pending listings await admin verification",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Verified listings get TrustScore badge",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Hostel"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Hostel List"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ================= STATS BOX =================
  Widget statBox(IconData icon, String number, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34, color: primaryBlue),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ================= REVIEW BOX =================
  Widget reviewBox(String name, String review) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
