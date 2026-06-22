// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:nan_nestfinder/owner_chatlist_page.dart';

// class OwnerChatPage extends StatefulWidget {
//   final String chatId;
//   final String bookingId;
//   final String studentName;
//   final String studentId;
//   final String? hostelName;
//   final String? roomNumber;
//   final businessName;

//   const OwnerChatPage({
//     super.key,
//     required this.chatId,
//     required this.bookingId,
//     required this.studentName,
//     required this.studentId,
//     this.hostelName,
//     this.roomNumber,
//     this.businessName,
//   });

//   @override
//   State<OwnerChatPage> createState() => _OwnerChatPageState();
// }

// class _OwnerChatPageState extends State<OwnerChatPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final user = FirebaseAuth.instance.currentUser;
//   bool _markedRead = false;

//   @override
//   void initState() {
//     super.initState();
//     FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
//       'unreadCountOwner': 0,
//     });
//   }

//   void _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty || user == null) return;
//     _messageController.clear();
//     _scrollToBottom();

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add({
//           'senderId': user!.uid,
//           'text': text,
//           'bookingId': widget.bookingId,
//           'hostelName': widget.hostelName,
//           'roomNumber': widget.roomNumber,
//           'businessName': widget.businessName,
//           'timestamp': FieldValue.serverTimestamp(),
//           'read': false,
//         });

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .update({
//           'lastMessage': text,
//           'lastMessageTime': FieldValue.serverTimestamp(),
//           'unreadCountStudent': FieldValue.increment(1),
//           'unreadCountOwner': 0,
//         });

//     // NEW: Student notification add
//     await FirebaseFirestore.instance.collection('notifications').add({
//       'user_id': widget.studentId,
//       'type': 'message',
//       'title': 'New message from ${user!.displayName ?? 'Owner'}',
//       'desc': text,
//       'time': FieldValue.serverTimestamp(),
//       'read': false,
//       'data': {
//         'chat_id': widget.chatId,
//         'owner_id': user!.uid,
//         'business_name': widget.businessName ?? '',
//         'student_id': widget.studentId,
//         'hostel_name': widget.hostelName ?? '',
//         'room_number': widget.roomNumber ?? '',
//         'booking_id': widget.bookingId,
//       },
//     });
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _markMessagesAsRead(QuerySnapshot snapshot) async {
//     if (user == null || _markedRead) return;
//     final batch = FirebaseFirestore.instance.batch();
//     int count = 0;
//     for (final doc in snapshot.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       if (data['senderId'] != user!.uid && data['read'] == false) {
//         batch.update(doc.reference, {'read': true});
//         count++;
//       }
//     }
//     if (count > 0) {
//       await batch.commit();
//       _markedRead = true;
//       Future.delayed(const Duration(seconds: 2), () => _markedRead = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const OwnerChatListPage(),
//               ),
//             );
//           },
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 widget.studentName.isNotEmpty
//                     ? widget.studentName[0].toUpperCase()
//                     : '?',
//                 style: TextStyle(
//                   color: primaryBlue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.studentName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '${widget.hostelName ?? 'Hostel'} - Room ${widget.roomNumber ?? 'N/A'}',
//                     style: const TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               // FIXED: Removed.where('bookingId') - chatId already filters
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text("No messages yet. Start the conversation!"),
//                   );
//                 }

//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _markMessagesAsRead(snapshot.data!);
//                   _scrollToBottom();
//                 });

//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index].data() as Map<String, dynamic>;
//                     final isMe = msg['senderId'] == user!.uid;
//                     final ts = msg['timestamp'] as Timestamp?;
//                     final timeText = ts != null
//                         ? DateFormat('hh:mm a').format(ts.toDate())
//                         : '';

//                     return Align(
//                       alignment: isMe
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 10,
//                         ),
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.75,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isMe ? primaryBlue : Colors.white,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(18),
//                             topRight: const Radius.circular(18),
//                             bottomLeft: Radius.circular(isMe ? 18 : 4),
//                             bottomRight: Radius.circular(isMe ? 4 : 18),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               msg['text'] ?? '',
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black87,
//                                 fontSize: 15,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   timeText,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: isMe
//                                         ? Colors.white70
//                                         : Colors.grey[600],
//                                   ),
//                                 ),
//                                 if (isMe) ...[
//                                   const SizedBox(width: 4),
//                                   Icon(
//                                     msg['read'] == true
//                                         ? Icons.done_all
//                                         : Icons.done,
//                                     size: 12,
//                                     color: isMe
//                                         ? Colors.blueAccent
//                                         : Colors.grey[600],
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(
//               left: 12,
//               right: 12,
//               top: 12,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 12,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     maxLines: null,
//                     onSubmitted: (_) => _sendMessage(),
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       filled: true,
//                       fillColor: const Color(0xFFF8F8F8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: primaryBlue,
//                   radius: 24,
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white),
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/owner_chatlist_page.dart';

class OwnerChatPage extends StatefulWidget {
  final String chatId;
  final String bookingId;
  final String studentName;
  final String studentId;
  final String? hostelName;
  final String? roomNumber;

  const OwnerChatPage({
    super.key,
    required this.chatId,
    required this.bookingId,
    required this.studentName,
    required this.studentId,
    this.hostelName,
    this.roomNumber,
  });

  @override
  State<OwnerChatPage> createState() => _OwnerChatPageState();
}

class _OwnerChatPageState extends State<OwnerChatPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  bool _markedRead = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'unreadCountOwner': 0,
    });
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || user == null) return;
    _messageController.clear();
    _scrollToBottom();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'senderId': user!.uid,
          'text': text,
          'bookingId': widget
              .bookingId, // FIXED: use camelCase to match your screenshot/reads
          'hostelName': widget.hostelName,
          'roomNumber': widget.roomNumber,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadCountStudent': FieldValue.increment(1),
          'unreadCountOwner': 0,
        });

    // NEW: Student notification add
    await FirebaseFirestore.instance.collection('notifications').add({
      'user_id': widget.studentId,
      'type': 'message',
      'title': 'New message from ${user!.displayName ?? 'Owner'}',
      'desc': text,
      'time': FieldValue.serverTimestamp(),
      'read': false,
      'data': {
        'chat_id': widget.chatId,
        'owner_id': user!.uid,
        'owner_name': user!.displayName ?? 'Owner',
        'student_id': widget.studentId,
        'hostel_name': widget.hostelName ?? '',
        'room_number': widget.roomNumber ?? '',
        'booking_id': widget.bookingId,
      },
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _markMessagesAsRead(QuerySnapshot snapshot) async {
    if (user == null || _markedRead) return;
    final batch = FirebaseFirestore.instance.batch();
    int count = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['senderId'] != user!.uid && data['read'] == false) {
        batch.update(doc.reference, {'read': true});
        count++;
      }
    }
    if (count > 0) {
      await batch.commit();
      _markedRead = true;
      Future.delayed(const Duration(seconds: 2), () => _markedRead = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OwnerChatListPage(),
              ),
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.studentName.isNotEmpty
                    ? widget.studentName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.hostelName ?? 'Hostel'} - Room ${widget.roomNumber ?? 'N/A'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // FIXED: Removed.where('bookingId') - chatId already filters
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No messages yet. Start the conversation!"),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _markMessagesAsRead(snapshot.data!);
                  _scrollToBottom();
                });

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == user!.uid;
                    final ts = msg['timestamp'] as Timestamp?;
                    final timeText = ts != null
                        ? DateFormat('hh:mm a').format(ts.toDate())
                        : '';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? primaryBlue : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              msg['text'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    msg['read'] == true
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 12,
                                    color: isMe
                                        ? Colors.blueAccent
                                        : Colors.grey[600],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryBlue,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
