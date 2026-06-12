import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'chat_page.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _bookingsStream;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _bookingsStream = FirebaseFirestore.instance
          .collection('bookings')
          .where('student_id', isEqualTo: user!.uid)
          .orderBy('paid_at', descending: true)
          .snapshots();
    }
  }

  T g<T>(Map data, String key, T def) {
    final val = data[key];
    if (val == null) return def;
    return (val is T) ? val : def;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFEAF4FF),
        appBar: AppBar(
          backgroundColor: primaryBlue,
          title: const Text(
            "My Bookings",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Bookings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            );
          if (snapshot.hasError)
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Error: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            );
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return _emptyState();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs
                .map(
                  (doc) => _BookingCard(
                    doc: doc,
                    primaryBlue: primaryBlue,
                    user: user!,
                    g: g,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_online_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No bookings yet",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Logged in as: ${user?.email}",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  final Color primaryBlue;
  final User user;
  final T Function<T>(Map, String, T) g;
  const _BookingCard({
    required this.doc,
    required this.primaryBlue,
    required this.user,
    required this.g,
  });

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final data = widget.doc.data() as Map<String, dynamic>;
    final paidTime = widget
        .g<Timestamp>(data, 'paid_at', Timestamp.now())
        .toDate();
    final status = widget.g<String>(data, 'status', 'Paid').toLowerCase();
    if (['rejected', 'cancelled'].contains(status)) return;
    final endTime = paidTime.add(const Duration(hours: 24));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final diff = endTime.difference(DateTime.now());
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
      if (diff.isNegative) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getStatusText(String status) {
    status = status.toLowerCase();
    if (status == 'confirmed') return 'CONFIRMED';
    if (status == 'rejected') return 'REJECTED';
    if (status == 'cancelled') return 'CANCELLED';
    return '';
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase();
    if (status == 'confirmed') return Colors.green;
    if (status == 'rejected' || status == 'cancelled') return Colors.red;
    return Colors.grey;
  }

  IconData _getStatusIcon(String status) {
    status = status.toLowerCase();
    if (status == 'confirmed') return Icons.check_circle;
    if (status == 'rejected' || status == 'cancelled') return Icons.cancel;
    return Icons.info;
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(String bookingId, Map data, int amount) async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Cancel Booking?",
          style: TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Full refund: Tk $amount",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Reason",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                hintText: "Why cancelling...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Back",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, reasonController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Confirm Cancel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
    if (reason != null && reason.trim().isNotEmpty)
      _cancelBooking(bookingId, data, reason, amount);
  }

  Future<void> _cancelBooking(
    String bookingId,
    Map data,
    String reason,
    int amount,
  ) async {
    try {
      final String roomId = widget.g<String>(data, 'room_id', '');
      final String ownerId = widget.g<String>(data, 'owner_id', '');
      final String roomNumber = widget.g<String>(data, 'room_number', 'Room');
      final int bedsBooked = widget.g<int>(data, 'beds_booked', 1);
      final roomRef = FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot roomSnap = await transaction.get(roomRef);
        if (roomSnap.exists) {
          int bookedBeds = widget.g<int>(
            roomSnap.data() as Map,
            'booked_beds',
            0,
          );
          int newBookedBeds = bookedBeds - bedsBooked;
          if (newBookedBeds < 0) newBookedBeds = 0;
          transaction.update(roomRef, {'booked_beds': newBookedBeds});
        }
        transaction.update(
          FirebaseFirestore.instance.collection('bookings').doc(bookingId),
          {
            'status': 'cancelled',
            'refund_status': 'pending',
            'cancelReason': reason,
            'cancelled_at': FieldValue.serverTimestamp(),
          },
        );
      });

      if (ownerId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'user_id': ownerId,
          'type': 'booking',
          'title': 'Booking Cancelled ❌',
          'desc':
              '${widget.user.displayName ?? widget.user.email?.split('@')[0] ?? 'Student'} cancelled Room $roomNumber. Refund Tk $amount to bKash: ${data['bkash_number'] ?? 'N/A'}',
          'time': FieldValue.serverTimestamp(),
          'read': false,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Booking cancelled successfully! You will get back your money in 10 minutes to the same bKash number from which you made the payment.",
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.doc.data() as Map<String, dynamic>;
    final bookingId = widget.doc.id;

    final hostelName = widget.g<String>(data, 'hostel_name', 'Hostel');
    final roomNumber = widget.g<String>(data, 'room_number', 'Room');
    final businessName = widget.g<String>(data, 'businessName', 'Business');
    final perBedPrice = widget.g<int>(data, 'monthly_rent', 0);
    final bedsBooked = widget.g<int>(data, 'beds_booked', 1);
    final totalAmount = perBedPrice * bedsBooked;
    final status = widget.g<String>(data, 'status', 'Paid');
    final paidTime = widget
        .g<Timestamp>(data, 'paid_at', Timestamp.now())
        .toDate();
    final checkInDate = widget
        .g<Timestamp?>(data, 'move_in_date', null)
        ?.toDate();
    final ownerId = widget.g<String>(data, 'owner_id', '');
    final ownerName = widget.g<String>(data, 'businessName', 'Owner');
    final hostelId = widget.g<String>(data, 'hostel_id', '');

    final isWithin24Hours = _remaining.inSeconds > 0;
    final isNotFinal = ![
      'rejected',
      'cancelled',
    ].contains(status.toLowerCase());
    final canCancel = isWithin24Hours && isNotFinal;

    // FIX: Chat button er jonno status check bad. ownerId+hostelId thaklei dekhabe
    final showChat = ownerId.isNotEmpty && hostelId.isNotEmpty;
    final statusText = _getStatusText(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hostelName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryBlue,
                  ),
                ),
              ),
              if (statusText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        size: 16,
                        color: _getStatusColor(status),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(
            Icons.bed,
            "Room $roomNumber • $bedsBooked bed${bedsBooked > 1 ? 's' : ''}",
          ),
          _infoRow(Icons.store, "Business: $businessName"),
          _infoRow(
            Icons.payments,
            "Tk $perBedPrice x $bedsBooked = Tk $totalAmount/month",
          ),
          if (checkInDate != null)
            _infoRow(
              Icons.calendar_today,
              "Check-in: ${DateFormat('dd MMM yyyy').format(checkInDate)}",
            ),
          _infoRow(
            Icons.access_time,
            "Paid: ${DateFormat('dd MMM, hh:mm a').format(paidTime)}",
          ),

          if (isWithin24Hours || status.toLowerCase() == 'paid') ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: canCancel
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    canCancel ? Icons.timer : Icons.lock_clock,
                    size: 18,
                    color: canCancel ? Colors.orange[700] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      canCancel
                          ? "Cancel window: ${_formatDuration(_remaining)}"
                          : "Cancel time expired",
                      style: TextStyle(
                        fontSize: 13,
                        color: canCancel
                            ? Colors.orange[700]
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              if (isNotFinal)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: canCancel
                        ? () => _showCancelDialog(bookingId, data, totalAmount)
                        : null,
                    icon: Icon(
                      Icons.cancel,
                      size: 18,
                      color: canCancel ? Colors.red : Colors.grey,
                    ),
                    label: Text(
                      canCancel ? "Cancel Booking" : "Cancel Expired",
                      style: TextStyle(
                        color: canCancel ? Colors.red : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: canCancel ? Colors.red : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

              if (showChat) ...[
                if (isNotFinal) const SizedBox(width: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final chatId = '${widget.user.uid}_${ownerId}_$hostelId';
                      return ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              chatId: chatId,
                              otherUserId: ownerId,
                              otherUserName: ownerName,
                              hostel_id: hostelId,
                              hostelName: hostelName,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Chat with Owner",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
