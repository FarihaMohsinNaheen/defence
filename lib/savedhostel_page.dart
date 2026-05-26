// import 'package:flutter/material.dart';

// import 'hosteldetails_page.dart';
// import 'home_page.dart';
// import 'review_page.dart';
// import 'profile_page.dart';
// import 'roommatematcher_page.dart';

// class SavedHostelsPage extends StatefulWidget {
//   const SavedHostelsPage({super.key});

//   @override
//   State<SavedHostelsPage> createState() => _SavedHostelsPageState();
// }

// class _SavedHostelsPageState extends State<SavedHostelsPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   int currentIndex = 0;

//   List<Map<String, dynamic>> savedHostels = [
//     {
//       "name": "Green View Hostel",
//       "location": "Zindabazar",
//       "price": 3500,
//       "rating": 4.5,
//       "image": "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
//     },

//     {
//       "name": "Student Hub",
//       "location": "Amberkhana",
//       "price": 2500,
//       "rating": 4.2,
//       "image": "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
//     },

//     {
//       "name": "Elite Boys Hostel",
//       "location": "Mirabazar",
//       "price": 5000,
//       "rating": 4.8,
//       "image": "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
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

//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),

//         title: Text(
//           "Saved Hostels ❤️",

//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       /// BOTTOM NAV BAR
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,

//         selectedItemColor: primaryBlue,

//         unselectedItemColor: Colors.grey,

//         type: BottomNavigationBarType.fixed,

//         onTap: (i) {
//           setState(() {
//             currentIndex = i;
//           });

//           /// HOME
//           if (i == 0) {
//             Navigator.pushReplacement(
//               context,

//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           }
//           /// REVIEW
//           else if (i == 1) {
//             Navigator.push(
//               context,

//               MaterialPageRoute(builder: (_) => const ReviewPage()),
//             );
//           }
//           /// MATCH
//           else if (i == 2) {
//             Navigator.push(
//               context,

//               MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
//             );
//           }
//           /// PROFILE
//           else if (i == 3) {
//             Navigator.push(
//               context,

//               MaterialPageRoute(builder: (_) => const ProfilePage()),
//             );
//           }
//         },

//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

//           BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),

//           BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),

//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),

//       body: savedHostels.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,

//                 children: [
//                   Icon(
//                     Icons.favorite_border,
//                     size: 90,
//                     color: Colors.grey.shade400,
//                   ),

//                   const SizedBox(height: 15),

//                   const Text(
//                     "No Saved Hostels",

//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),

//               itemCount: savedHostels.length,

//               itemBuilder: (context, index) {
//                 final hostel = savedHostels[index];

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 18),

//                   decoration: BoxDecoration(
//                     color: Colors.white,

//                     borderRadius: BorderRadius.circular(20),
//                   ),

//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       /// IMAGE
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(20),
//                         ),

//                         child: Image.network(
//                           hostel["image"],

//                           height: 180,

//                           width: double.infinity,

//                           fit: BoxFit.cover,
//                         ),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.all(15),

//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,

//                           children: [
//                             /// NAME
//                             Text(
//                               hostel["name"],

//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             const SizedBox(height: 5),

//                             /// LOCATION
//                             Text(hostel["location"]),

//                             const SizedBox(height: 8),

//                             /// RATING
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   color: Colors.orange,
//                                   size: 20,
//                                 ),

//                                 const SizedBox(width: 4),

//                                 Text(
//                                   "${hostel["rating"]}",

//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 8),

//                             /// PRICE
//                             Text(
//                               "Tk ${hostel["price"]}/month",

//                               style: TextStyle(
//                                 color: primaryBlue,

//                                 fontWeight: FontWeight.bold,

//                                 fontSize: 17,
//                               ),
//                             ),

//                             const SizedBox(height: 18),

//                             /// BUTTONS
//                             Row(
//                               children: [
//                                 /// REMOVE
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,

//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 14,
//                                       ),

//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                     ),

//                                     onPressed: () {
//                                       setState(() {
//                                         savedHostels.removeAt(index);
//                                       });
//                                     },

//                                     child: const Text(
//                                       "Remove ❌",

//                                       style: TextStyle(
//                                         color: Colors.white,

//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(width: 12),

//                                 /// DETAILS
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: primaryBlue,

//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 14,
//                                       ),

//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                     ),

//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,

//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               HostelDetailsPage(hostel: hostel),
//                                         ),
//                                       );
//                                     },

//                                     child: const Text(
//                                       "View Details",

//                                       style: TextStyle(
//                                         color: Colors.white,

//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'appdata_page.dart';
import 'hosteldetails_page.dart';

class SavedHostelsPage extends StatefulWidget {
  const SavedHostelsPage({super.key});

  @override
  State<SavedHostelsPage> createState() => _SavedHostelsPageState();
}

class _SavedHostelsPageState extends State<SavedHostelsPage> {
  final Color primaryBlue = const Color(0xFF003366);

  int currentIndex = 0;
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
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Saved Hostels ❤️",

          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      body: AppData.savedHostels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.favorite_border,

                    size: 90,

                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "No Saved Hostels",

                    style: TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,

                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: AppData.savedHostels.length,

              itemBuilder: (context, index) {
                final hostel = AppData.savedHostels[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),

                        child: Image.network(
                          hostel["image"],

                          height: 180,

                          width: double.infinity,

                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            /// NAME
                            Text(
                              hostel["name"],

                              style: const TextStyle(
                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            /// LOCATION
                            Text(hostel["location"]),

                            const SizedBox(height: 8),

                            /// RATING
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,

                                  color: Colors.orange,

                                  size: 20,
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  "${hostel["rating"]}",

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// PRICE
                            Text(
                              "Tk ${hostel["price"]}/month",

                              style: TextStyle(
                                color: primaryBlue,

                                fontWeight: FontWeight.bold,

                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// BUTTONS
                            Row(
                              children: [
                                /// REMOVE
                                Expanded(
                                  child: ElevatedButton(
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
                                      setState(() {
                                        AppData.savedHostels.removeAt(index);
                                      });
                                    },

                                    child: const Text(
                                      "Remove ❌",

                                      style: TextStyle(
                                        color: Colors.white,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// VIEW DETAILS
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,

                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),

                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              HostelDetailsPage(hostel: hostel),
                                        ),
                                      );

                                      setState(() {});
                                    },

                                    child: const Text(
                                      "View Details",

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
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
