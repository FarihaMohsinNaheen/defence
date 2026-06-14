// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'booking_page.dart';
// import 'chat_page.dart';

// class RoomDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> room;
//   final String roomId;
//   final Map<String, dynamic> hostel;
//   final String ownerId;
//   final String ownerName;

//   const RoomDetailsPage({
//     super.key,
//     required this.room,
//     required this.roomId,
//     required this.hostel,
//     required this.ownerId,
//     required this.ownerName,

//   });

//   @override
//   State<RoomDetailsPage> createState() => _RoomDetailsPageState();
// }

// class _RoomDetailsPageState extends State<RoomDetailsPage> {
//   bool isSaved = false;
//   String businessName = ''; // notun variable
//   final Color primaryBlue = const Color(0xFF003366);

//   String s(dynamic val, [String def = '']) => val?.toString() ?? def;
//   int i(dynamic val, [int def = 0]) {
//     if (val is int) return val;
//     if (val is double) return val.toInt();
//     if (val is String) return int.tryParse(val) ?? def;
//     return def;
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkIfSaved();
//     fetchOwnerBusinessName(); // owner er businessName tanbo
//   }

//   Future<void> fetchOwnerBusinessName() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.ownerId)
//         .get();
//     if (mounted && doc.exists) {
//       setState(() {
//         businessName = s(doc.data()?['businessName'], widget.ownerName);
//       });
//     }
//   }

//   Future<void> checkIfSaved() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('saved_rooms')
//         .doc(widget.roomId)
//         .get();
//     if (mounted) setState(() => isSaved = doc.exists);
//   }

//   Future<void> _toggleSaveRoom() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     final ref = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('saved_rooms')
//         .doc(widget.roomId);

//     if (isSaved) {
//       await ref.delete();
//       if (!mounted) return;
//       setState(() => isSaved = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Room removed from saved'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } else {
//       await ref.set({
//         'room_id': widget.roomId,
//         'saved_at': FieldValue.serverTimestamp(),
//         ...Map<String, dynamic>.from(widget.room),
//         'hostel_name': widget.hostel['name'],
//         'hostel_id': widget.hostel['id'],
//       });
//       if (!mounted) return;
//       setState(() => isSaved = true);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Room ${s(widget.room['room_number'])} saved successfully',
//           ),
//           backgroundColor: primaryBlue,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String roomNumber = s(widget.room['room_number'], 'Room');
//     final String roomType = s(widget.room['room_type'], 'Single');
//     final int rent = i(
//       widget.room['monthly_rent'] ??
//           widget.room['rent'] ??
//           widget.room['price'] ??
//           0,
//     );

//     void showGenderError(String message) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Booking Not Allowed"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }

