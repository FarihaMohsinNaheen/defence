import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/roleselection_page.dart';
import 'package:nan_nestfinder/student_chatlist_page.dart';
import 'hosteldetails_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'review_page.dart';
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
  String priceSortOrder = "";
  String activeFilter = "All";
  int currentIndex = 0;

  final Color primaryBlue = const Color(0xFF003366);
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> applySearch(List<Map<String, dynamic>> list) {
    if (searchQuery.isEmpty) return list;
    return list.where((h) {
      final name = (h["name"] ?? "").toString().toLowerCase();
      final area = (h["area"] ?? "").toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          area.contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> applyFilter(
    List<Map<String, dynamic>> list,
    Map<String, List<Map>> roomsByHostel,
  ) {
    List<Map<String, dynamic>> filtered = List.from(list);

    if (activeFilter == "Meal") {
      filtered = filtered.where((h) {
        // Check 1: facilities array te "meal" ache kina
        final facilities = (h["facilities"] as List?) ?? [];
        bool hasMealInArray = facilities.any(
          (f) => f.toString().toLowerCase().trim() == "meal",
        );

        //  meal_service boolean
        bool hasMealService = (h["meal_service"] ?? false) == true;

        return hasMealInArray || hasMealService;
      }).toList();
    } else if (activeFilter == "Rating") {
      filtered = filtered
          .where((h) => (h["rating"] ?? 0).toDouble() >= 4.5)
          .toList(); // FIXED
    } else if (activeFilter == "Available") {
      filtered = filtered
          .where((h) => (h['available_rooms'] ?? 0) > 0)
          .toList();
    }
    // NEW: Boys filter
    else if (activeFilter == "Boys") {
      filtered = filtered
          .where(
            (h) => (h['hostel_type'] ?? '').toString().toLowerCase() == "boys",
          )
          .toList();
    }
    // NEW: Girls filter
    else if (activeFilter == "Girls") {
      filtered = filtered
          .where(
            (h) => (h['hostel_type'] ?? '').toString().toLowerCase() == "girls",
          )
          .toList();
    }

    if (priceSortOrder == "low") {
      filtered.sort((a, b) {
        final aRooms = roomsByHostel[a['id']] ?? [];
        final bRooms = roomsByHostel[b['id']] ?? [];
        final aMinPrice = aRooms
            .where((r) => (r['booked_beds'] ?? 0) < (r['beds'] ?? 1))
            .map((r) => (r['price'] ?? 999).toDouble()) // FIXED
            .fold(999.0, (min, price) => price < min ? price : min);
        final bMinPrice = bRooms
            .where((r) => (r['booked_beds'] ?? 0) < (r['beds'] ?? 1))
            .map((r) => (r['price'] ?? 999).toDouble()) // FIXED
            .fold(
              999.0,
              (min, price) => price < min ? price : min,
            ); // FIXED 999.0
        return aMinPrice.compareTo(bMinPrice);
      });
    } else if (priceSortOrder == "high") {
      filtered.sort((a, b) {
        final aRooms = roomsByHostel[a['id']] ?? [];
        final bRooms = roomsByHostel[b['id']] ?? [];
        final aMaxPrice = aRooms
            .map((r) => (r['price'] ?? 0).toDouble())
            .fold(0.0, (max, price) => price > max ? price : max);
        final bMaxPrice = bRooms
            .map((r) => (r['price'] ?? 0).toDouble()) // FIXED
            .fold(0.0, (max, price) => price > max ? price : max);
        return bMaxPrice.compareTo(aMaxPrice);
      });
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
    // Fix 2: Sort rooms by room number
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
                MaterialPageRoute(
                  builder: (_) => const SavedHostelorRoomPage(),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Messages"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentChatListPage()),
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
                MaterialPageRoute(builder: (_) => const StudentSettingsPage()),
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
              MaterialPageRoute(builder: (_) => const MyBookingsPage()),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: "Bookings",
          ),
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
                        buildChip("Boys"),
                        buildChip("Girls"),
                        PopupMenuButton<String>(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: priceSortOrder.isNotEmpty
                                  ? primaryBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  priceSortOrder == "low"
                                      ? "Price: Low"
                                      : priceSortOrder == "high"
                                      ? "Price: High"
                                      : "Price",
                                  style: TextStyle(
                                    color: priceSortOrder.isNotEmpty
                                        ? Colors.white
                                        : primaryBlue,
                                    fontWeight: priceSortOrder.isNotEmpty
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: priceSortOrder.isNotEmpty
                                      ? Colors.white
                                      : primaryBlue,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          onSelected: (value) {
                            setState(() {
                              priceSortOrder = value;
                              activeFilter = value.isEmpty ? "All" : "Price";
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: "low",
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_upward, size: 18),
                                      SizedBox(width: 8),
                                      Text('Low to High'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: "high",
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_downward, size: 18),
                                      SizedBox(width: 8),
                                      Text('High to Low'),
                                    ],
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hostels')
                    .where('status', isEqualTo: 'approved')
                    .where('is_available', isEqualTo: true)
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
                      final filteredList = applyFilter(
                        searchedList,
                        roomsByHostel,
                      );
                      final isNotFound = filteredList.isEmpty;
                      final isAll = activeFilter == "All";

                      // Recommended for You
                      final recommended =
                          filteredList
                              .where(
                                (h) => (h["rating"] ?? 0).toDouble() >= 4.0,
                              ) // FIXED
                              .toList()
                            ..sort(
                              (a, b) => ((b["total_bookings"] ?? 0) as int)
                                  .compareTo((a["total_bookings"] ?? 0) as int),
                            );
                      final recommendedTop = recommended.take(6).toList();

                      //  Top Rated
                      final topRated =
                          List<Map<String, dynamic>>.from(filteredList)..sort(
                            (a, b) => ((b["rating"] ?? 0).toDouble()).compareTo(
                              // FIXED
                              (a["rating"] ?? 0).toDouble(), // FIXED
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
                              if (priceSortOrder.isNotEmpty) ...[
                                section(
                                  priceSortOrder == "low"
                                      ? "Rooms: Low to High"
                                      : "Rooms: High to Low",
                                ),
                                buildRoomList(roomsByHostel, docs),
                                const SizedBox(height: 20),
                              ] else if (isAll) ...[
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
    final isActive =
        activeFilter == t || (t == "Price" && priceSortOrder.isNotEmpty);
    return GestureDetector(
      onTap: () => setState(() {
        activeFilter = t;
        if (t != "Price") {
          priceSortOrder = "";
        }
      }),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // NEW: Show available rooms count
                      if (h['available_rooms'] > 0)
                        Text(
                          "${h['available_rooms']} Room${h['available_rooms'] > 1 ? 's' : ''} available",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          "Not Available",
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

  Widget buildRoomList(
    Map<String, List<Map>> roomsByHostel,
    List<QueryDocumentSnapshot> docs,
  ) {
    List<Map<String, dynamic>> allRooms = [];

    roomsByHostel.forEach((hostelId, rooms) {
      for (var room in rooms) {
        if ((room['booked_beds'] ?? 0) < (room['beds'] ?? 1)) {
          final hostelDoc = docs.where((h) => h.id == hostelId).firstOrNull;
          if (hostelDoc == null) continue;
          allRooms.add({...room, 'hostel_name': hostelDoc.get('name')});
        }
      }
    });

    allRooms.sort((a, b) {
      num priceA =
          num.tryParse((a['monthly_rent'] ?? 99999).toString()) ?? 99999;
      num priceB =
          num.tryParse((b['monthly_rent'] ?? 99999).toString()) ?? 99999;
      return priceSortOrder == "low"
          ? priceA.compareTo(priceB)
          : priceB.compareTo(priceA);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allRooms.length,
      itemBuilder: (c, i) {
        final room = allRooms[i];
        final price = num.tryParse((room['monthly_rent'] ?? 0).toString()) ?? 0;
        final roomImages = (room['room_images'] as List?) ?? [];
        final imageUrl = roomImages.isNotEmpty ? roomImages[0].toString() : '';
        final hostelId = room['hostel_id'].toString();
        final hostelDoc = docs.where((h) => h.id == hostelId).firstOrNull;
        final hostelData = hostelDoc != null
            ? {
                ...Map<String, dynamic>.from(hostelDoc.data() as Map),
                'id': hostelDoc.id,
              }
            : <String, dynamic>{};

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomDetailsPage(
                room: Map<String, dynamic>.from(room),
                roomId: room['id'],
                hostel: hostelData,
                ownerId: hostelData['owner_id'] ?? '',
                ownerName: hostelData['owner_name'] ?? '',
              ),
            ),
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: const Icon(Icons.bedroom_parent_outlined),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${room['hostel_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Room ${room['room_number']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tk $price',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
