import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OwnerPaymentPage extends StatefulWidget {
  const OwnerPaymentPage({super.key});

  @override
  State<OwnerPaymentPage> createState() => _OwnerPaymentPageState();
}

class _OwnerPaymentPageState extends State<OwnerPaymentPage>
    with SingleTickerProviderStateMixin {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  Set<String> selectedBookingIds = {};
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedBookingIds.clear(); // tab change করলে selection clear
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double ownerAmount(Map<String, dynamic> data) {
    // Tk 0 fix: total_rent না থাকলে monthly_rent check করবে
    final totalRent = (data['total_rent'] ?? data['monthly_rent'] ?? 0)
        .toDouble();
    final adminCommission = (data['adminCommission'] ?? data['commission'] ?? 0)
        .toDouble();
    final result = totalRent - adminCommission;
    return result > 0 ? result : 0; // negative না যায়
  }

  Future<void> _payToOwner() async {
    if (selectedBookingIds.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    for (String id in selectedBookingIds) {
      batch.update(FirebaseFirestore.instance.collection('bookings').doc(id), {
        'payout_status': 'paid',
        'payoutDate': FieldValue.serverTimestamp(), // payoutDate use করছি
      });
    }
    await batch.commit();

    setState(() => selectedBookingIds.clear());
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Payment done to owner")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    final payoutFilter = _tabController.index == 0 ? 'pending' : 'paid';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'Owner Payments',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Paid'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('owner_id', isEqualTo: user!.uid)
            .where('status', isEqualTo: 'approved')
            .where('payout_status', isEqualTo: payoutFilter) // Filter must
            .orderBy('approved_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No ${payoutFilter} payments yet',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          final totalEarned = docs.fold<double>(
            0,
            (sum, doc) => sum + ownerAmount(doc.data() as Map<String, dynamic>),
          );

          // Summary এর জন্য সব doc লাগবে, তাই আলাদা stream লাগবে না।
          // এখানে শুধু current tab এর total দেখাবো
          final pendingAmount = payoutFilter == 'pending' ? totalEarned : 0;
          final paidAmount = payoutFilter == 'paid' ? totalEarned : 0;

          return Column(
            children: [
              // 1. Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Total', 'Tk ${totalEarned.toInt()}'),
                    _buildSummaryItem('Pending', 'Tk ${pendingAmount.toInt()}'),
                    _buildSummaryItem('Paid', 'Tk ${paidAmount.toInt()}'),
                  ],
                ),
              ),

              // 2. Payment List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final docId = docs[index].id;
                    final data = docs[index].data() as Map<String, dynamic>;
                    final hostelName = data['hostelName'] ?? 'Unknown Hostel';
                    final roomNo = data['room_number'] ?? '';
                    final amount = ownerAmount(data);
                    final payoutStatus = data['payout_status'] ?? 'pending';
                    final isPaid = payoutStatus == 'paid';

                    final payoutDate = data['payoutDate'] as Timestamp?;
                    final dateText = payoutDate != null
                        ? DateFormat('dd MMM, yyyy').format(payoutDate.toDate())
                        : 'Not paid yet';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Checkbox শুধু pending tab এ
                            if (payoutFilter == 'pending')
                              Checkbox(
                                value: selectedBookingIds.contains(docId),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedBookingIds.add(docId);
                                    } else {
                                      selectedBookingIds.remove(docId);
                                    }
                                  });
                                },
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$hostelName - Room $roomNo",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Payout Date: $dateText'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Tk ${amount.toInt()}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPaid
                                        ? Colors.green
                                        : primaryBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isPaid ? 'Paid ✓' : 'Pending',
                                    style: TextStyle(
                                      color: isPaid
                                          ? Colors.white
                                          : primaryBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 3. Pay Button শুধু pending tab + কিছু select করলে
              if (payoutFilter == 'pending' && selectedBookingIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _payToOwner,
                      child: Text(
                        'Pay to Owner (${selectedBookingIds.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
