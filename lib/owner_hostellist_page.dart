// import 'package:flutter/material.dart';

// const Color navyBlue = Color.fromARGB(255, 2, 17, 46);

// class OwnerHostelListPage extends StatelessWidget {
//   const OwnerHostelListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F7FC),

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,

//         title: const Text("My Listings", style: TextStyle(color: Colors.black)),
//       ),

//       body: ListView(
//         padding: const EdgeInsets.all(12),

//         children: [
//           hostelCard(
//             "assets/images/hostel1.jpg",
//             "Green Valley Hostel",
//             "Approved",
//             Colors.green,
//           ),

//           hostelCard(
//             "assets/images/hostel2.jpg",
//             "Sunrise Residence",
//             "Pending",
//             Colors.orange,
//           ),

//           hostelCard(
//             "assets/images/hostel3.jpg",
//             "City View Hostel",
//             "Approved",
//             Colors.green,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget hostelCard(String image, String title, String status, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),

//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),

//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),

//             child: Image.asset(
//               image,
//               height: 150,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(12),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),

//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),

//                       decoration: BoxDecoration(
//                         color: color.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),

//                       child: Text(
//                         status,
//                         style: TextStyle(fontSize: 11, color: color),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   "📍 Dhanmondi, Dhaka",
//                   style: TextStyle(fontSize: 12),
//                 ),

//                 const SizedBox(height: 4),

//                 const Text("৳ 8,000/month", style: TextStyle(fontSize: 12)),

//                 const SizedBox(height: 14),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: navyBlue,
//                         ),

//                         onPressed: () {},

//                         child: const Text(
//                           "✏ Edit",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(width: 10),

//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {},

//                         child: const Text(
//                           "🗑 Delete",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'owner_dashboard_page.dart';
import 'owner_profile_page.dart';
import 'owner_addhostel_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final Color primaryBlue = const Color(0xFF003366);

  int currentIndex = 1; // Hostel List active

  List<Map<String, dynamic>> hostelListings = [
    {"name": "Sunrise Hostel", "status": "Approved"},
    {"name": "Green View Hostel", "status": "Pending"},
    {"name": "City Life Hostel", "status": "Approved"},
  ];

  void deleteListing(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Listing"),
        content: const Text("Are you sure you want to delete this hostel?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: primaryBlue)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                hostelListings.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void editListing(String hostelName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Edit $hostelName clicked")));
  }

  /// NAVIGATION
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
        MaterialPageRoute(builder: (_) => const MyListingsPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AddHostelPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryBlue),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "My Listings",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      body: hostelListings.isEmpty
          ? Center(
              child: Text(
                "No hostel listings found",
                style: TextStyle(
                  fontSize: 18,
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hostelListings.length,
              itemBuilder: (context, index) {
                final hostel = hostelListings[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hostel["name"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Status: ${hostel["status"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: hostel["status"] == "Approved"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BUTTONS (ONLY MODIFIED PART)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                editListing(hostel["name"]);
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                deleteListing(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Hostels"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Hostel"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
