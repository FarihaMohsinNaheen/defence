// import 'package:flutter/material.dart';

// class HostelDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> hostel;

//   const HostelDetailsPage({super.key, required this.hostel});

//   @override
//   Widget build(BuildContext context) {
//     final Color primaryBlue = const Color(0xFF003366);

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// TOP IMAGE
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25),
//                     ),
//                     child: Image.network(
//                       hostel["image"] ?? "https://via.placeholder.com/400",
//                       height: 280,
//                       width: double.infinity,
//                       fit: BoxFit.contain,
//                     ),
//                   ),

//                   Positioned(
//                     top: 15,
//                     left: 15,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back, color: primaryBlue),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ),

//                   Positioned(
//                     top: 15,
//                     right: 15,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.favorite_border, color: primaryBlue),
//                     ),
//                   ),
//                 ],
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// NAME
//                     Text(
//                       hostel["name"] ?? "No Name",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: primaryBlue,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     /// LOCATION
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: primaryBlue, size: 20),
//                         const SizedBox(width: 5),
//                         Text(
//                           hostel["location"] ?? "No Location",
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 15),

//                     /// VERIFIED
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: primaryBlue,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         "Verified Hostel",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),

//                     /// PRICE + RATING
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Monthly Rent",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "Tk ${hostel["price"] ?? 0}",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: primaryBlue,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Rating",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             const SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 const Icon(Icons.star, color: Colors.orange),
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   "${hostel["rating"] ?? 0}",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),

//                     /// ROOM DETAILS
//                     sectionTitle("Room Details", primaryBlue),
//                     const SizedBox(height: 12),

//                     detailsCard(
//                       Icons.bed,
//                       "Room Type",
//                       hostel["roomType"] ?? "N/A",
//                     ),

//                     detailsCard(
//                       Icons.people,
//                       "Capacity",
//                       hostel["capacity"] ?? "N/A",
//                     ),

//                     detailsCard(
//                       Icons.school,
//                       "Department Preference",
//                       hostel["department"] ?? "N/A",
//                     ),

//                     const SizedBox(height: 25),

//                     /// FACILITIES
//                     sectionTitle("Facilities", primaryBlue),
//                     const SizedBox(height: 15),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         facilityBox(
//                           Icons.wifi,
//                           "WiFi",
//                           primaryBlue,
//                           hostel["wifi"] == true,
//                         ),
//                         facilityBox(
//                           Icons.local_dining,
//                           "Meals",
//                           primaryBlue,
//                           hostel["meals"] == true,
//                         ),
//                         facilityBox(
//                           Icons.security,
//                           "Security",
//                           primaryBlue,
//                           hostel["security"] == true,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),

//                     /// EXPERIENCE
//                     sectionTitle("Student Experience", primaryBlue),
//                     const SizedBox(height: 10),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         hostel["experience"] ??
//                             "No student feedback available.",
//                         style: const TextStyle(fontSize: 15, height: 1.5),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     /// BUTTONS
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryBlue,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "Contact Owner",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "Book Now",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// SECTION TITLE
//   Widget sectionTitle(String title, Color color) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
//     );
//   }

//   /// DETAILS CARD
//   Widget detailsCard(IconData icon, String title, String value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: const Color(0xFF003366)),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// FACILITY BOX
//   Widget facilityBox(IconData icon, String title, Color color, bool active) {
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         color: active ? Colors.white : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: active ? color : Colors.grey, size: 32),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               color: active ? color : Colors.grey,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'appdata_page.dart';

// class HostelDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> hostel;

//   const HostelDetailsPage({super.key, required this.hostel});

//   @override
//   State<HostelDetailsPage> createState() => _HostelDetailsPageState();
// }

// class _HostelDetailsPageState extends State<HostelDetailsPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   bool isSaved = false;
//   @override
//   void initState() {
//     super.initState();

//     isSaved = AppData.savedHostels.any((h) => h["id"] == widget.hostel["id"]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               /// TOP IMAGE
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25),
//                     ),
//                     child: Image.network(
//                       widget.hostel["image"] ??
//                           "https://via.placeholder.com/400",
//                       height: 280,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),

//                   /// BACK BUTTON
//                   Positioned(
//                     top: 15,
//                     left: 15,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back, color: primaryBlue),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ),

//                   /// SAVE BUTTON
//                   Positioned(
//                     top: 15,
//                     right: 15,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: IconButton(
//                         icon: Icon(
//                           isSaved ? Icons.favorite : Icons.favorite_border,
//                           color: isSaved ? Colors.red : primaryBlue,
//                         ),

//                         onPressed: () {
//                           setState(() {
//                             final exists = AppData.savedHostels.any(
//                               (h) => h["id"] == widget.hostel["id"],
//                             );

//                             if (exists) {
//                               AppData.savedHostels.removeWhere(
//                                 (h) => h["id"] == widget.hostel["id"],
//                               );
//                               isSaved = false;
//                             } else {
//                               AppData.savedHostels.add(widget.hostel);
//                               isSaved = true;
//                             }
//                           });

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: primaryBlue,
//                               content: Text(
//                                 isSaved
//                                     ? "Hostel Saved Successfully ❤️"
//                                     : "Hostel Removed",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,

//                   children: [
//                     Text(
//                       widget.hostel["name"] ?? "No Name",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: primaryBlue,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: primaryBlue, size: 20),
//                         const SizedBox(width: 5),
//                         Text(
//                           widget.hostel["location"] ?? "No Location",
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 15),

