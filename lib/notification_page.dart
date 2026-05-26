import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryBlue = const Color(0xFF003366);

  int currentIndex = 1;

  final List<Map<String, String>> notifications = [
    {
      "title": "New Hostel Added",
      "desc": "A new hostel is available near your area.",
      "time": "Just now",
    },
    {
      "title": "Roommate Match Found",
      "desc": "We found 3 matching students for you.",
      "time": "2h ago",
    },
    {
      "title": "Discount Offer",
      "desc": "Get 10% off on selected hostels.",
      "time": "Yesterday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      /// APP BAR (same as settings style)
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
          "Notifications",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      /// BODY (Settings-style cards)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTitle("Today"),

            const SizedBox(height: 15),

            ...notifications.map((n) {
              return buildNotificationTile(n["title"]!, n["desc"]!, n["time"]!);
            }),

            const SizedBox(height: 25),

            buildTitle("Earlier"),

            const SizedBox(height: 15),

            buildNotificationTile(
              "App Update",
              "New features have been added to improve experience.",
              "2 days ago",
            ),

            buildNotificationTile(
              "Welcome",
              "Thanks for using NAN NestFinder!",
              "1 week ago",
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// TITLE (same style as SettingsPage)
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

  /// NOTIFICATION TILE (same card style as SettingsPage)
  Widget buildNotificationTile(String title, String desc, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: Icon(Icons.notifications, color: primaryBlue),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),

          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
