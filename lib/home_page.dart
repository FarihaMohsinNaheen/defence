import 'package:flutter/material.dart';
import 'appdata_page.dart';
import 'experiencedfeed_page.dart';
import 'hosteldetails_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'review_page.dart';
import 'roommatematcher_page.dart';
import 'setting_page.dart';
import 'help&support_page.dart';
import 'savedhostel_page.dart';

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

  final List<Map<String, dynamic>> hostels = AppData.hostels;

  List<Map<String, dynamic>> get searchedHostels {
    if (searchQuery.isEmpty) return hostels;

    return hostels.where((h) {
      return h["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          h["location"].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> applyFilter(List<Map<String, dynamic>> list) {
    List<Map<String, dynamic>> filtered = List.from(list);

    if (activeFilter == "Budget") {
      filtered.sort((a, b) => a["price"].compareTo(b["price"]));
    } else if (activeFilter == "Rating") {
      filtered = filtered.where((h) => h["rating"] >= 4.5).toList();
    } else if (activeFilter == "Available Now") {
      filtered = filtered.where((h) => h["available"] == true).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = applyFilter(searchedHostels);
    final isNotFound = filteredList.isEmpty;
    final isAll = activeFilter == "All";

    final recommended = filteredList.take(3).toList();
    final nearby = filteredList;
    final topRated = filteredList.where((h) => h["rating"] >= 4.5).toList();

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedHostelsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dynamic_feed),
              title: const Text("Experience Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                );
              },
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {},
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
          setState(() {
            currentIndex = i;
          });

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
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                    CircleAvatar(
                      backgroundColor: primaryBlue,
                      child: const Icon(Icons.person, color: Colors.white),
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
                      buildChip("Budget"),
                      buildChip("Rating"),
                      buildChip("Available Now"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (isNotFound)
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey),
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
                    buildVertical(filteredList),
                    const SizedBox(height: 20),
                  ],
                  section("Recommended for You"),
                  buildHorizontal(recommended),
                  const SizedBox(height: 20),

                  section("Nearby Hostels"),
                  buildVertical(nearby),
                  const SizedBox(height: 20),

                  section("Top Rated"),
                  buildVertical(topRated),
                ],
              ],
            ),
          ),
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
          style: TextStyle(color: isActive ? Colors.white : primaryBlue),
        ),
      ),
    );
  }

  Widget section(String t) => Text(
    t,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryBlue,
    ),
  );

  Widget buildHorizontal(List list) => SizedBox(
    height: 250,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, i) {
        final h = list[i];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
              ),
            );
          },
          child: Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    h["image"],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(h["location"]),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          Text("${h["rating"]}"),
                        ],
                      ),
                      Text(
                        "Tk ${h["price"]}",
                        style: TextStyle(
                          color: primaryBlue,
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

  Widget buildVertical(List list) => ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (c, i) => hostelCard(list[i], false),
  );

  Widget hostelCard(Map h, bool horizontal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HostelDetailsPage(hostel: Map<String, dynamic>.from(h)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: horizontal ? 200 : double.infinity,
        height: horizontal ? null : 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                h["image"],
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(h["location"]),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text("${h["rating"]}"),
                    ],
                  ),
                  Text(
                    "Tk ${h["price"]}",
                    style: TextStyle(color: primaryBlue),
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
