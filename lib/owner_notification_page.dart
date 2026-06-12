import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OwnerNotificationPage extends StatefulWidget {
  const OwnerNotificationPage({super.key});

  @override
  State<OwnerNotificationPage> createState() => _OwnerNotificationPageState();
}

class _OwnerNotificationPageState extends State<OwnerNotificationPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  T _get<T>(Map data, String key, T defaultValue) {
    final val = data[key];
    return (val is T) ? val : defaultValue;
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
            .where('userId', isEqualTo: user!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
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
            final data = d.data() as Map;
            final time = (data['time'] as Timestamp?)?.toDate();
            return time != null && _isToday(time, today);
          }).toList();

          final earlierDocs = docs.where((d) {
            final data = d.data() as Map;
            final time = (data['time'] as Timestamp?)?.toDate();
            return time != null && !_isToday(time, today);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (todayDocs.isNotEmpty) ...[
                  _buildTitle("Today"),
                  const SizedBox(height: 15),
                  ...todayDocs.map((doc) => _buildNotificationTile(doc)),
                  const SizedBox(height: 25),
                ],
                if (earlierDocs.isNotEmpty) ...[
                  _buildTitle("Earlier"),
                  const SizedBox(height: 15),
                  ...earlierDocs.map((doc) => _buildNotificationTile(doc)),
                ],
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
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

  Widget _buildNotificationTile(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final title = _get<String>(data, 'title', 'Notification');
    final desc = _get<String>(data, 'desc', '');
    final timestamp = data['time'] as Timestamp?;
    final time = timestamp?.toDate() ?? DateTime.now();
    final read = _get<bool>(data, 'read', false);
    final type = _get<String>(data, 'type', '');

    IconData icon = Icons.notifications;
    if (type == 'hostel_approved') icon = Icons.check_circle;
    if (type == 'hostel_rejected') icon = Icons.cancel;
    if (type == 'booking') icon = Icons.book_online;
    if (type == 'message') icon = Icons.message;
    if (type == 'review') icon = Icons.star;

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
              const SizedBox(width: 8),
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

  void _handleTap(Map<String, dynamic> data) {
    final type = _get<String>(data, 'type', '');
    if (type == 'hostel_approved' || type == 'hostel_rejected') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Open hostel details")));
    } else if (type == 'booking') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Open booking details")));
    } else if (type == 'message') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Open chat")));
    } else if (type == 'review') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Open reviews")));
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user!.uid)
          .where('read', isEqualTo: false)
          .get();

      if (snap.docs.isEmpty) return;

      for (var doc in snap.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All notifications marked as read"),
            duration: Duration(seconds: 1),
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

  bool _isToday(DateTime date, DateTime today) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}
