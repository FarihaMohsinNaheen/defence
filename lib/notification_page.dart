// import 'package:flutter/material.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   int currentIndex = 1;

//   final List<Map<String, String>> notifications = [
//     {
//       "title": "New Hostel Added",
//       "desc": "A new hostel is available near your area.",
//       "time": "Just now",
//     },
//     {
//       "title": "Roommate Match Found",
//       "desc": "We found 3 matching students for you.",
//       "time": "2h ago",
//     },
//     {
//       "title": "Discount Offer",
//       "desc": "Get 10% off on selected hostels.",
//       "time": "Yesterday",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       /// APP BAR (same as settings style)
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
//           "Notifications",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       /// BODY (Settings-style cards)
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             buildTitle("Today"),

//             const SizedBox(height: 15),

//             ...notifications.map((n) {
//               return buildNotificationTile(n["title"]!, n["desc"]!, n["time"]!);
//             }),

//             const SizedBox(height: 25),

//             buildTitle("Earlier"),

//             const SizedBox(height: 15),

//             buildNotificationTile(
//               "App Update",
//               "New features have been added to improve experience.",
//               "2 days ago",
//             ),

//             buildNotificationTile(
//               "Welcome",
//               "Thanks for using NAN NestFinder!",
//               "1 week ago",
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   /// TITLE (same style as SettingsPage)
//   Widget buildTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: primaryBlue,
//         ),
//       ),
//     );
//   }

//   /// NOTIFICATION TILE (same card style as SettingsPage)
//   Widget buildNotificationTile(String title, String desc, String time) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: primaryBlue.withOpacity(0.1),
//             child: Icon(Icons.notifications, color: primaryBlue),
//           ),
//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(desc, style: TextStyle(color: Colors.grey.shade700)),
//               ],
//             ),
//           ),

//           Text(
//             time,
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }
// }

//fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'chat_page.dart';
// import 'review_page.dart';
// import 'hosteldetails_page.dart';
// import "Mybooking_page.dart";

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final user = FirebaseAuth.instance.currentUser;

//   T g<T>(Map data, String key, T def) {
//     final val = data[key];
//     return (val is T) ? val : def;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFEAF4FF),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: primaryBlue),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             "Notifications",
//             style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: const Center(child: Text("Please login first")),
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
//           "Notifications",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_all, color: Color(0xFF003366)),
//             onPressed: _markAllAsRead,
//             tooltip: "Mark all read",
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//             .where('user_id', isEqualTo: user!.uid) // snake_case like owner
//             .orderBy('time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF003366)),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_off_outlined,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No notifications yet",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final docs = snapshot.data!.docs;
//           final today = DateTime.now();
//           final todayDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && _isToday(time, today);
//           }).toList();
//           final earlierDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && !_isToday(time, today);
//           }).toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 if (todayDocs.isNotEmpty) ...[
//                   buildTitle("Today"),
//                   const SizedBox(height: 15),
//                   ...todayDocs.map((doc) => buildNotificationTile(doc)),
//                   const SizedBox(height: 25),
//                 ],
//                 if (earlierDocs.isNotEmpty) ...[
//                   buildTitle("Earlier"),
//                   const SizedBox(height: 15),
//                   ...earlierDocs.map((doc) => buildNotificationTile(doc)),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: primaryBlue,
//         ),
//       ),
//     );
//   }

//   Widget buildNotificationTile(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final title = g<String>(data, 'title', '');
//     final desc = g<String>(data, 'desc', '');
//     final time = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();
//     final read = g<bool>(data, 'read', false);
//     final type = g<String>(data, 'type', '');

//     IconData icon = Icons.notifications;
//     if (type == 'new_hostel') icon = Icons.home_work;
//     if (type == 'roommate_match') icon = Icons.people;
//     if (type == 'discount') icon = Icons.local_offer;
//     if (type == 'booking') icon = Icons.book_online;
//     if (type == 'message') icon = Icons.message;
//     if (type == 'review_reply') icon = Icons.rate_review;

