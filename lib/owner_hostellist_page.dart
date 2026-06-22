// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'owner_addhostel_page.dart';
// import 'owner_dashboard_page.dart';
// import 'owner_profile_page.dart';
// import 'owner_room_occupancy_page.dart';

// class MyListingsPage extends StatefulWidget {
//   const MyListingsPage({super.key});

//   @override
//   State<MyListingsPage> createState() => _MyListingsPageState();
// }

// class _MyListingsPageState extends State<MyListingsPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   int currentIndex = 1;

//   T _get<T>(Map data, String key, T defaultValue) {
//     final val = data[key];
//     return (val is T) ? val : defaultValue;
//   }

//   String _statusText(String status) {
//     switch (status) {
//       case 'approved':
//         return 'APPROVED';
//       case 'rejected':
//         return 'REJECTED';
//       default:
//         return 'PENDING';
//     }
//   }

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.orange;
//     }
//   }

//   Future<void> _toggleAvailability(String docId, bool currentStatus) async {
//     try {
//       await FirebaseFirestore.instance.collection('hostels').doc(docId).update({
//         'is_available': !currentStatus,
//         'updated_at': FieldValue.serverTimestamp(),
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               !currentStatus
//                   ? "Hostel marked as Available"
//                   : "Hostel marked as Not Available",
//             ),
//             backgroundColor: !currentStatus ? Colors.green : Colors.grey[700],
//             duration: const Duration(seconds: 1),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   Future<void> _openIndexLink(String error) async {
//     final regex = RegExp(r'https://console\.firebase\.google\.com[^\s]+');
//     final match = regex.firstMatch(error);
//     if (match != null) {
//       final url = Uri.parse(match.group(0)!);
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//       }
//     }
//   }

//   Widget _chip(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: primaryBlue.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 10,
//           color: primaryBlue,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF5F7FA),
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//               );
//             },
//           ),
//           title: const Text(
//             "My Listings",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.white,
//           foregroundColor: primaryBlue,
//           elevation: 0.5,
//         ),
//         body: const Center(child: Text("Please login first")),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//             );
//           },
//         ),
//         title: const Text(
//           "My Listings",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: primaryBlue,
//         elevation: 0.5,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('hostels')
//             .where('owner_id', isEqualTo: user.uid)
//             .orderBy('updated_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: primaryBlue));
//           }

//           if (snapshot.hasError) {
//             if (snapshot.error.toString().contains('failed-precondition')) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.warning, size: 60, color: Colors.orange),
//                       const SizedBox(height: 16),
//                       Text(
//                         "Database Index Missing",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Need to create firebase index.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                       const SizedBox(height: 12),
//                       ElevatedButton.icon(
//                         onPressed: () =>
//                             _openIndexLink(snapshot.error.toString()),
//                         icon: const Icon(Icons.open_in_new),
//                         label: Text("Create Index Now"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryBlue,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.home_work_outlined,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No listings yet",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Add your first hostel to get started",
//                     style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const AddHostelPage(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.add),
//                     label: const Text("Add Hostel"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryBlue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final docs = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = Map<String, dynamic>.from(doc.data() as Map);
//               data['id'] = doc.id;

//               final status = _get<String>(data, 'status', 'pending');
//               final statusColor = _statusColor(status);
//               final statusText = _statusText(status);
//               final bool isAvailable = _get<bool>(data, 'is_available', true);
//               final String previousStatus = _get<String>(
//                 data,
//                 'previous_status',
//                 '',
//               );
//               final bool wasRejected =
//                   previousStatus == 'rejected' && status == 'pending';
//               final int rejectionCount = _get<int>(data, 'rejection_count', 0);
//               final String name = _get<String>(data, 'name', 'No Name');
//               final String location = _get<String>(
//                 data,
//                 'location',
//                 'No location',
//               );
//               final String buildingImage = _get<String>(
//                 data,
//                 'image_building',
//                 '',
//               );
//               final String area = _get<String>(data, 'area', '');

//               return FutureBuilder<QuerySnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('rooms')
//                     .where('hostel_id', isEqualTo: doc.id)
//                     .get(),
//                 builder: (context, roomSnapshot) {
//                   // ignore: unused_local_variable
//                   int availableRooms = 0;
//                   String? firstRoomImage;