//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: primaryBlue,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         "Verified Hostel",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Monthly Rent",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "Tk ${widget.hostel["price"] ?? 0}",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: primaryBlue,
//                               ),
//                             ),
//                           ],
//                         ),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Rating",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             const SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 const Icon(Icons.star, color: Colors.orange),
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   "${widget.hostel["rating"] ?? 0}",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),

//                     sectionTitle("Room Details", primaryBlue),
//                     const SizedBox(height: 12),

//                     detailsCard(
//                       Icons.bed,
//                       "Room Type",
//                       widget.hostel["roomType"] ?? "N/A",
//                     ),
//                     detailsCard(
//                       Icons.people,
//                       "Capacity",
//                       widget.hostel["capacity"] ?? "N/A",
//                     ),
//                     detailsCard(
//                       Icons.school,
//                       "Department Preference",
//                       widget.hostel["department"] ?? "N/A",
//                     ),

//                     const SizedBox(height: 25),

//                     sectionTitle("Facilities", primaryBlue),
//                     const SizedBox(height: 15),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         facilityBox(
//                           Icons.wifi,
//                           "WiFi",
//                           primaryBlue,
//                           widget.hostel["wifi"] == true,
//                         ),
//                         facilityBox(
//                           Icons.local_dining,
//                           "Meals",
//                           primaryBlue,
//                           widget.hostel["meals"] == true,
//                         ),
//                         facilityBox(
//                           Icons.security,
//                           "Security",
//                           primaryBlue,
//                           widget.hostel["security"] == true,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),

//                     sectionTitle("Student Experience", primaryBlue),
//                     const SizedBox(height: 10),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         widget.hostel["experience"] ??
//                             "No student feedback available.",
//                         style: const TextStyle(fontSize: 15, height: 1.5),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryBlue,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "Contact Owner",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "Book Now",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget sectionTitle(String title, Color color) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
//     );
//   }

//   Widget detailsCard(IconData icon, String title, String value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: primaryBlue),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget facilityBox(IconData icon, String title, Color color, bool active) {
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         color: active ? Colors.white : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: active ? color : Colors.grey, size: 32),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               color: active ? color : Colors.grey,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'appdata_page.dart';

class HostelDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hostel;

  const HostelDetailsPage({super.key, required this.hostel});

  @override
  State<HostelDetailsPage> createState() => _HostelDetailsPageState();
}

class _HostelDetailsPageState extends State<HostelDetailsPage> {
  final Color primaryBlue = const Color(0xFF003366);

  bool isSaved = false;

  @override
  void initState() {
    super.initState();

    isSaved = AppData.savedHostels.any((h) => h["id"] == widget.hostel["id"]);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ REAL-TIME SYNC FIX (IMPORTANT)
    final bool currentSavedState = AppData.savedHostels.any(
      (h) => h["id"] == widget.hostel["id"],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TOP IMAGE
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Image.network(
                      widget.hostel["image"] ??
                          "https://via.placeholder.com/400",
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// BACK BUTTON
                  Positioned(
                    top: 15,
                    left: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: primaryBlue),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  /// SAVE BUTTON
                  Positioned(
                    top: 15,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          currentSavedState
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: currentSavedState ? Colors.red : primaryBlue,
                        ),

                        onPressed: () {
                          setState(() {
                            final exists = AppData.savedHostels.any(
                              (h) => h["id"] == widget.hostel["id"],
                            );

                            if (exists) {
                              AppData.savedHostels.removeWhere(
                                (h) => h["id"] == widget.hostel["id"],
                              );
                              isSaved = false;
                            } else {
                              AppData.savedHostels.add(widget.hostel);
                              isSaved = true;
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: primaryBlue,
                              content: Text(
                                currentSavedState
                                    ? "Hostel Removed from saved list"
                                    : "Hostel Saved Successfully ❤️",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      widget.hostel["name"] ?? "No Name",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.location_on, color: primaryBlue, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          widget.hostel["location"] ?? "No Location",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Verified Hostel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Monthly Rent",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Tk ${widget.hostel["price"] ?? 0}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange),
                                const SizedBox(width: 5),
                                Text(
                                  "${widget.hostel["rating"] ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    sectionTitle("Room Details", primaryBlue),
                    const SizedBox(height: 12),

                    detailsCard(
                      Icons.bed,
                      "Room Type",
                      widget.hostel["roomType"] ?? "N/A",
                    ),
                    detailsCard(
                      Icons.people,
                      "Capacity",
                      widget.hostel["capacity"] ?? "N/A",
                    ),
                    detailsCard(
                      Icons.school,
                      "Department Preference",
                      widget.hostel["department"] ?? "N/A",
                    ),

                    const SizedBox(height: 25),

                    sectionTitle("Facilities", primaryBlue),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        facilityBox(
                          Icons.wifi,
                          "WiFi",
                          primaryBlue,
                          widget.hostel["wifi"] == true,
                        ),
                        facilityBox(
                          Icons.local_dining,
                          "Meals",
                          primaryBlue,
                          widget.hostel["meals"] == true,
                        ),
                        facilityBox(
                          Icons.security,
                          "Security",
                          primaryBlue,
                          widget.hostel["security"] == true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    sectionTitle("Student Experience", primaryBlue),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.hostel["experience"] ??
                            "No student feedback available.",
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Contact Owner",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Book Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget detailsCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget facilityBox(IconData icon, String title, Color color, bool active) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? color : Colors.grey, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: active ? color : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
