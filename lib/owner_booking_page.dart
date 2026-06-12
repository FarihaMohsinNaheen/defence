import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- add koren
import 'owner_dashboard_page.dart';
import 'owner_bookingcard_page.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerBookingsPage extends StatelessWidget {
  const OwnerBookingsPage({
    super.key,
    required String owner_id,
  }); // ownerId parameter lagbe na

  @override
  Widget build(BuildContext context) {
    final ownerId =
        FirebaseAuth.instance.currentUser!.uid; // <-- current user er UID

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OwnerDashboardPage()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Approved Bookings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('owner_id', isEqualTo: ownerId) // <-- lowercase i
            .where('status', isEqualTo: 'approved')
            .orderBy('paid_at', descending: true) // <-- paid_at underscore
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryBlue));
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Error: ${snapshot.error}\n\nfor Index Click the link',
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(
                    'No approve bookings ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'owner_id: $ownerId',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ), // debug
                ],
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              booking['id'] = bookings[index].id; // doc id add korlam
              return OwnerBookingCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}