//                   if (roomSnapshot.hasData &&
//                       roomSnapshot.data!.docs.isNotEmpty) {
//                     List<int> rents = [];
//                     for (var roomDoc in roomSnapshot.data!.docs) {
//                       final roomData = roomDoc.data() as Map;
//                       final int beds = _get<int>(roomData, 'beds', 1);
//                       final int booked = _get<int>(roomData, 'booked_beds', 0);
//                       final bool roomAvailable = _get<bool>(
//                         roomData,
//                         'is_available',
//                         true,
//                       );

//                       if (roomAvailable && booked < beds) {
//                         availableRooms++;
//                       }

//                       rents.add(_get<int>(roomData, 'monthly_rent', 0));
//                       if (firstRoomImage == null) {
//                         final imgs = _get<List>(roomData, 'room_images', []);
//                         if (imgs.isNotEmpty) firstRoomImage = imgs[0] as String;
//                       }
//                     }
//                     rents.sort();
//                   }

//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: buildingImage.isNotEmpty
//                                     ? Image.network(
//                                         buildingImage,
//                                         width: 70,
//                                         height: 70,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) =>
//                                             _placeholderIcon(Icons.home),
//                                       )
//                                     : firstRoomImage != null &&
//                                           firstRoomImage.isNotEmpty
//                                     ? Image.network(
//                                         firstRoomImage,
//                                         width: 70,
//                                         height: 70,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) =>
//                                             _placeholderIcon(Icons.bed),
//                                       )
//                                     : _placeholderIcon(Icons.home),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             name,
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.edit,
//                                             color: primaryBlue,
//                                             size: 22,
//                                           ),
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => AddHostelPage(
//                                                   hostel: data,
//                                                   isEditMode: true,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       location,
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     if (area.isNotEmpty) ...[
//                                       const SizedBox(height: 2),
//                                       Text(
//                                         area,
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[500],
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),

//                           Wrap(
//                             spacing: 6,
//                             runSpacing: 4,
//                             children: [
//                               if (data['wifi'] == true) _chip("WiFi"),
//                               if (data['security_cctv'] == true)
//                                 _chip("Security"),
//                               if (data['laundry'] == true) _chip("Laundry"),
//                               if (data['drinking_water'] == true)
//                                 _chip("Water"),
//                               if (data['meal_service'] == true) _chip("Meals"),
//                             ],
//                           ),
//                           const SizedBox(height: 10),

//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 5,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: statusColor.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Text(
//                                   statusText,
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: statusColor,
//                                   ),
//                                 ),
//                               ),

//                               if (status == 'pending' &&
//                                   previousStatus.isNotEmpty) ...[
//                                 const SizedBox(width: 8),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue.withOpacity(0.15),
//                                     borderRadius: BorderRadius.circular(6),
//                                     border: Border.all(
//                                       color: Colors.blue.withOpacity(0.3),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.history,
//                                         size: 12,
//                                         color: Colors.blue[700],
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         "Prev: ${previousStatus.toUpperCase()}",
//                                         style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.blue[700],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],

//                               if (wasRejected) ...[
//                                 const SizedBox(width: 8),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.orange.shade100,
//                                     borderRadius: BorderRadius.circular(6),
//                                     border: Border.all(
//                                       color: Colors.orange.shade300,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.refresh,
//                                         size: 12,
//                                         color: Colors.orange.shade700,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         "Resubmitted x$rejectionCount",
//                                         style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.orange.shade700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],

//                               const Spacer(),

//                               ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => OwnerRoomOccupancyPage(
//                                         hostelId: doc.id,
//                                         hostelName: name,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.bed, size: 16),
//                                 label: const Text("View Rooms"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryBlue,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   textStyle: const TextStyle(fontSize: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),

//                               if (status == 'approved') ...[
//                                 GestureDetector(
//                                   onTap: () =>
//                                       _toggleAvailability(doc.id, isAvailable),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 5,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isAvailable
//                                           ? Colors.green.shade100
//                                           : Colors.grey.shade200,
//                                       borderRadius: BorderRadius.circular(20),
//                                       border: Border.all(
//                                         color: isAvailable
//                                             ? Colors.green
//                                             : Colors.grey,
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           isAvailable
//                                               ? Icons.check_circle
//                                               : Icons.cancel,
//                                           size: 14,
//                                           color: isAvailable
//                                               ? Colors.green.shade700
//                                               : Colors.grey.shade700,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           isAvailable
//                                               ? "Available"
//                                               : "Not Available",
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                             color: isAvailable
//                                                 ? Colors.green.shade700
//                                                 : Colors.grey.shade700,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),

//                           if (status == 'pending' &&
//                               _get<String>(
//                                 data,
//                                 'last_rejection_note',
//                                 '',
//                               ).isNotEmpty) ...[
//                             const SizedBox(height: 8),
//                             _noteBox(
//                               Colors.orange,
//                               Icons.info_outline,
//                               "Last Admin Note:",
//                               data['last_rejection_note'],
//                             ),
//                           ],

//                           if (status == 'rejected' &&
//                               _get<String>(
//                                 data,
//                                 'last_rejection_note',
//                                 '',
//                               ).isNotEmpty) ...[
//                             const SizedBox(height: 8),
//                             _noteBox(
//                               Colors.red,
//                               Icons.block,
//                               "Rejection Reason:",
//                               data['last_rejection_note'],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) {
//           if (i == currentIndex) return;
//           setState(() => currentIndex = i);

//           Widget page;
//           if (i == 0) {
//             page = const OwnerDashboardPage();
//           } else if (i == 1)
//             page = const MyListingsPage();
//           else if (i == 2)
//             page = const AddHostelPage();
//           else
//             page = const OwnerProfilePage();

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_outlined),
//             activeIcon: Icon(Icons.dashboard),
//             label: "Dashboard",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt_outlined),
//             activeIcon: Icon(Icons.list_alt),
//             label: "Hostels",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle_outline),
//             activeIcon: Icon(Icons.add_circle),
//             label: "Add",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _placeholderIcon(IconData icon) {
//     return Container(
//       width: 70,
//       height: 70,
//       color: Colors.grey[300],
//       child: Icon(icon, color: Colors.grey[600]),
//     );
//   }

