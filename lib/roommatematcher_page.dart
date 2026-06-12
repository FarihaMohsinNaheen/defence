import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nan_nestfinder/experiencedfeed_page.dart';

import 'home_page.dart';
import 'review_page.dart';

class RoommateMatchingPage extends StatefulWidget {
  const RoommateMatchingPage({super.key});

  @override
  State<RoommateMatchingPage> createState() => _RoommateMatchingPageState();
}

class _RoommateMatchingPageState extends State<RoommateMatchingPage> {
  final Color primaryBlue = const Color(0xFF003366);

  String selectedDepartment = "";
  List<String> selectedLifestyle = [];
  bool showResults = false;
  bool isLoading = true;

  int currentIndex = 2;

  final List<String> departments = ["CSE", "EEE", "BBA", "English"];
  final List<String> lifestyles = ["Study-focused", "Quiet", "Social"];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> roommates = [];

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    try {
      final roomResponse = await _firestore.collection('users').get();
      setState(() {
        roommates = roomResponse.docs
            .map((d) => {...d.data(), 'id': d.id})
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading data: $e");
    }
  }

  /// ROOMMATES FILTER - string version for dept + lifestyle
  List<Map<String, dynamic>> get filteredRoommates {
    // কিছু select না করলে empty list return করবে
    if (selectedDepartment.isEmpty && selectedLifestyle.isEmpty) {
      return [];
    }

    return roommates.where((person) {
      if (person['id'] == _currentUser?.uid) return false; // নিজেকে বাদ

      // Department: string == string
      final personDept =
          person["department"]?.toString().trim().toLowerCase() ?? "";
      final deptMatch =
          selectedDepartment.isEmpty ||
          personDept == selectedDepartment.toLowerCase();

      // Lifestyle: string == string. List থেকে যেকোনো 1টা match করলেই হবে
      final personLife =
          person["lifestyle"]?.toString().trim().toLowerCase() ?? "";
      final lifestyleMatch =
          selectedLifestyle.isEmpty ||
          selectedLifestyle.any((l) => personLife == l.toLowerCase());

      return deptMatch && lifestyleMatch;
    }).toList();
  }

  void onTabTapped(int index) {
    setState(() => currentIndex = index);
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ReviewPage()),
      );
    }
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: Text(
          "Find Roommates",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Department",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: departments.map((dept) {
                      bool isSelected = selectedDepartment == dept;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDepartment = isSelected ? "" : dept;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryBlue : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: primaryBlue.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            dept,
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Select Lifestyle",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: lifestyles.map((life) {
                      bool isSelected = selectedLifestyle.contains(life);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedLifestyle.remove(life);
                            } else if (selectedLifestyle.length < 2) {
                              selectedLifestyle.add(life);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryBlue : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: primaryBlue.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            life,
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                      ),
                      onPressed: () {
                        setState(() => showResults = true);
                      },
                      child: const Text(
                        "Find Matches",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (showResults) ...[
                    const SizedBox(height: 30),
                    Text(
                      "Suggested Roommates",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    filteredRoommates.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                selectedDepartment.isEmpty &&
                                        selectedLifestyle.isEmpty
                                    ? "Select department & lifestyle first"
                                    : "No roommates found",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          )
                        : Column(
                            children: filteredRoommates.map((person) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: primaryBlue.withOpacity(
                                      0.1,
                                    ),
                                    backgroundImage:
                                        person["profile"] != null &&
                                            person["profile"]
                                                .toString()
                                                .isNotEmpty
                                        ? NetworkImage(person["profile"])
                                        : null,
                                    child:
                                        person["profile"] == null ||
                                            person["profile"].toString().isEmpty
                                        ? Text(
                                            person["name"]
                                                        ?.toString()
                                                        .isNotEmpty ==
                                                    true
                                                ? person["name"][0]
                                                      .toUpperCase()
                                                : "?",
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    person["name"] ?? "No Name",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Text(
                                        "${person["department"] ?? "N/A"} • ${person["lifestyle"] ?? "N/A"}",
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        person["email"] ?? "",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
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
    );
  }
}