//     return Dismissible(
//       key: Key(doc.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       onDismissed: (_) => doc.reference.delete(),
//       child: GestureDetector(
//         onTap: () {
//           if (!read) doc.reference.update({'read': true});
//           _handleTap(data);
//         },
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: read ? Colors.white : primaryBlue.withValues(alpha: 0.05),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: read
//                   ? Colors.transparent
//                   : primaryBlue.withValues(alpha: 0.2),
//             ),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: primaryBlue.withValues(alpha: 0.1),
//                 child: Icon(icon, color: primaryBlue),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: read ? Colors.black87 : primaryBlue,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       desc,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 DateFormat('hh:mm a').format(time),
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleTap(Map<String, dynamic> data) async {
//     final type = g<String>(data, 'type', '');
//     final dataMap = g<Map>(data, 'data', {});

//     if (type == 'message' && g<String>(dataMap, 'chat_id', '').isNotEmpty) {
//       final chatId = g<String>(dataMap, 'chat_id', '');
//       final otherUserId = g<String>(
//         dataMap,
//         'owner_id',
//         g<String>(dataMap, 'student_id', ''),
//       );
//       final otherUserName = g<String>(
//         dataMap,
//         'owner_name',
//         g<String>(dataMap, 'student_name', 'User'),
//       );
//       final hostelName = g<String>(dataMap, 'hostel_name', 'Hostel');

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ChatPage(
//             chatId: chatId,
//             otherUserId: otherUserId,
//             otherUserName: otherUserName,
//             hostel_id: hostelDocId,
//             hostelName: hostelName,
//           ),
//         ),
//       );
//     }

//     if (type == 'review_reply') {
//       // ReviewPage has NO parameters - just open it
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ReviewPage()),
//       );
//     }

//     if (type == 'booking' && g<String>(dataMap, 'booking_id', '').isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => MyBookingsPage()),
//       );
//     }

//     if (type == 'new_hostel' &&
//         g<String>(dataMap, 'hostel_id', '').isNotEmpty) {
//       final hostelId = g<String>(dataMap, 'hostel_id', '');
//       final hostelDoc = await FirebaseFirestore.instance
//           .collection('hostels')
//           .doc(hostelId)
//           .get();
//       if (hostelDoc.exists && mounted) {
//         final hostelData = hostelDoc.data()!..['id'] = hostelDoc.id;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HostelDetailsPage(hostel: hostelData),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _markAllAsRead() async {
//     final batch = FirebaseFirestore.instance.batch();
//     final snap = await FirebaseFirestore.instance
//         .collection('notifications')
//         .where('user_id', isEqualTo: user!.uid)
//         .where('read', isEqualTo: false)
//         .get();
//     for (var doc in snap.docs) {
//       batch.update(doc.reference, {'read': true});
//     }
//     await batch.commit();
//   }

//   bool _isToday(DateTime date, DateTime today) {
//     return date.year == today.year &&
//         date.month == today.month &&
//         date.day == today.day;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'chat_page.dart';
// import 'review_page.dart';
// import 'hosteldetails_page.dart';
// import "Mybooking_page.dart";

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final user = FirebaseAuth.instance.currentUser;

//   T g<T>(Map data, String key, T def) {
//     final val = data[key];
//     return (val is T) ? val : def;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFEAF4FF),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: primaryBlue),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             "Notifications",
//             style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: const Center(child: Text("Please login first")),
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
//           "Notifications",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_all, color: Color(0xFF003366)),
//             onPressed: _markAllAsRead,
//             tooltip: "Mark all read",
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//             .where('user_id', isEqualTo: user!.uid)
//             .orderBy('time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF003366)),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_off_outlined,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No notifications yet",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final docs = snapshot.data!.docs;
//           final today = DateTime.now();
//           final todayDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && _isToday(time, today);
//           }).toList();
//           final earlierDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && !_isToday(time, today);
//           }).toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 if (todayDocs.isNotEmpty) ...[
//                   buildTitle("Today"),
//                   const SizedBox(height: 15),
//                   ...todayDocs.map((doc) => buildNotificationTile(doc)),
//                   const SizedBox(height: 25),
//                 ],
//                 if (earlierDocs.isNotEmpty) ...[
//                   buildTitle("Earlier"),
//                   const SizedBox(height: 15),
//                   ...earlierDocs.map((doc) => buildNotificationTile(doc)),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: primaryBlue,
//         ),
//       ),
//     );
//   }

//   Widget buildNotificationTile(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final title = g<String>(data, 'title', '');
//     final desc = g<String>(data, 'desc', '');
//     final time = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();
//     final read = g<bool>(data, 'read', false);
//     final type = g<String>(data, 'type', '');

//     IconData icon = Icons.notifications;
//     if (type == 'new_hostel') icon = Icons.home_work;
//     if (type == 'roommate_match') icon = Icons.people;
//     if (type == 'discount') icon = Icons.local_offer;
//     if (type == 'booking') icon = Icons.book_online;
//     if (type == 'message') icon = Icons.message;
//     if (type == 'review_reply') icon = Icons.rate_review;

//     return Dismissible(
//       key: Key(doc.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       onDismissed: (_) => doc.reference.delete(),
//       child: GestureDetector(
//         onTap: () {
//           if (!read) doc.reference.update({'read': true});
//           _handleTap(data);
//         },
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: read ? Colors.white : primaryBlue.withValues(alpha: 0.05),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: read
//                   ? Colors.transparent
//                   : primaryBlue.withValues(alpha: 0.2),
//             ),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: primaryBlue.withValues(alpha: 0.1),
//                 child: Icon(icon, color: primaryBlue),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: read ? Colors.black87 : primaryBlue,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       desc,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 DateFormat('hh:mm a').format(time),
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleTap(Map<String, dynamic> data) async {
//     final type = g<String>(data, 'type', '');
//     final dataMap = g<Map<String, dynamic>>(data, 'data', {});

//     if (type == 'message' && g<String>(dataMap, 'chat_id', '').isNotEmpty) {
//       final chatId = g<String>(dataMap, 'chat_id', '');
//       final otherUserId = g<String>(
//         dataMap,
//         'owner_id',
//         g<String>(dataMap, 'student_id', ''),
//       );
//       final otherUserName = g<String>(
//         dataMap,
//         'owner_name',
//         g<String>(dataMap, 'student_name', 'User'),
//       );
//       final hostelName = g<String>(dataMap, 'hostel_name', 'Hostel');
//       final hostelId = g<String>(dataMap, 'hostel_id', ''); // EITA NITE HOBE

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ChatPage(
//             chatId: chatId,
//             otherUserId: otherUserId,
//             otherUserName: otherUserName,
//             hostel_id: hostelId, // hostelDocId er bodole hostelId
//             hostelName: hostelName,
//           ),
//         ),
//       );
//     }

//     if (type == 'review_reply') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ReviewPage()),
//       );
//     }

//     if (type == 'booking' && g<String>(dataMap, 'booking_id', '').isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => MyBookingsPage()),
//       );
//     }

//     if (type == 'new_hostel' &&
//         g<String>(dataMap, 'hostel_id', '').isNotEmpty) {
//       final hostelId = g<String>(dataMap, 'hostel_id', '');
//       final hostelDoc = await FirebaseFirestore.instance
//           .collection('hostels')
//           .doc(hostelId)
//           .get();
//       if (hostelDoc.exists && mounted) {
//         final hostelData = hostelDoc.data()!..['id'] = hostelDoc.id;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HostelDetailsPage(hostel: hostelData),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _markAllAsRead() async {
//     final batch = FirebaseFirestore.instance.batch();
//     final snap = await FirebaseFirestore.instance
//         .collection('notifications')
//         .where('user_id', isEqualTo: user!.uid)
//         .where('read', isEqualTo: false)
//         .get();
//     for (var doc in snap.docs) {
//       batch.update(doc.reference, {'read': true});
//     }
//     await batch.commit();
//   }

//   bool _isToday(DateTime date, DateTime today) {
//     return date.year == today.year &&
//         date.month == today.month &&
//         date.day == today.day;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'chat_page.dart';
// import 'Mybooking_page.dart';
// import 'review_page.dart';
// import 'hosteldetails_page.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFEAF4FF),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: primaryBlue),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             "Notifications",
//             style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: const Center(child: Text("Please login first")),
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
//           "Notifications",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_all, color: Color(0xFF003366)),
//             onPressed: _markAllAsRead,
//             tooltip: "Mark all read",
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//             .where('user_id', isEqualTo: user!.uid)
//             .orderBy('time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF003366)),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 60,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Index lagbe!",
//                       style: TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Firebase Console > Firestore > Indexes > Add Index\nCollection: notifications\nField1: user_id Ascending\nField2: time Descending",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_off_outlined,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No notifications yet",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final docs = snapshot.data!.docs;
//           final today = DateTime.now();
//           final todayDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && _isToday(time, today);
//           }).toList();
//           final earlierDocs = docs.where((d) {
//             final time = (d['time'] as Timestamp?)?.toDate();
//             return time != null && !_isToday(time, today);
//           }).toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 if (todayDocs.isNotEmpty) ...[
//                   buildTitle("Today"),
//                   const SizedBox(height: 15),
//                   ...todayDocs.map((doc) => buildNotificationTile(doc)),
//                   const SizedBox(height: 25),
//                 ],
//                 if (earlierDocs.isNotEmpty) ...[
//                   buildTitle("Earlier"),
//                   const SizedBox(height: 15),
//                   ...earlierDocs.map((doc) => buildNotificationTile(doc)),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: primaryBlue,
//         ),
//       ),
//     );
//   }

//   Widget buildNotificationTile(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final title = data['title'] ?? '';
//     final desc = data['desc'] ?? '';
//     final time = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();
//     final read = data['read'] ?? false;
//     final type = data['type'] ?? '';

//     IconData icon = Icons.notifications;
//     if (type == 'new_hostel') icon = Icons.home_work;
//     if (type == 'booking_paid' || type == 'booking') icon = Icons.book_online;
//     if (type == 'message') icon = Icons.message;
//     if (type == 'review_reply') icon = Icons.rate_review;
//     if (type == 'refund') icon = Icons.money_off;

//     return Dismissible(
//       key: Key(doc.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       onDismissed: (_) => doc.reference.delete(),
//       child: GestureDetector(
//         onTap: () => _handleTap(doc),
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: read ? Colors.white : primaryBlue.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: read ? Colors.transparent : primaryBlue.withOpacity(0.2),
//             ),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: primaryBlue.withOpacity(0.1),
//                 child: Icon(icon, color: primaryBlue),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: read ? Colors.black87 : primaryBlue,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       desc,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 14,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 DateFormat('hh:mm a').format(time),
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleTap(QueryDocumentSnapshot doc) async {
//     final data = doc.data() as Map<String, dynamic>;

//     // Mark as read
//     if (data['read'] == false) {
//       doc.reference.update({'read': true});
//     }

//     final type = data['type'] ?? '';
//     final bookingId = data['booking_id'] ?? '';

//     // Message notification → Chat page e jabe
//     if (type == 'message' && bookingId.isNotEmpty) {
//       try {
//         final bookingDoc = await FirebaseFirestore.instance
//             .collection('bookings')
//             .doc(bookingId)
//             .get();

//         if (!bookingDoc.exists) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(const SnackBar(content: Text("Booking not found")));
//           return;
//         }

//         final bookingData = bookingDoc.data()!;
//         final roomNumber = bookingData['room_number'] ?? '';
//         final hostelId = bookingData['hostel_id'] ?? '';
//         final hostelname = bookingData['hostelname'] ?? 'Hostel';
//         final ownerId = bookingData['owner_id'] ?? '';
//         final studentId = bookingData['student_id'] ?? user!.uid;

//         // chatId format: studentId_ownerId_bookingId
//         final chatId = '${studentId}_${ownerId}_$bookingId';

//         if (mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ChatPage(
//                 chatId: chatId,
//                 bookingId: bookingId,
//                 otherUserId: ownerId,
//                 otherUserName: 'Owner',
//                 hostel_id: hostelId,
//                 hostelname: hostelname,
//                 roomNumber: roomNumber,
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//       }
//     }

//     // Booking/Refund notification → MyBookingsPage
//     if (type == 'booking_paid' || type == 'booking' || type == 'refund') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => MyBookingsPage()),
//       );
//     }

//     // Review reply → ReviewPage
//     if (type == 'review_reply') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ReviewPage()),
//       );
//     }

//     // New hostel → HostelDetailsPage
//     if (type == 'new_hostel') {
//       final hostelName =
//           data['title']?.toString().replaceAll('New Hostel: ', '') ?? '';
//       final hostelDoc = await FirebaseFirestore.instance
//           .collection('hostels')
//           .where('name', isEqualTo: hostelName)
//           .limit(1)
//           .get();
//       if (hostelDoc.docs.isNotEmpty && mounted) {
//         final hostelData = hostelDoc.docs.first.data()
//           ..['id'] = hostelDoc.docs.first.id;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HostelDetailsPage(hostel: hostelData),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _markAllAsRead() async {
//     final batch = FirebaseFirestore.instance.batch();
//     final snap = await FirebaseFirestore.instance
//         .collection('notifications')
//         .where('user_id', isEqualTo: user!.uid)
//         .where('read', isEqualTo: false)
//         .get();
//     for (var doc in snap.docs) {
//       batch.update(doc.reference, {'read': true});
//     }
//     await batch.commit();
//   }

//   bool _isToday(DateTime date, DateTime today) {
//     return date.year == today.year &&
//         date.month == today.month &&
//         date.day == today.day;
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'chat_page.dart';
import 'review_page.dart';
import 'hosteldetails_page.dart';
import "Mybooking_page.dart";

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  T g<T>(Map data, String key, T def) {
    final val = data[key];
    return (val is T) ? val : def;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
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
            "Notifications",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: Text("Please login first")),
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
          "Notifications",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Color(0xFF003366)),
            onPressed: _markAllAsRead,
            tooltip: "Mark all read",
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('user_id', isEqualTo: user!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No notifications yet",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;
          final today = DateTime.now();
          final todayDocs = docs.where((d) {
            final time = (d['time'] as Timestamp?)?.toDate();
            return time != null && _isToday(time, today);
          }).toList();
          final earlierDocs = docs.where((d) {
            final time = (d['time'] as Timestamp?)?.toDate();
            return time != null && !_isToday(time, today);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (todayDocs.isNotEmpty) ...[
                  buildTitle("Today"),
                  const SizedBox(height: 15),
                  ...todayDocs.map((doc) => buildNotificationTile(doc)),
                  const SizedBox(height: 25),
                ],
                if (earlierDocs.isNotEmpty) ...[
                  buildTitle("Earlier"),
                  const SizedBox(height: 15),
                  ...earlierDocs.map((doc) => buildNotificationTile(doc)),
                ],
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget buildNotificationTile(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final title = g<String>(data, 'title', '');
    final desc = g<String>(data, 'desc', '');
    final time = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();
    final read = g<bool>(data, 'read', false);
    final type = g<String>(data, 'type', '');

    IconData icon = Icons.notifications;
    if (type == 'new_hostel') icon = Icons.home_work;
    if (type == 'roommate_match') icon = Icons.people;
    if (type == 'discount') icon = Icons.local_offer;
    if (type == 'booking') icon = Icons.book_online;
    if (type == 'message') icon = Icons.message;
    if (type == 'review_reply') icon = Icons.rate_review;

    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => doc.reference.delete(),
      child: GestureDetector(
        onTap: () {
          if (!read) doc.reference.update({'read': true});
          _handleTap(data);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: read ? Colors.white : primaryBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: read
                  ? Colors.transparent
                  : primaryBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryBlue.withValues(alpha: 0.1),
                child: Icon(icon, color: primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: read ? Colors.black87 : primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(time),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(Map<String, dynamic> data) async {
    final type = g<String>(data, 'type', '');
    final dataMap = g<Map<String, dynamic>>(data, 'data', {});

    if (type == 'message' && g<String>(dataMap, 'chat_id', '').isNotEmpty) {
      final chatId = g<String>(dataMap, 'chat_id', '');
      final otherUserId = g<String>(
        dataMap,
        'owner_id',
        g<String>(dataMap, 'student_id', ''),
      );
      final otherUserName = g<String>(
        dataMap,
        'owner_name',
        g<String>(dataMap, 'student_name', 'User'),
      );
      final hostelName = g<String>(dataMap, 'hostel_name', 'Hostel');
      final hostelId = g<String>(dataMap, 'hostel_id', ''); // EITA NITE HOBE

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            chatId: chatId,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
            hostel_id: hostelId, // hostelDocId er bodole hostelId
            hostelName: hostelName,
          ),
        ),
      );
    }

    if (type == 'review_reply') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReviewPage()),
      );
    }

    if (type == 'booking' && g<String>(dataMap, 'booking_id', '').isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MyBookingsPage()),
      );
    }

    if (type == 'new_hostel' &&
        g<String>(dataMap, 'hostel_id', '').isNotEmpty) {
      final hostelId = g<String>(dataMap, 'hostel_id', '');
      final hostelDoc = await FirebaseFirestore.instance
          .collection('hostels')
          .doc(hostelId)
          .get();
      if (hostelDoc.exists && mounted) {
        final hostelData = hostelDoc.data()!..['id'] = hostelDoc.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HostelDetailsPage(hostel: hostelData),
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final batch = FirebaseFirestore.instance.batch();
    final snap = await FirebaseFirestore.instance
        .collection('notifications')
        .where('user_id', isEqualTo: user!.uid)
        .where('read', isEqualTo: false)
        .get();
    for (var doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  bool _isToday(DateTime date, DateTime today) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}
