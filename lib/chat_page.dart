// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class ChatPage extends StatefulWidget {
//   final String chatId;
//   final String otherUserName;
//   final String otherUserId;
//   final String hostel_id;
//   final String? hostelName;
//   final String? roomNumber;
//   final String? otherUserSubtitle;

//   const ChatPage({
//     super.key,
//     required this.chatId,
//     required this.otherUserName,
//     required this.otherUserId,
//     required this.hostel_id,
//     this.hostelName,
//     this.roomNumber,
//     this.otherUserSubtitle,
//   });

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final Color primaryBlue = const Color(0xFF003366);
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final user = FirebaseAuth.instance.currentUser;
//   bool _markedRead = false;

//   @override
//   void initState() {
//     super.initState();
//     // FIXED: Reset student unread count when opening chat
//     FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
//       'unreadCountStudent': 0,
//     });
//   }

//   void _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty || user == null) return;

//     _messageController.clear();
//     _scrollToBottom();

//     // 1. Message add
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add({
//           'senderId': user!.uid,
//           'text': text,
//           'hostelId': widget.hostel_id,
//           'hostelName': widget.hostelName,
//           'timestamp': FieldValue.serverTimestamp(),
//           'read': false,
//         });

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .update({
//           'lastMessage': text,
//           'lastMessageTime': FieldValue.serverTimestamp(),
//           'unreadCountOwner': FieldValue.increment(1),
//           'unreadCountStudent': 0,
//         });
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

//     for (var doc in snapshot.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       if (data['senderId'] != user!.uid && data['read'] == false) {
//         batch.update(doc.reference, {'read': true});
//         count++;
//       }
//     }

//     if (count > 0) {
//       await batch.commit();
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatId)
//           .update({'unreadCountStudent': 0});

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
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 widget.otherUserName.isNotEmpty
//                     ? widget.otherUserName[0].toUpperCase()
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
//                     widget.otherUserName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     widget.hostelName != null && widget.hostelName!.isNotEmpty
//                         ? widget.hostelName!
//                         : "Online",
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
//                   return Center(
//                     child: Text(
//                       "No messages yet\nStart the conversation!",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   );
//                 }

//                 final messages = snapshot.data!.docs;

//                 if (!_markedRead) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _markMessagesAsRead(snapshot.data!);
//                     _scrollToBottom();
//                   });
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index].data() as Map<String, dynamic>;
//                     final isMe = msg['senderId'] == user!.uid;
//                     final timestamp = msg['timestamp'] as Timestamp?;
//                     final time = timestamp != null
//                         ? DateFormat('hh:mm a').format(timestamp.toDate())
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
//                                   time,
//                                   style: TextStyle(
//                                     color: isMe
//                                         ? Colors.white70
//                                         : Colors.grey[600],
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                                 if (isMe) ...[
//                                   const SizedBox(width: 4),
//                                   Icon(
//                                     msg['read'] == true
//                                         ? Icons.done_all
//                                         : Icons.done,
//                                     size: 14,
//                                     color: msg['read'] == true
//                                         ? Colors.blueAccent
//                                         : Colors.white70,
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
//                   offset: Offset(0, -2),
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
//                       fillColor: const Color(0xFFF8F8FB),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
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

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserId;
  final String hostel_id;
  final String? hostelName;
  final String? roomNumber;
  final String? otherUserSubtitle;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserId,
    required this.hostel_id,
    this.hostelName,
    this.roomNumber,
    this.otherUserSubtitle,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  bool _markedRead = false;

  @override
  void initState() {
    super.initState();
    // FIXED: Reset student unread count when opening chat
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'unreadCountStudent': 0,
    });
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || user == null) return;

    _messageController.clear();
    _scrollToBottom();

    // 1. Message add
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'senderId': user!.uid,
          'text': text,
          'hostelId': widget.hostel_id,
          'hostelName': widget.hostelName,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadCountOwner': FieldValue.increment(1),
          'unreadCountStudent': 0,
        });

    // 2. Owner notification add
    await FirebaseFirestore.instance.collection('owner_notifications').add({
      'user_id': widget.otherUserId,
      'type': 'student_message',
      'title': 'New message from ${user!.displayName ?? 'Student'}',
      'desc': text,
      'time': FieldValue.serverTimestamp(),
      'read': false,
      'data': {
        'chat_id': widget.chatId,
        'student_id': user!.uid,
        'student_name': user!.displayName ?? 'Student',
        'hostel_id': widget.hostel_id,
        'hostel_name': widget.hostelName ?? '',
        'room_number': widget.roomNumber ?? '',
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

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['senderId'] != user!.uid && data['read'] == false) {
        batch.update(doc.reference, {'read': true});
        count++;
      }
    }

    if (count > 0) {
      await batch.commit();
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({'unreadCountStudent': 0});

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
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.otherUserName.isNotEmpty
                    ? widget.otherUserName[0].toUpperCase()
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
                    widget.otherUserName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.hostelName != null && widget.hostelName!.isNotEmpty
                        ? widget.hostelName!
                        : "Online",
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
                  return Center(
                    child: Text(
                      "No messages yet\nStart the conversation!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                if (!_markedRead) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markMessagesAsRead(snapshot.data!);
                    _scrollToBottom();
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == user!.uid;
                    final timestamp = msg['timestamp'] as Timestamp?;
                    final time = timestamp != null
                        ? DateFormat('hh:mm a').format(timestamp.toDate())
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
                                  time,
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    msg['read'] == true
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 14,
                                    color: msg['read'] == true
                                        ? Colors.blueAccent
                                        : Colors.white70,
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
                  offset: Offset(0, -2),
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
                      fillColor: const Color(0xFFF8F8FB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
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
