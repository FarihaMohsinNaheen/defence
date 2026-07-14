import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/owner_dashboard_page.dart';
import 'owner_chat_page.dart';

class OwnerChatListPage extends StatelessWidget {
  const OwnerChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const Color primaryEBlue = Color(0xFF003366);

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFEAF4FF),
        appBar: AppBar(
          backgroundColor: primaryEBlue,
          title: const Text(
            "Messages",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryEBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
            );
          },
        ),
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('ownerId', isEqualTo: user.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Error: ${snapshot.error}\n\nIf index error shows, click the link below it to create index",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No messages yet",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Student inquiries will appear here",
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chat = chatDoc.data() as Map<String, dynamic>;
              final chatId = chatDoc.id;

              final bookingId = chat['bookingId'] ?? chat['booking_id'] ?? '';
              final studentId = chat['studentId'] ?? chat['student_id'] ?? '';
              final hostelName =
                  chat['hostelName'] ?? chat['hostelname'] ?? 'Hostel';
              final roomNumber = // FIXED: variable name roomNumber korlam
                  chat['roomNumber'] ?? chat['roomNumber'] ?? 'N/A';
              final lastMessage = chat['lastMessage'] ?? '';
              final lastTime = chat['lastMessageTime'] as Timestamp?;
              final timeText = lastTime != null
                  ? DateFormat('hh:mm a').format(lastTime.toDate())
                  : '';
              final unreadCount = chat['unreadCountOwner'] ?? 0;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(studentId)
                    .snapshots(),
                builder: (context, userSnap) {
                  final userData =
                      userSnap.data?.data() as Map<String, dynamic>?;
                  final studentName = userData?['name'] ?? 'Student';
                  final studentPhoto = userData?['profileImage'] ?? '';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: primaryEBlue,
                      backgroundImage: studentPhoto.toString().isNotEmpty
                          ? NetworkImage(studentPhoto)
                          : null,
                      child: studentPhoto.toString().isEmpty
                          ? Text(
                              studentName.isNotEmpty
                                  ? studentName[0].toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIXED: roomNumber use korlam
                        Text(
                          "$hostelName • Room $roomNumber",
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryEBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryEBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .update({'unreadCountOwner': 0});

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OwnerChatPage(
                            chatId: chatId,
                            bookingId: bookingId,
                            studentName: studentName,
                            studentId: studentId,
                            hostelName: hostelName,
                            roomNumber:
                                roomNumber, 
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
