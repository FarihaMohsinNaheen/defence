import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_success_page.dart';

class BkashPaymentPage extends StatefulWidget {
  final int amount;
  final int selectedBeds;
  final int rentPerBed;
  final Map<String, dynamic> room;
  final String roomId;
  final Map<String, dynamic> hostel;
  final String ownerId;
  final String hostelName;
  final String studentName;
  final String studentPhone;
  final String studentEmail;
  final DateTime moveInDate;
  final String bookingId;
  final String businessName;

  const BkashPaymentPage({
    super.key,
    required this.amount,
    required this.selectedBeds,
    required this.rentPerBed,
    required this.room,
    required this.roomId,
    required this.hostel,
    required this.ownerId,
    required this.hostelName,
    required this.studentName,
    required this.studentPhone,
    required this.studentEmail,
    required this.moveInDate,
    required this.bookingId,
    required this.businessName,
  });

  @override
  State<BkashPaymentPage> createState() => _BkashPaymentPageState();
}

class _BkashPaymentPageState extends State<BkashPaymentPage> {
  final Color bkashPink = const Color(0xFFE2136E);
  final TextEditingController bkashNumberController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;
  final String demoPin = "12345";

  String s(dynamic val, [String def = '']) => val?.toString() ?? def;
  int i(dynamic val, [int def = 0]) {
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? def;
    return def;
  }

  void _confirmPayment() async {
    final number = bkashNumberController.text.trim();
    final pin = pinController.text.trim();
    final roomNumber = s(widget.room['room_number']);
    final ownerId = widget.ownerId;

    if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid bKash number 01XXXXXXXXX'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (pin.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter 5 digit bKash PIN'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (pin != demoPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid PIN. Demo PIN: 12345'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await Future.delayed(const Duration(seconds: 2));
      String transactionId = 'BK${DateTime.now().millisecondsSinceEpoch}';

      final bookingRef = FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final roomRef = FirebaseFirestore.instance
            .collection('rooms')
            .doc(widget.roomId);
        DocumentSnapshot roomSnap = await transaction.get(roomRef);
        if (!roomSnap.exists) throw Exception('Room not found');

        int totalBeds = i(roomSnap['beds'] ?? roomSnap['total_beds'], 1);
        int bookedBeds = i(roomSnap['booked_beds'], 0);

        if (widget.selectedBeds <= 0) {
          throw Exception('Please select at least 1 bed');
        }

        if (bookedBeds + widget.selectedBeds > totalBeds) {
          throw Exception(
            'Room $roomNumber is full now. Available: ${totalBeds - bookedBeds}',
          );
        }

        
        transaction.update(roomRef, {
          'booked_beds': bookedBeds + widget.selectedBeds,
        });

       
        transaction.set(bookingRef, {
          'booking_id': widget.bookingId,
          'student_id': user.uid,
          'owner_id': widget.ownerId,
          'room_id': widget.roomId,
          'hostel_id':
              widget.hostel['id'] ?? widget.roomId, 
          'hostel_name': widget.hostelName,
          'room_number': roomNumber,
          'businessName': widget.businessName,
          'monthly_rent': widget.rentPerBed,
          'beds_booked': widget.selectedBeds,
          'move_in_date': Timestamp.fromDate(widget.moveInDate),
          'status': 'Paid',
          'student_name': widget.studentName,
          'student_phone': widget.studentPhone,
          'student_email': widget.studentEmail
              .toLowerCase()
              .trim(), 
          'bkash_number': number,
          'payment_method': 'bKash',
          'transaction_id': transactionId,
          'paid_at': FieldValue.serverTimestamp(),
          'created_at': FieldValue.serverTimestamp(),
          'total_rent': widget.amount,
        });
      });

      // Owner  notification
      await FirebaseFirestore.instance.collection('notifications').add({
        'user_id': ownerId,
        'title': 'New Booking Paid',
        'desc':
            'Room $roomNumber - ${widget.selectedBeds} bed(s) paid Tk ${widget.amount}',
        'type': 'booking_paid',
        'booking_id': widget.bookingId,
        'time': FieldValue.serverTimestamp(),
        'read': false,
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessPage(
              hostelName: widget.hostelName,
              amount: widget.amount,
              selectedBeds: widget.selectedBeds,
              rentPerBed: widget.rentPerBed,
              studentName: widget.studentName,
              email: widget.studentEmail,
              phone: widget.studentPhone,
              roomNumber: roomNumber,
              moveInDate: widget.moveInDate,
              transactionId: transactionId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: bkashPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "bKash",
                style: TextStyle(
                  color: bkashPink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: bkashPink,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hostelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Room: ${s(widget.room['room_number'])} • ${widget.selectedBeds} bed(s)",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Amount Payable",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    "Tk ${widget.amount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter bKash Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: bkashNumberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    decoration: InputDecoration(
                      labelText: 'bKash Number',
                      hintText: '01XXXXXXXXX',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: bkashPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.phone_android,
                          color: bkashPink,
                          size: 20,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: bkashPink, width: 2),
                      ),
                      counterText: "",
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: InputDecoration(
                      labelText: 'bKash PIN',
                      hintText: 'Enter 5 digit PIN',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: bkashPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.lock, color: bkashPink, size: 20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: bkashPink, width: 2),
                      ),
                      counterText: "",
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bkashPink,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: isLoading ? null : _confirmPayment,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Confirm Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Demo PIN: 12345",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bkashNumberController.dispose();
    pinController.dispose();
    super.dispose();
  }
}