//   Widget _noteBox(Color color, IconData icon, String title, String note) {
//     final darkColor = color == Colors.orange
//         ? Colors.orange.shade700
//         : Colors.red.shade700;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 14, color: darkColor),
//               const SizedBox(width: 4),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.bold,
//                   color: darkColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(note, style: TextStyle(fontSize: 11, color: darkColor)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'owner_addhostel_page.dart';
import 'owner_dashboard_page.dart';
import 'owner_profile_page.dart';
import 'owner_room_occupancy_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final Color primaryBlue = const Color(0xFF003366);
  int currentIndex = 1;

  T _get<T>(Map data, String key, T defaultValue) {
    final val = data[key];
    return (val is T) ? val : defaultValue;
  }

  String _statusText(String status) {
    switch (status) {
      case 'approved':
        return 'APPROVED';
      case 'rejected':
        return 'REJECTED';
      default:
        return 'PENDING';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _toggleAvailability(String docId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('hostels').doc(docId).update({
        'is_available': !currentStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !currentStatus
                  ? "Hostel marked as Available"
                  : "Hostel marked as Not Available",
            ),
            backgroundColor: !currentStatus ? Colors.green : Colors.grey[700],
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _openIndexLink(String error) async {
    final regex = RegExp(r'https://console\.firebase\.google\.com[^\s]+');
    final match = regex.firstMatch(error);
    if (match != null) {
      final url = Uri.parse(match.group(0)!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
              );
            },
          ),
          title: const Text(
            "My Listings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: primaryBlue,
          elevation: 0.5,
        ),
        body: const Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
            );
          },
        ),
        title: const Text(
          "My Listings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0.5,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hostels')
            .where('owner_id', isEqualTo: user.uid)
            .orderBy('updated_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryBlue));
          }

          if (snapshot.hasError) {
            if (snapshot.error.toString().contains('failed-precondition')) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, size: 60, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        "Database Index Missing",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Need to create firebase index.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _openIndexLink(snapshot.error.toString()),
                        icon: const Icon(Icons.open_in_new),
                        label: Text("Create Index Now"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No listings yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your first hostel to get started",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddHostelPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Hostel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = Map<String, dynamic>.from(doc.data() as Map);
              data['id'] = doc.id;

              final status = _get<String>(data, 'status', 'pending');
              final statusColor = _statusColor(status);
              final statusText = _statusText(status);
              final bool isAvailable = _get<bool>(data, 'is_available', true);
              final String previousStatus = _get<String>(
                data,
                'previous_status',
                '',
              );
              final bool wasRejected =
                  previousStatus == 'rejected' && status == 'pending';
              final int rejectionCount = _get<int>(data, 'rejection_count', 0);
              final String name = _get<String>(data, 'name', 'No Name');
              final String location = _get<String>(
                data,
                'location',
                'No location',
              );
              final String buildingImage = _get<String>(
                data,
                'image_building',
                '',
              );
              final String area = _get<String>(data, 'area', '');

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('rooms')
                    .where('hostel_id', isEqualTo: doc.id)
                    .get(),
                builder: (context, roomSnapshot) {
                  // ignore: unused_local_variable
                  int availableRooms = 0;
                  String? firstRoomImage;

                  if (roomSnapshot.hasData &&
                      roomSnapshot.data!.docs.isNotEmpty) {
                    List<int> rents = [];
                    for (var roomDoc in roomSnapshot.data!.docs) {
                      final roomData = roomDoc.data() as Map;
                      final int beds = _get<int>(roomData, 'beds', 1);
                      final int booked = _get<int>(roomData, 'booked_beds', 0);
                      final bool roomAvailable = _get<bool>(
                        roomData,
                        'is_available',
                        true,
                      );

                      if (roomAvailable && booked < beds) {
                        availableRooms++;
                      }

                      rents.add(_get<int>(roomData, 'monthly_rent', 0));
                      if (firstRoomImage == null) {
                        final imgs = _get<List>(roomData, 'room_images', []);
                        if (imgs.isNotEmpty) firstRoomImage = imgs[0] as String;
                      }
                    }
                    rents.sort();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: buildingImage.isNotEmpty
                                    ? Image.network(
                                        buildingImage,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _placeholderIcon(Icons.home),
                                      )
                                    : firstRoomImage != null &&
                                          firstRoomImage.isNotEmpty
                                    ? Image.network(
                                        firstRoomImage,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _placeholderIcon(Icons.bed),
                                      )
                                    : _placeholderIcon(Icons.home),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: primaryBlue,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AddHostelPage(
                                                  hostel: data,
                                                  isEditMode: true,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // ADDITION: Toggle button after pen
                                        if (status == 'approved')
                                          Switch(
                                            value: isAvailable,
                                            activeColor: Colors.green,
                                            onChanged: (val) =>
                                                _toggleAvailability(
                                                  doc.id,
                                                  isAvailable,
                                                ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      location,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (area.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        area,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (data['wifi'] == true) _chip("WiFi"),
                              if (data['security_cctv'] == true)
                                _chip("Security"),
                              if (data['laundry'] == true) _chip("Laundry"),
                              if (data['drinking_water'] == true)
                                _chip("Water"),
                              if (data['meal_service'] == true) _chip("Meals"),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),

                              if (status == 'pending' &&
                                  previousStatus.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 12,
                                        color: Colors.blue[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Prev: ${previousStatus.toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              if (wasRejected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.orange.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 12,
                                        color: Colors.orange.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Resubmitted x$rejectionCount",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const Spacer(),

                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OwnerRoomOccupancyPage(
                                        hostelId: doc.id,
                                        hostelName: name,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.bed, size: 16),
                                label: const Text("View Rooms"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              if (status == 'approved') ...[
                                GestureDetector(
                                  onTap: () =>
                                      _toggleAvailability(doc.id, isAvailable),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? Colors.green.shade100
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isAvailable
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isAvailable
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          size: 14,
                                          color: isAvailable
                                              ? Colors.green.shade700
                                              : Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isAvailable
                                              ? "Available"
                                              : "Not Available",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isAvailable
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          if (status == 'pending' &&
                              _get<String>(
                                data,
                                'last_rejection_note',
                                '',
                              ).isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _noteBox(
                              Colors.orange,
                              Icons.info_outline,
                              "Last Admin Note:",
                              data['last_rejection_note'],
                            ),
                          ],

                          if (status == 'rejected' &&
                              _get<String>(
                                data,
                                'last_rejection_note',
                                '',
                              ).isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _noteBox(
                              Colors.red,
                              Icons.block,
                              "Rejection Reason:",
                              data['last_rejection_note'],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == currentIndex) return;
          setState(() => currentIndex = i);

          Widget page;
          if (i == 0) {
            page = const OwnerDashboardPage();
          } else if (i == 1)
            page = const MyListingsPage();
          else if (i == 2)
            page = const AddHostelPage();
          else
            page = const OwnerProfilePage();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "Hostels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _placeholderIcon(IconData icon) {
    return Container(
      width: 70,
      height: 70,
      color: Colors.grey[300],
      child: Icon(icon, color: Colors.grey[600]),
    );
  }

  Widget _noteBox(Color color, IconData icon, String title, String note) {
    final darkColor = color == Colors.orange
        ? Colors.orange.shade700
        : Colors.red.shade700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: darkColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(note, style: TextStyle(fontSize: 11, color: darkColor)),
        ],
      ),
    );
  }
}
