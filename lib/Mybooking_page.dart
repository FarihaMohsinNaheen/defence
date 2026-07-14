import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/experiencedfeed_page.dart';
import 'dart:async';

import 'package:nan_nestfinder/home_page.dart';
import 'package:nan_nestfinder/review_page.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            );
          }
          if (snapshot.hasError) {
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
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _emptyState();
          }
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // FIX: Bookings is index 2. Removed state var.
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == 2) return; // FIX: Already on bookings
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (i == 1) {
            // FIX: Review is index 1
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReviewPage()),
            );
          } else if (i == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: "Experience",
          ),
        ],
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
      final diff = endTime.toLocal().difference(DateTime.now());
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

  Future<void> _showCancelDialog(
    String bookingId,
    Map data,
    int amount,
    bool refundApplicable,
  ) async {
    final reasonController = TextEditingController();
    final refundText = refundApplicable
        ? "Full refund: Tk $amount"
        : "No refund applicable. 24h window expired.";
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
              refundText,
              style: TextStyle(
                color: refundApplicable ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
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
    if (reason != null && reason.trim().isNotEmpty) {
      _cancelBooking(bookingId, data, reason, amount, refundApplicable);
    }
  }

  Future<void> _cancelBooking(
    String bookingId,
    Map data,
    String reason,
    int amount,
    bool refundApplicable,
  ) async {
    try {
      final String roomId = widget.g<String>(data, 'room_id', '');
      final String ownerId = widget.g<String>(data, 'owner_id', '');
      final String roomNumber = widget.g<String>(data, 'room_number', 'Room');
      final int bedsBooked = widget.g<int>(data, 'beds_booked', 1);
      final String hostelName = widget.g<String>(data, 'hostel_name', 'Hostel');
      final roomRef = FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId);

      final bool isApproved =
          widget.g<bool>(data, 'owner_approved', false) ||
          widget.g<String>(data, 'status', 'Paid').toLowerCase() == 'approved';

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
            'refund_status': refundApplicable ? 'pending' : 'not_applicable',
            'cancelReason': reason,
            'cancelled_at': FieldValue.serverTimestamp(),
          },
        );
      });

      if (isApproved && ownerId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('owner_notifications').add({
          'user_id': ownerId,
          'type': 'booking_cancelled',
          'title': 'Booking Cancelled ❌',
          'desc':
              '${widget.g<String>(data, 'student_name', 'Student')} cancelled booking at $hostelName, Room $roomNumber, ${bedsBooked} bed${bedsBooked > 1 ? 's' : ''}.',
          'time': FieldValue.serverTimestamp(),
          'read': false,
          'data': {'booking_id': bookingId},
        });
      }

      final snackText = refundApplicable
          ? "Booking cancelled successfully! You will get back your money in 1 day to the same bKash number from which you made the payment."
          : "Booking cancelled! No refund as 24h window expired.";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackText,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  String getChatId(String uid1, String uid2) {
    var ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = widget.doc.id;

    final data = widget.doc.data() as Map<String, dynamic>;

    final hostelName = data['hostelName'] ?? data['hostel_name'] ?? 'Hostel';
    final roomNumber = data['roomNumber'] ?? data['room_number'] ?? 'Room';
    final businessName =
        data['businessName'] ?? data['business_name'] ?? 'Business';
    final perBedPrice = data['monthlyRent'] ?? data['monthly_rent'] ?? 0;
    final bedsBooked = data['bedsBooked'] ?? data['beds_booked'] ?? 1;
    final status = data['status'] ?? 'Paid';
    final ownerId = data['ownerId'] ?? data['owner_id'] ?? '';
    final hostelId = data['hostelId'] ?? data['hostel_id'] ?? '';
    // REMOVED: final ownerName - unused
    // REMOVED: final canCancel - unused

    final totalAmount = perBedPrice * bedsBooked;
    final paidTime = (data['paidAt'] ?? data['paid_at'] ?? Timestamp.now())
        .toDate();
    final checkInDate = (data['moveInDate'] ?? data['move_in_date'])?.toDate();
    final isWithin24Hours = _remaining.inSeconds > 0;
    final isNotFinal = ![
      'rejected',
      'cancelled',
    ].contains(status.toLowerCase());
    final refundApplicable = isWithin24Hours;

    // REMOVED: final showChat - unused
    final statusText = _getStatusText(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNotFinal)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF90CAF9)),
              ),
              child: Text(
                refundApplicable
                    ? "Cancel within 24 hours of payment for a full refund."
                    : "24 hour refund window has ended. Cancellation will not refund payment.",
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF0D47A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
                    // ignore: deprecated_member_use
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
            "Paid: ${DateFormat('dd MMM, hh:mm a').format(paidTime.toLocal())}",
          ),

          if (isNotFinal) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: refundApplicable
                    // ignore: deprecated_member_use
                    ? Colors.orange.withOpacity(0.1)
                    // ignore: deprecated_member_use
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    refundApplicable ? Icons.timer : Icons.lock_clock,
                    size: 18,
                    color: refundApplicable
                        ? Colors.orange[700]
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      refundApplicable
                          ? "Cancel window: ${_formatDuration(_remaining)}"
                          : "No refund after 24h",
                      style: TextStyle(
                        fontSize: 13,
                        color: refundApplicable
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
          if (isNotFinal)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(
                  bookingId,
                  data,
                  totalAmount,
                  refundApplicable,
                ),
                icon: Icon(Icons.cancel, size: 18, color: Colors.red),
                label: Text(
                  "Cancel Booking",
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
