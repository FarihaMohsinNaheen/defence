// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'hosteldetails_page.dart';

// class SavedHostelsPage extends StatefulWidget {
//   const SavedHostelsPage({super.key});

//   @override
//   State<SavedHostelsPage> createState() => _SavedHostelsPageState();
// }

// class _SavedHostelsPageState extends State<SavedHostelsPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFEAF4FF),
//         body: Center(child: Text("Please login first")),
//       );
//     }

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
//           "Saved Hostels ❤️",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         // FIX: users/{uid}/saved_hostels subcollection theke direct stream
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .collection('saved_hostels')
//             .orderBy('saved_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
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
//                   const SizedBox(height: 8),
//                   Text(
//                     "Save hostels to see them here",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final savedDocs = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: savedDocs.length,
//             itemBuilder: (context, index) {
//               final data = savedDocs[index].data() as Map<String, dynamic>;
//               // HostelDetailsPage e...widget.hostel spread korsila, tai full data ache

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 18),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                       child: Image.network(
//                         data["image_building"] ?? data["image"] ?? "",
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 180,
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.home, size: 50),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data["name"] ?? "",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             data["location"] ?? "",
//                             style: TextStyle(color: Colors.grey[700]),
//                           ),
//                           if (data["area"] != null &&
//                               data["area"].toString().isNotEmpty) ...[
//                             const SizedBox(height: 2),
//                             Text(
//                               'Area: ${data["area"]}',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                           const SizedBox(height: 8),
//                           Text(
//                             "Tk ${data["monthly_rent"] ?? data["rent"] ?? 0}/month",
//                             style: TextStyle(
//                               color: primaryBlue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 17,
//                             ),
//                           ),
//                           const SizedBox(height: 18),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                   ),
//                                   onPressed: () => removeSaved(data["id"]),
//                                   child: const Text(
//                                     "Remove ❌",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryBlue,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) =>
//                                             HostelDetailsPage(hostel: data),
//                                       ),
//                                     );
//                                   },
//                                   child: const Text(
//                                     "View Details",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> removeSaved(String hostelId) async {
//     if (user == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .collection('saved_hostels')
//         .doc(hostelId)
//         .delete();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Removed from saved'),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'hosteldetails_page.dart';

class SavedHostelorRoomPage extends StatefulWidget {
  const SavedHostelorRoomPage({super.key});

  @override
  State<SavedHostelorRoomPage> createState() => _SavedHostelorRoomPageState();
}

class _SavedHostelorRoomPageState extends State<SavedHostelorRoomPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFEAF4FF),
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Saved Hostel / Room ❤️", // changed name
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          // 1. Get saved hostels
          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('saved_hostels')
              .orderBy('saved_at', descending: true)
              .get(),
          // 2. Get saved rooms
          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('saved_rooms')
              .orderBy('saved_at', descending: true)
              .get(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final hostelDocs = snapshot.data![0].docs;
          final roomDocs = snapshot.data![1].docs;

          if (hostelDocs.isEmpty && roomDocs.isEmpty) {
            return Center(
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
                    "No Saved Items",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Save hostels or rooms to see them here",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // Combine both lists and sort by saved_at
          final allItems = [
            ...hostelDocs.map((d) => {'type': 'hostel', 'data': d.data()}),
            ...roomDocs.map((d) => {'type': 'room', 'data': d.data()}),
          ];

          allItems.sort((a, b) {
            Timestamp aTime = (a['data'] as Map)['saved_at'] ?? Timestamp.now();
            Timestamp bTime = (b['data'] as Map)['saved_at'] ?? Timestamp.now();
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              if (item['type'] == 'hostel') {
                return _buildHostelCard(item['data'] as Map<String, dynamic>);
              } else {
                return _buildRoomCard(item['data'] as Map<String, dynamic>);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildHostelCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              data["image_building"] ?? data["image"] ?? "",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.home, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data["location"] ?? "",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                if (data["area"] != null &&
                    data["area"].toString().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Area: ${data["area"]}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  "Tk ${data["monthly_rent"] ?? data["rent"] ?? 0}/month",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () =>
                            removeSaved(data["id"], 'saved_hostels'),
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
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HostelDetailsPage(hostel: data),
                            ),
                          );
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
  }

  Widget _buildRoomCard(Map<String, dynamic> data) {
    final List images = data["room_images"] ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              images.isNotEmpty ? images[0] : "",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.bed, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data["hostel_name"] ?? "Hostel"} - Room ${data["room_number"] ?? ""}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Type: ${data["room_type"] ?? ""}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 2),
                Text(
                  "Beds: ${data["beds"] ?? 1}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tk ${data["monthly_rent"] ?? data["rent"] ?? 0}/month",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () =>
                            removeSaved(data["room_id"], 'saved_rooms'),
                        child: const Text(
                          "Remove ❌",
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
  }

  Future<void> removeSaved(String id, String collection) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(collection)
        .doc(id)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from saved'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
