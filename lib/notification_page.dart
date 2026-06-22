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

  // NEW: Toggle state
  bool _notificationsEnabled = true;

  // Safe getter to avoid type errors
  T g<T>(Map data, String key, T def) {
    final val = data[key];
    return (val is T) ? val : def;
  }

  // NEW: Load toggle on start
  @override
  void initState() {
    super.initState();
    _loadToggle();
  }

  _loadToggle() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (mounted && doc.exists) {
      setState(() {
        _notificationsEnabled = g<bool>(
          doc.data() as Map<String, dynamic>,
          'notifications_enabled',
          true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("NotificationPage built. Current UID: ${user?.uid}");

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

    // NEW: Toggle OFF check
    if (!_notificationsEnabled) {
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
        body: Center(
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
                "Enable them from Settings",
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
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
        // If you get "index required" error, click the link in console to create it
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('user_id', isEqualTo: user!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          print(
            "Notif stream -> state: ${snapshot.connectionState}, "
            "hasData: ${snapshot.hasData}, "
            "docs: ${snapshot.data?.docs.length}, "
            "error: ${snapshot.error}",
          );

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
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
    if (type == 'new_hostel') icon = Icons.home_work;
    if (type == 'booking') icon = Icons.book_online;
    if (type == 'message') icon = Icons.message;
    if (type == 'refund') icon = Icons.account_balance_wallet; // NEW

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
      final hostelId = g<String>(dataMap, 'hostel_id', '');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            chatId: chatId,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
            hostel_id: hostelId,
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

    if (type == 'refund') {
      // NEW
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

  // Converts Timestamp, DateTime, String, or null to DateTime safely
  DateTime _toDateTime(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is String) {
      try {
        return DateTime.parse(val);
      } catch (_) {}
    }
    // Fallback for missing/wrong type
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
