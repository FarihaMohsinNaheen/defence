// import 'package:flutter/material.dart';

// class RoommateMatchingPage extends StatefulWidget {
//   const RoommateMatchingPage({super.key});

//   @override
//   State<RoommateMatchingPage> createState() => _RoommateMatchingPageState();
// }

// class _RoommateMatchingPageState extends State<RoommateMatchingPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   String selectedDepartment = "";
//   List<String> selectedLifestyle = [];
//   bool showResults = false;

//   final List<String> departments = ["CSE", "EEE", "BBA", "English"];

//   final List<String> lifestyles = ["Study-focused", "Quiet", "Social"];

//   final List<Map<String, dynamic>> roommates = [
//     {
//       "name": "Rahim Ahmed",
//       "department": "CSE",
//       "lifestyle": "Quiet, Study-focused",
//     },
//     {"name": "Sadia Islam", "department": "CSE", "lifestyle": "Study-focused"},
//   ];

//   final List<Map<String, dynamic>> rooms = [
//     {
//       "hostel": "Green View Hostel",
//       "students": "2 CSE students already staying",
//       "rent": "3500",
//       "location": "Zindabazar",
//       "rating": 4.5,
//     },
//     {
//       "hostel": "Student Hub",
//       "students": "3 CSE students already staying",
//       "rent": "4000",
//       "location": "Amberkhana",
//       "rating": 4.7,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: primaryBlue),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Find Roommates",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// DEPARTMENT
//             Text(
//               "Select Your Department",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),
//             const SizedBox(height: 15),

//             Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: departments.map((dept) {
//                 bool isSelected = selectedDepartment == dept;

//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedDepartment = dept;
//                       showResults = false;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected ? primaryBlue : Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Text(
//                       dept,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : primaryBlue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 30),

//             /// LIFESTYLE
//             Text(
//               "Your Lifestyle",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),
//             const SizedBox(height: 15),

//             Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: lifestyles.map((life) {
//                 bool isSelected = selectedLifestyle.contains(life);

//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       if (isSelected) {
//                         selectedLifestyle.remove(life);
//                       } else if (selectedLifestyle.length < 2) {
//                         selectedLifestyle.add(life);
//                       }
//                       showResults = false;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected ? primaryBlue : Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Text(
//                       life,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : primaryBlue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 30),

//             /// BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (selectedDepartment.isNotEmpty) {
//                     setState(() => showResults = true);
//                   }
//                 },
//                 child: const Text(
//                   "Find Matches",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ),

//             if (showResults) ...[
//               const SizedBox(height: 35),

//               /// ROOMMATES (NO RATING)
//               Text(
//                 "Suggested Roommates",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: primaryBlue,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               Column(
//                 children: roommates.map((person) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 15),
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: primaryBlue,
//                           child: const Icon(
//                             Icons.person,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 person["name"],
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text("Department: ${person["department"]}"),
//                               Text("Lifestyle: ${person["lifestyle"]}"),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryBlue,
//                                 ),
//                                 onPressed: () {},
//                                 child: const Text(
//                                   "Request to Connect",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 35),

//               /// ROOMS (WITH RATING)
//               Text(
//                 "Rooms with Same Department Students",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: primaryBlue,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               Column(
//                 children: rooms.map((room) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 15),
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           room["hostel"],
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(room["students"]),
//                         const SizedBox(height: 5),
//                         Text("Tk ${room["rent"]}/month"),
//                         Text(room["location"]),

//                         const SizedBox(height: 8),

//                         /// ⭐ RATING ADDED HERE
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.star,
//                               color: Colors.orange,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 5),
//                             Text("${room["rating"]}"),
//                           ],
//                         ),

//                         const SizedBox(height: 15),

//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryBlue,
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "View Room",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'appdata_page.dart';
import 'hosteldetails_page.dart';

// IMPORTANT: replace these with your actual pages
import 'home_page.dart';
import 'review_page.dart';
import 'profile_page.dart';

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

  int currentIndex = 2;

  final List<String> departments = ["CSE", "EEE", "BBA", "English"];
  final List<String> lifestyles = ["Study-focused", "Quiet", "Social"];

  /// ROOMMATES FILTER (FIXED)
  List<Map<String, dynamic>> get filteredRoommates {
    return AppData.roommates.where((person) {
      final deptMatch =
          selectedDepartment.isEmpty ||
          person["department"].toString().toLowerCase() ==
              selectedDepartment.toLowerCase();

      final lifestyleMatch =
          selectedLifestyle.isEmpty ||
          selectedLifestyle.any(
            (l) => person["lifestyle"].toString().toLowerCase().contains(
              l.toLowerCase(),
            ),
          );

      return deptMatch && lifestyleMatch;
    }).toList();
  }

  /// ROOMS FILTER (FIXED)
  List<Map<String, dynamic>> get filteredRooms {
    return AppData.hostels.where((room) {
      final deptText = room["department"].toString().toLowerCase();

      return selectedDepartment.isEmpty ||
          deptText.contains(selectedDepartment.toLowerCase()) ||
          deptText.contains("all");
    }).toList();
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

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

    if (index == 2) {
      // already here (Match page)
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
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
        title: Text(
          "Find Roommates",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DEPARTMENT LABEL
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
                      showResults = false;
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

            /// LIFESTYLE LABEL
            Text(
              "Select Lifestyle",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 10),

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
                      showResults = false;
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

            /// FIND BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  setState(() {
                    showResults = true;
                  });
                },
                child: const Text(
                  "Find Matches",
                  style: TextStyle(fontSize: 18, color: Colors.white),
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

              filteredRoommates.isEmpty
                  ? const Text("Not found")
                  : Column(
                      children: filteredRoommates.map((person) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: primaryBlue,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(person["name"]),
                            subtitle: Text(
                              "${person["department"]} • ${person["lifestyle"]}",
                            ),
                          ),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 30),

              Text(
                "Rooms",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),

              filteredRooms.isEmpty
                  ? const Text("Not found")
                  : Column(
                      children: filteredRooms.map((room) {
                        return Card(
                          child: ListTile(
                            title: Text(room["name"]),
                            subtitle: Text(room["location"]),
                            trailing: Text("৳${room["price"]}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HostelDetailsPage(hostel: room),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ],
        ),
      ),

      /// BOTTOM NAV BAR (FULL WORKING)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