//     final int totalBeds = i(widget.room['beds'], 1);
//     final int bookedBeds = i(widget.room['booked_beds'], 0);
//     final List images = widget.room['room_images'] ?? [];
//     final String hostelName = s(widget.hostel['name'], 'Hostel');
//     final String hostelId = s(widget.hostel['id']);

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         title: Text(
//           "Room $roomNumber",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: Icon(
//               isSaved ? Icons.favorite : Icons.favorite_border,
//               color: isSaved ? Colors.red : Colors.white,
//             ),
//             onPressed: _toggleSaveRoom,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (images.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   images[0],
//                   height: 220,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 220,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.bed, size: 60),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             Text(
//               "Room $roomNumber",
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Tk $rent / month",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: primaryBlue,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Type: $roomType",
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Beds: $totalBeds",
//                   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                 ),
//                 Text(
//                   bookedBeds >= totalBeds
//                       ? "Not Available"
//                       : "Booked Beds: $bookedBeds",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: bookedBeds >= totalBeds
//                         ? Colors.grey[600]
//                         : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () async {
//                   final currentUser = FirebaseAuth.instance.currentUser;
//                   if (currentUser == null) return;

//                   // 1. Get current user gender from Firestore
//                   final userDoc = await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(currentUser.uid)
//                       .get();
//                   final userGender = s(
//                     userDoc.data()?['gender'],
//                   ); // 'Male' or 'Female'

//                   // 2. Get hostel type from widget.hostel
//                   final hostelType = s(
//                     widget.hostel['hostel_type'],
//                   ); // 'Boys' or 'Girls'

//                   // 3. Check and block if mismatch
//                   if (hostelType == "Boys" && userGender == "Female") {
//                     showGenderError(
//                       "This is a Boys hostel. Female users cannot book.",
//                     );
//                     return;
//                   }

//                   if (hostelType == "Girls" && userGender == "Male") {
//                     showGenderError(
//                       "This is a Girls hostel. Male users cannot book.",
//                     );
//                     return;
//                   }
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BookingPage(
//                         room: widget.room,
//                         roomId: widget.roomId,
//                         hostel: widget.hostel,
//                         ownerId: widget.ownerId,
//                         hostelName: hostelName,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Book Now",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: primaryBlue, width: 2),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () async {
//                   final currentUser = FirebaseAuth.instance.currentUser;
//                   if (currentUser == null) return;

//                   final chatId =
//                       '${currentUser.uid}_${widget.ownerId}_$hostelId';

//                   await FirebaseFirestore.instance
//                       .collection('chats')
//                       .doc(chatId)
//                       .set({
//                         'participants': [currentUser.uid, widget.ownerId],
//                         'studentId': currentUser.uid,
//                         'ownerId': widget.ownerId,
//                         'hostelId': hostelId,
//                         'hostelName': hostelName,
//                         'ownerName': businessName, // business name save
//                         'roomNumber': roomNumber,
//                         'lastMessage': '',
//                         'lastMessageTime': FieldValue.serverTimestamp(),
//                       }, SetOptions(merge: true));

//                   if (!mounted) return;
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatPage(
//                         chatId: chatId,
//                         otherUserId: widget.ownerId,
//                         otherUserName: businessName, // upore Nestify Properties
//                         hostel_id: hostelId,
//                         hostelName: hostelName,
//                         room_number: roomNumber,
//                         otherUserSubtitle: hostelName, // niche Green View
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Chat with Owner",
//                   style: TextStyle(
//                     color: primaryBlue,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_page.dart';
import 'chat_page.dart';

class RoomDetailsPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final String roomId;
  final Map<String, dynamic> hostel;
  final String ownerId;
  final String ownerName;

  const RoomDetailsPage({
    super.key,
    required this.room,
    required this.roomId,
    required this.hostel,
    required this.ownerId,
    required this.ownerName,
  });

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  bool isSaved = false;
  String businessName = ''; // notun variable
  final Color primaryBlue = const Color(0xFF003366);

  String s(dynamic val, [String def = '']) => val?.toString() ?? def;
  int i(dynamic val, [int def = 0]) {
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? def;
    return def;
  }

  String getChatId(String uid1, String uid2) {
    // <-- ADD THIS
    var ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  @override
  void initState() {
    super.initState();
    checkIfSaved();
    fetchOwnerBusinessName(); // owner er businessName tanbo
  }

  Future<void> fetchOwnerBusinessName() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.ownerId)
        .get();
    if (mounted && doc.exists) {
      setState(() {
        businessName = s(doc.data()?['businessName'], widget.ownerName);
      });
    }
  }

  Future<void> checkIfSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_rooms')
        .doc(widget.roomId)
        .get();
    if (mounted) setState(() => isSaved = doc.exists);
  }

  Future<void> _toggleSaveRoom() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_rooms')
        .doc(widget.roomId);

    if (isSaved) {
      await ref.delete();
      if (!mounted) return;
      setState(() => isSaved = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room removed from saved'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await ref.set({
        'room_id': widget.roomId,
        'saved_at': FieldValue.serverTimestamp(),
        ...Map<String, dynamic>.from(widget.room),
        'hostel_name': widget.hostel['name'],
        'hostel_id': widget.hostel['id'],
      });
      if (!mounted) return;
      setState(() => isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Room ${s(widget.room['room_number'])} saved successfully',
          ),
          backgroundColor: primaryBlue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String roomNumber = s(widget.room['room_number'], 'Room');
    final String roomType = s(widget.room['room_type'], 'Single');
    final int rent = i(
      widget.room['monthly_rent'] ??
          widget.room['rent'] ??
          widget.room['price'] ??
          0,
    );

    void showGenderError(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Booking Not Allowed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    final int totalBeds = i(widget.room['beds'], 1);
    final int bookedBeds = i(widget.room['booked_beds'], 0);
    final List images = widget.room['room_images'] ?? [];
    final String hostelName = s(widget.hostel['name'], 'Hostel');
    final String hostelId = s(widget.hostel['id']);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: Text(
          "Room $roomNumber",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : Colors.white,
            ),
            onPressed: _toggleSaveRoom,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  images[0],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.bed, size: 60),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              "Room $roomNumber",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tk $rent / month",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Type: $roomType",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Beds: $totalBeds",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  bookedBeds >= totalBeds
                      ? "Not Available"
                      : "Booked Beds: $bookedBeds",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: bookedBeds >= totalBeds
                        ? Colors.grey[600]
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) return;

                  // 1. Get current user gender from Firestore
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .get();
                  final userGender = s(
                    userDoc.data()?['gender'],
                  ); // 'Male' or 'Female'

                  // 2. Get hostel type from widget.hostel
                  final hostelType = s(
                    widget.hostel['hostel_type'],
                  ); // 'Boys' or 'Girls'

                  // 3. Check and block if mismatch
                  if (hostelType == "Boys" && userGender == "Female") {
                    showGenderError(
                      "This is a Boys hostel. Female users cannot book.",
                    );
                    return;
                  }

                  if (hostelType == "Girls" && userGender == "Male") {
                    showGenderError(
                      "This is a Girls hostel. Male users cannot book.",
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        room: widget.room,
                        roomId: widget.roomId,
                        hostel: widget.hostel,
                        ownerId: widget.ownerId,
                        hostelName: hostelName,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) return;

                  final chatId = getChatId(
                    currentUser.uid,
                    widget.ownerId,
                  ); // FIXED

                  await FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .set({
                        'participants': [currentUser.uid, widget.ownerId],
                        'studentId': currentUser.uid,
                        'ownerId': widget.ownerId,
                        'hostelId': hostelId,
                        'hostelName': hostelName,
                        'ownerName': businessName,
                        'roomNumber': roomNumber, // FIXED: camelCase
                        'lastMessage': '',
                        'lastMessageTime': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        chatId: chatId,
                        otherUserId: widget.ownerId,
                        otherUserName: businessName,
                        hostel_id: hostelId,
                        hostelName: hostelName,
                        roomNumber: roomNumber, // FIXED: camelCase
                      ),
                    ),
                  );
                },
                child: Text(
                  "Chat with Owner",
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
