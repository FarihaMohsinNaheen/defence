import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/roleselection_page.dart';
import 'hosteldetails_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'review_page.dart';
import 'roommatematcher_page.dart';
import 'setting_page.dart';
import 'help&support_page.dart';
import 'savedhostel_page.dart';
import 'experiencedfeed_page.dart';
import 'Mybooking_page.dart';
import 'roomdetails_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String activeFilter = "All";
  int currentIndex = 0;

  final Color primaryBlue = const Color(0xFF003366);
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> applySearch(List<Map<String, dynamic>> list) {
    if (searchQuery.isEmpty) return list;
    return list.where((h) {
      final name = (h["name"] ?? "").toString().toLowerCase();
      final location = (h["location"] ?? "").toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          location.contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> applyFilter(List<Map<String, dynamic>> list) {
    List<Map<String, dynamic>> filtered = List.from(list);

    if (activeFilter == "Meal") {
      filtered = filtered.where((h) {
        // Check 1: facilities array te "meal" ache kina
        final facilities = (h["facilities"] as List?) ?? [];
        bool hasMealInArray = facilities.any(
          (f) => f.toString().toLowerCase().trim() == "meal",
        );

        // Check 2: meal_service boolean true kina
        bool hasMealService = (h["meal_service"] ?? false) == true;

        return hasMealInArray || hasMealService;
      }).toList();
    } else if (activeFilter == "Rating") {
      filtered = filtered.where((h) => (h["rating"] ?? 0) >= 4.5).toList();
    } else if (activeFilter == "Available") {
      filtered = filtered
          .where((h) => (h['available_rooms'] ?? 0) > 0)
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showAvailableRoomsSheet(
    BuildContext context,
    Map<String, dynamic> hostel,
    List<Map> availableRooms,
  ) {
    // Fix 2: Sort rooms by room number 101 → 102 → 103
    availableRooms.sort((a, b) {
      int aNum = int.tryParse(a['room_number'].toString()) ?? 0;
      int bNum = int.tryParse(b['room_number'].toString()) ?? 0;
      return aNum.compareTo(bNum);
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Rooms - ${hostel['name']}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 15),
              ...availableRooms.map((room) {
                int beds = (room['beds'] ?? 1);
                int booked = (room['booked_beds'] ?? 0);
                // Fix 3: Bed count logic - already correct: beds - booked
                return ListTile(
                  leading: const Icon(Icons.bed, color: Colors.green),
                  title: Text("Room ${room['room_number']}"),
                  subtitle: Text(
                    "${beds - booked} bed${beds - booked > 1 ? 's' : ''} available",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomDetailsPage(
                          room: Map<String, dynamic>.from(room),
                          roomId: room['id'],
                          hostel: Map<String, dynamic>.from(hostel),
                          ownerId: hostel['owner_id'] ?? '',
                          ownerName: hostel['owner_name'] ?? '',
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryBlue),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Saved Hostels"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedHostelsPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text("My Bookings"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyBookingsPage()),
              ),
            ),
            // Fix 5: Removed "Profile" from drawer list
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() => currentIndex = i);
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReviewPage()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: "Experience Feedback",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Text(
                        "NAN NestFinder",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      // Fix 4: Profile icon opens Profile page
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentProfilePage(),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: primaryBlue,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search hostel...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildChip("All"),
                        buildChip("Meal"),
                        buildChip("Rating"),
                        buildChip("Available"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hostels')
                    .where('status', isEqualTo: 'approved')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_work_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No approved hostels yet",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rooms')
                        .snapshots(),
                    builder: (context, roomSnapshot) {
                      Map<String, List<Map>> roomsByHostel = {};

                      if (roomSnapshot.hasData) {
                        for (var roomDoc in roomSnapshot.data!.docs) {
                          final roomData = Map<String, dynamic>.from(
                            roomDoc.data() as Map,
                          );
                          roomData['id'] = roomDoc.id;
                          final hostelId = roomData['hostel_id'].toString();
                          roomsByHostel[hostelId] =
                              (roomsByHostel[hostelId] ?? [])..add(roomData);
                        }
                      }

                      List<Map<String, dynamic>> hostels = docs.map((doc) {
                        final data = Map<String, dynamic>.from(
                          doc.data() as Map,
                        );
                        data['id'] = doc.id;
                        final rooms = roomsByHostel[doc.id] ?? [];
                        data['room_count'] = rooms.length;

                        final availableRooms = rooms.where((r) {
                          int beds = (r['beds'] ?? 1);
                          int booked = (r['booked_beds'] ?? 0);
                          return booked < beds;
                        }).toList();

                        data['available_rooms'] = availableRooms.length;
                        data['available_room_list'] = availableRooms;

                        return data;
                      }).toList();

                      hostels.sort((a, b) {
                        final aTime = a['updated_at'] as Timestamp?;
                        final bTime = b['updated_at'] as Timestamp?;
                        if (aTime == null && bTime == null) return 0;
                        if (aTime == null) return 1;
                        if (bTime == null) return -1;
                        return bTime.compareTo(aTime);
                      });

                      final searchedList = applySearch(hostels);
                      final filteredList = applyFilter(searchedList);
                      final isNotFound = filteredList.isEmpty;
                      final isAll = activeFilter == "All";

                      // Fix 6A: Recommended for You - rating >=4.0 + most bookings, top 6
                      final recommended =
                          filteredList
                              .where((h) => (h["rating"] ?? 0) >= 4.0)
                              .toList()
                            ..sort(
                              (a, b) => ((b["total_bookings"] ?? 0) as int)
                                  .compareTo((a["total_bookings"] ?? 0) as int),
                            );
                      final recommendedTop = recommended.take(6).toList();

                      // Fix 6B: Top Rated - sort by rating desc, top 5
                      final topRated =
                          List<Map<String, dynamic>>.from(filteredList)..sort(
                            (a, b) => ((b["rating"] ?? 0) as double).compareTo(
                              (a["rating"] ?? 0) as double,
                            ),
                          );
                      final topRatedTop = topRated.take(5).toList();

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isNotFound)
                              const Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 80),
                                    Icon(
                                      Icons.search_off,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Not Found",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              if (isAll) ...[
                                section("All Hostels"),
                                buildVertical(filteredList, roomsByHostel),
                                const SizedBox(height: 20),
                              ],
                              section("Recommended for You"),
                              buildHorizontal(recommendedTop, roomsByHostel),
                              const SizedBox(height: 20),
                              // Fix 7: Removed "Nearby Hostels" section
                              section("Top Rated"),
                              buildVertical(topRatedTop, roomsByHostel),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChip(String t) {
    final isActive = activeFilter == t;
    return GestureDetector(
      onTap: () => setState(() => activeFilter = t),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          t,
          style: TextStyle(
            color: isActive ? Colors.white : primaryBlue,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget section(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryBlue,
      ),
    ),
  );

  Widget buildHorizontal(
    List<Map<String, dynamic>> list,
    Map<String, List<Map>> roomsByHostel,
  ) => SizedBox(
    height: 240,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, i) {
        final h = list[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
            ),
          ),
          child: Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    h["image_building"] ?? '',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h["name"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${h["area"] ?? ""}, ${h["location"] ?? ""}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget buildVertical(
    List<Map<String, dynamic>> list,
    Map<String, List<Map>> roomsByHostel,
  ) => ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (c, i) => hostelCard(list[i], roomsByHostel),
  );

  Widget hostelCard(
    Map<String, dynamic> h,
    Map<String, List<Map>> roomsByHostel,
  ) {
    final availableRooms = h['available_room_list'] as List<Map>;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                h["image_building"] ?? '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h["name"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${h["area"] ?? ""}, ${h["location"] ?? ""}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  if (h['available_rooms'] > 0)
                    GestureDetector(
                      onTap: () =>
                          showAvailableRoomsSheet(context, h, availableRooms),
                      child: Text(
                        "${h['available_rooms']} Room${h['available_rooms'] > 1 ? 's' : ''} available",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          // Fix 1: Underline removed
                        ),
                      ),
                    )
                  else
                    Text(
                      "Fully booked",
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nan_nestfinder/roleselection_page.dart';
// import 'hosteldetails_page.dart';
// import 'notification_page.dart';
// import 'profile_page.dart';
// import 'review_page.dart';
// import 'roommatematcher_page.dart';
// import 'setting_page.dart';
// import 'help&support_page.dart';
// import 'savedhostel_page.dart';
// import 'experiencedfeed_page.dart';
// import 'Mybooking_page.dart';
// import 'roomdetails_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String searchQuery = "";
//   String activeFilter = "All";
//   int currentIndex = 0;

//   final Color primaryBlue = const Color(0xFF003366);
//   final TextEditingController searchController = TextEditingController();

//   List<Map<String, dynamic>> applySearch(List<Map<String, dynamic>> list) {
//     if (searchQuery.isEmpty) return list;
//     return list.where((h) {
//       final name = (h["name"] ?? "").toString().toLowerCase();
//       final location = (h["location"] ?? "").toString().toLowerCase();
//       return name.contains(searchQuery.toLowerCase()) ||
//           location.contains(searchQuery.toLowerCase());
//     }).toList();
//   }

//   List<Map<String, dynamic>> applyFilter(List<Map<String, dynamic>> list) {
//     List<Map<String, dynamic>> filtered = List.from(list);

//     if (activeFilter == "Meal") {
//       filtered = filtered.where((h) {
//         final facilities = (h["facilities"] as List?) ?? [];
//         bool hasMealInArray = facilities.any(
//           (f) => f.toString().toLowerCase().trim() == "meal",
//         );
//         bool hasMealService = (h["meal_service"] ?? false) == true;
//         return hasMealInArray || hasMealService;
//       }).toList();
//     } else if (activeFilter == "Rating") {
//       filtered = filtered.where((h) => (h["rating"] ?? 0) >= 4.5).toList();
//     } else if (activeFilter == "Available") {
//       filtered = filtered
//           .where((h) => (h['available_rooms'] ?? 0) > 0)
//           .toList();
//     }

//     return filtered;
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void showAvailableRoomsSheet(
//     BuildContext context,
//     Map<String, dynamic> hostel,
//     List<Map> availableRooms,
//   ) {
//     availableRooms.sort((a, b) {
//       int aNum = int.tryParse(a['room_number'].toString()) ?? 0;
//       int bNum = int.tryParse(b['room_number'].toString()) ?? 0;
//       return aNum.compareTo(bNum);
//     });

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Available Rooms - ${hostel['name']}",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: primaryBlue,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ...availableRooms.map((room) {
//                 int beds = (room['beds'] ?? 1);
//                 int booked = (room['booked_beds'] ?? 0);
//                 return ListTile(
//                   leading: const Icon(Icons.bed, color: Colors.green),
//                   title: Text("Room ${room['room_number']}"),
//                   subtitle: Text(
//                     "${beds - booked} bed${beds - booked > 1 ? 's' : ''} available",
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => RoomDetailsPage(
//                           room: Map<String, dynamic>.from(room),
//                           roomId: room['id'],
//                           hostel: Map<String, dynamic>.from(hostel),
//                           hostelId:
//                               hostel['id'] ?? '', // FIXED: Eita add korlam
//                           ownerId: hostel['owner_id'] ?? '',
//                           ownerName: hostel['owner_name'] ?? '',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: primaryBlue),
//               child: const Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Menu",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.favorite),
//               title: const Text("Saved Hostels"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SavedHostelsPage()),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.book_online),
//               title: const Text("My Bookings"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => MyBookingsPage()),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.notifications),
//               title: const Text("Notifications"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const NotificationPage()),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text("Settings"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsPage()),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.help),
//               title: const Text("Help & Support"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const HelpSupportPage()),
//               ),
//             ),
//             const Spacer(),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text("Logout", style: TextStyle(color: Colors.red)),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) {
//           setState(() => currentIndex = i);
//           if (i == 0) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           } else if (i == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ReviewPage()),
//             );
//           } else if (i == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
//             );
//           } else if (i == 3) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dynamic_feed),
//             label: "Experience Feedback",
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Builder(
//                         builder: (context) => IconButton(
//                           icon: const Icon(Icons.menu),
//                           onPressed: () => Scaffold.of(context).openDrawer(),
//                         ),
//                       ),
//                       Text(
//                         "NAN NestFinder",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: primaryBlue,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const StudentProfilePage(),
//                           ),
//                         ),
//                         child: CircleAvatar(
//                           backgroundColor: primaryBlue,
//                           child: const Icon(Icons.person, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: searchController,
//                     onChanged: (v) => setState(() => searchQuery = v),
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search),
//                       hintText: "Search hostel...",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         buildChip("All"),
//                         buildChip("Meal"),
//                         buildChip("Rating"),
//                         buildChip("Available"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('hostels')
//                     .where('status', isEqualTo: 'approved')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text("Error: ${snapshot.error}"));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.home_work_outlined,
//                             size: 80,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             "No approved hostels yet",
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   final docs = snapshot.data!.docs;

//                   return StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('rooms')
//                         .snapshots(),
//                     builder: (context, roomSnapshot) {
//                       Map<String, List<Map>> roomsByHostel = {};

//                       if (roomSnapshot.hasData) {
//                         for (var roomDoc in roomSnapshot.data!.docs) {
//                           final roomData = Map<String, dynamic>.from(
//                             roomDoc.data() as Map,
//                           );
//                           roomData['id'] = roomDoc.id;
//                           final hostelId = roomData['hostel_id'].toString();
//                           roomsByHostel[hostelId] =
//                               (roomsByHostel[hostelId] ?? [])..add(roomData);
//                         }
//                       }

//                       List<Map<String, dynamic>> hostels = docs.map((doc) {
//                         final data = Map<String, dynamic>.from(
//                           doc.data() as Map,
//                         );
//                         data['id'] = doc.id;
//                         final rooms = roomsByHostel[doc.id] ?? [];
//                         data['room_count'] = rooms.length;

//                         final availableRooms = rooms.where((r) {
//                           int beds = (r['beds'] ?? 1);
//                           int booked = (r['booked_beds'] ?? 0);
//                           return booked < beds;
//                         }).toList();

//                         data['available_rooms'] = availableRooms.length;
//                         data['available_room_list'] = availableRooms;

//                         return data;
//                       }).toList();

//                       hostels.sort((a, b) {
//                         final aTime = a['updated_at'] as Timestamp?;
//                         final bTime = b['updated_at'] as Timestamp?;
//                         if (aTime == null && bTime == null) return 0;
//                         if (aTime == null) return 1;
//                         if (bTime == null) return -1;
//                         return bTime.compareTo(aTime);
//                       });

//                       final searchedList = applySearch(hostels);
//                       final filteredList = applyFilter(searchedList);
//                       final isNotFound = filteredList.isEmpty;
//                       final isAll = activeFilter == "All";

//                       final recommended =
//                           filteredList
//                               .where((h) => (h["rating"] ?? 0) >= 4.0)
//                               .toList()
//                             ..sort(
//                               (a, b) => ((b["total_bookings"] ?? 0) as int)
//                                   .compareTo((a["total_bookings"] ?? 0) as int),
//                             );
//                       final recommendedTop = recommended.take(6).toList();

//                       final topRated =
//                           List<Map<String, dynamic>>.from(filteredList)..sort(
//                             (a, b) => ((b["rating"] ?? 0) as double).compareTo(
//                               (a["rating"] ?? 0) as double,
//                             ),
//                           );
//                       final topRatedTop = topRated.take(5).toList();

//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (isNotFound)
//                               const Center(
//                                 child: Column(
//                                   children: [
//                                     SizedBox(height: 80),
//                                     Icon(
//                                       Icons.search_off,
//                                       size: 80,
//                                       color: Colors.grey,
//                                     ),
//                                     Text(
//                                       "Not Found",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else ...[
//                               if (isAll) ...[
//                                 section("All Hostels"),
//                                 buildVertical(filteredList, roomsByHostel),
//                                 const SizedBox(height: 20),
//                               ],
//                               section("Recommended for You"),
//                               buildHorizontal(recommendedTop, roomsByHostel),
//                               const SizedBox(height: 20),
//                               section("Top Rated"),
//                               buildVertical(topRatedTop, roomsByHostel),
//                               const SizedBox(height: 20),
//                             ],
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildChip(String t) {
//     final isActive = activeFilter == t;
//     return GestureDetector(
//       onTap: () => setState(() => activeFilter = t),
//       child: Container(
//         margin: const EdgeInsets.only(right: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//         decoration: BoxDecoration(
//           color: isActive ? primaryBlue : Colors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Text(
//           t,
//           style: TextStyle(
//             color: isActive ? Colors.white : primaryBlue,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget section(String t) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Text(
//       t,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: primaryBlue,
//       ),
//     ),
//   );

//   Widget buildHorizontal(
//     List<Map<String, dynamic>> list,
//     Map<String, List<Map>> roomsByHostel,
//   ) => SizedBox(
//     height: 240,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: list.length,
//       itemBuilder: (context, i) {
//         final h = list[i];
//         return GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
//             ),
//           ),
//           child: Container(
//             width: 220,
//             margin: const EdgeInsets.only(right: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                   child: Image.network(
//                     h["image_building"] ?? '',
//                     height: 140,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 140,
//                       color: Colors.grey[300],
//                       child: const Icon(Icons.home, size: 50),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         h["name"] ?? "",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "${h["area"] ?? ""}, ${h["location"] ?? ""}",
//                         style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );

//   Widget buildVertical(
//     List<Map<String, dynamic>> list,
//     Map<String, List<Map>> roomsByHostel,
//   ) => ListView.builder(
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     itemCount: list.length,
//     itemBuilder: (c, i) => hostelCard(list[i], roomsByHostel),
//   );

//   Widget hostelCard(
//     Map<String, dynamic> h,
//     Map<String, List<Map>> roomsByHostel,
//   ) {
//     final availableRooms = h['available_room_list'] as List<Map>;
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
//         ),
//       ),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 h["image_building"] ?? '',
//                 width: 90,
//                 height: 90,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   width: 90,
//                   height: 90,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.home),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     h["name"] ?? "",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${h["area"] ?? ""}, ${h["location"] ?? ""}",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                   ),
//                   const SizedBox(height: 6),
//                   if (h['available_rooms'] > 0)
//                     GestureDetector(
//                       onTap: () =>
//                           showAvailableRoomsSheet(context, h, availableRooms),
//                       child: Text(
//                         "${h['available_rooms']} Room${h['available_rooms'] > 1 ? 's' : ''} available",
//                         style: const TextStyle(
//                           color: Colors.green,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   else
//                     Text(
//                       "Fully booked",
//                       style: TextStyle(
//                         color: Colors.red[400],
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
