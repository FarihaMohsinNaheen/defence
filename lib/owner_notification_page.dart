// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:nan_nestfinder/ownerpayment_page.dart';
// import 'owner_booking_page.dart';
// import 'owner_hostellist_page.dart';

// class OwnerNotificationPage extends StatefulWidget {
//   const OwnerNotificationPage({super.key});

//   @override
//   State<OwnerNotificationPage> createState() => _OwnerNotificationPageState();
// }

// class _OwnerNotificationPageState extends State<OwnerNotificationPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final user = FirebaseAuth.instance.currentUser;

//   // Safe getter
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
//             .collection('owner_notifications') // Owner notifications collection
//             .where('user_id', isEqualTo: user!.uid)
//             .orderBy('time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "Error: ${snapshot.error}",
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
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
//             final data = d.data() as Map<String, dynamic>;
//             final time = _toDateTime(data['time']);
//             return _isToday(time, today);
//           }).toList();

//           final earlierDocs = docs.where((d) {
//             final data = d.data() as Map<String, dynamic>;
//             final time = _toDateTime(data['time']);
//             return !_isToday(time, today);
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
//     final title = g<String>(data, 'title', 'Notification');
//     final desc = g<String>(data, 'desc', '');
//     final time = _toDateTime(data['time']);
//     final read = g<bool>(data, 'read', false);
//     final type = g<String>(data, 'type', '');

//     IconData icon = Icons.notifications;
//     if (type == 'hostel_approved') icon = Icons.check_circle_outline;
//     if (type == 'hostel_rejected') icon = Icons.cancel_outlined;
//     if (type == 'payout_paid') icon = Icons.payments;
//     if (type == 'new_booking') icon = Icons.new_releases;
//     if (type == 'booking_cancelled_owner') icon = Icons.cancel;

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
//     final ownerId = user!.uid; // FIX: get owner id from current user

//     // OWNER / HONOUR TAPS ONLY
//     if (type == 'hostel_approved' || type == 'hostel_rejected') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const MyListingsPage()),
//       );
//     }

//     if (type == 'payout_paid') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const OwnerPaymentPage()),
//       );
//     }

//     if (type == 'new_booking' || type == 'booking_cancelled_owner') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => OwnerBookingsPage(owner_id: ownerId)),
//       );
//       // Removed const because ownerId is runtime value
//     }
//   }

//   Future<void> _markAllAsRead() async {
//     final batch = FirebaseFirestore.instance.batch();
//     final snap = await FirebaseFirestore.instance
//         .collection('owner_notifications')
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

//   DateTime _toDateTime(dynamic val) {
//     if (val is Timestamp) return val.toDate();
//     if (val is DateTime) return val;
//     if (val is String) {
//       try {
//         return DateTime.parse(val);
//       } catch (_) {}
//     }
//     return DateTime.fromMillisecondsSinceEpoch(0);
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/chat_page.dart';
import 'package:nan_nestfinder/ownerpayment_page.dart';
import 'owner_booking_page.dart';
import 'owner_hostellist_page.dart';

class OwnerNotificationPage extends StatefulWidget {
  const OwnerNotificationPage({super.key});

  @override
  State<OwnerNotificationPage> createState() => _OwnerNotificationPageState();
}

class _OwnerNotificationPageState extends State<OwnerNotificationPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  // ADD: Stream for user settings to check notification toggle
  Stream<DocumentSnapshot>? _userSettingsStream;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _userSettingsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots();
    }
  }

  // Safe getter
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
      // CHANGE: Wrap with settings stream to respect toggle
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userSettingsStream,
        builder: (context, settingsSnap) {
          final settings =
              settingsSnap.data?.data() as Map<String, dynamic>? ?? {};
          final notificationsEnabled = g<bool>(
            settings,
            'notifications_enabled',
            true,
          );

          if (!notificationsEnabled) {
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
                    "Notifications are turned off",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Turn on from Settings to see notifications",
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            );
          }

          // If notifications are ON, show original notifications stream
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(
                  'owner_notifications',
                ) // Owner notifications collection
                .where('user_id', isEqualTo: user!.uid)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
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
                final data = d.data() as Map<String, dynamic>;
                final time = _toDateTime(data['time']);
                return _isToday(time, today);
              }).toList();

              final earlierDocs = docs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final time = _toDateTime(data['time']);
                return !_isToday(time, today);
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
    final title = g<String>(data, 'title', 'Notification');
    final desc = g<String>(data, 'desc', '');
    final time = _toDateTime(data['time']);
    final read = g<bool>(data, 'read', false);
    final type = g<String>(data, 'type', '');

    IconData icon = Icons.notifications;
    if (type == 'hostel_approved') icon = Icons.check_circle_outline;
    if (type == 'hostel_rejected') icon = Icons.cancel_outlined;
    if (type == 'payout_paid') icon = Icons.payments;
    if (type == 'new_booking') icon = Icons.new_releases;
    if (type == 'booking_cancelled_owner') icon = Icons.cancel;
    if (type == 'student_message') icon = Icons.message;

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
            color: read ? Colors.white : primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: read ? Colors.transparent : primaryBlue.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryBlue.withOpacity(0.1),
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
    final ownerId = user!.uid; // FIX: get owner id from current user

    // OWNER / HONOUR TAPS ONLY
    if (type == 'hostel_approved' || type == 'hostel_rejected') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyListingsPage()),
      );
    }

    if (type == 'payout_paid') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OwnerPaymentPage()),
      );
    }

    if (type == 'new_booking' || type == 'booking_cancelled_owner') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OwnerBookingsPage(owner_id: ownerId)),
      );
      // Removed const because ownerId is runtime value
    }

    if (type == 'student_message') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            chatId: g<String>(dataMap, 'chat_id', ''),
            otherUserId: g<String>(dataMap, 'student_id', ''),
            otherUserName: g<String>(dataMap, 'student_name', 'Student'),
            hostel_id: g<String>(dataMap, 'hostel_id', ''),
            hostelName: g<String>(dataMap, 'hostel_name', ''),
            roomNumber: g<String>(dataMap, 'room_number', ''),
          ),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    final batch = FirebaseFirestore.instance.batch();
    final snap = await FirebaseFirestore.instance
        .collection('owner_notifications')
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

  DateTime _toDateTime(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is String) {
      try {
        return DateTime.parse(val);
      } catch (_) {}
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
