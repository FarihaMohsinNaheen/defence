import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/experiencedfeed_page.dart';
import 'package:nan_nestfinder/roleselection_page.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

final Color primaryBlue = const Color(0xFF003366);

class _AdminPanelPageState extends State<AdminPanelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const Color primaryBlue = Color(0xFF003366);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
          ),
        ),
        title: const Text(
          "Admin Panel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Hostels'),
            Tab(text: 'Payments'),
            Tab(text: 'Review'),
            Tab(text: 'Cancellations'),
            Tab(text: 'Payouts'),
            Tab(text: 'Earning'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHostelsTab(),
          _buildPaymentsTab(),
          const ExperienceFeedPage(isAdminPanel: true),
          _buildCancellationsTab(),
          _buildPayoutsTab(),
          _buildEarningsTab(),
        ],
      ),
    );
  }

  Widget _buildHostelsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hostels')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No hostels registered yet",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final hostels = snapshot.data!.docs;
        final pendingCount = hostels
            .where((d) => (d['status'] ?? 'pending') == 'pending')
            .length;
        final approvedCount = hostels
            .where((d) => d['status'] == 'approved')
            .length;
        final rejectedCount = hostels
            .where((d) => d['status'] == 'rejected')
            .length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _statCard("Total", hostels.length.toString(), Colors.blue),
                  _statCard("Pending", pendingCount.toString(), Colors.orange),
                  _statCard("Approved", approvedCount.toString(), Colors.green),
                  _statCard("Rejected", rejectedCount.toString(), Colors.red),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: hostels.length,
                itemBuilder: (context, index) {
                  final doc = hostels[index];
                  final hostel = doc.data() as Map<String, dynamic>;
                  final hostelId = doc.id;
                  final name = hostel['name'] ?? 'N/A';
                  final location = hostel['location'] ?? 'N/A';
                  final area = hostel['area'] ?? 'N/A';
                  final imageUrl = hostel['image_building'] ?? '';
                  final status = hostel['status'] ?? 'N/A';
                  final ownerId = hostel['owner_id'] ?? '';

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(ownerId)
                        .get(),
                    builder: (context, userSnap) {
                      String ownerName = hostel['owner_email'] ?? 'N/A';
                      String ownerEmail = hostel['owner_email'] ?? 'N/A';
                      String ownerPhone = 'N/A';
                      String businessName = hostel['business_name'] ?? 'N/A';

                      if (userSnap.hasData && userSnap.data!.exists) {
                        final userData =
                            userSnap.data!.data() as Map<String, dynamic>;
                        ownerName = userData['name'] ?? ownerName;
                        ownerEmail = userData['email'] ?? ownerEmail;
                        ownerPhone = userData['phone'] ?? 'N/A';
                        businessName = userData['businessName'] ?? businessName;
                      }

                      bool isApproved = status == 'approved';
                      bool isRejected = status == 'rejected';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(
                            0.06,
                          ), // <-- Vitor sudhu ekta light blue color, gradient nai
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: primaryBlue.withOpacity(0.6),
                            width: 2,
                          ), 
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showHostelDetailsDialog(
                              context,
                              hostel,
                              hostelId,
                              ownerName,
                              ownerEmail,
                              ownerPhone,
                              businessName,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: primaryBlue.withOpacity(0.2),
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(
                                                  imageUrl,
                                                  width: 85,
                                                  height: 85,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 85,
                                                  height: 85,
                                                  color: primaryBlue
                                                      .withOpacity(0.08),
                                                  child: Icon(
                                                    Icons.business,
                                                    color: primaryBlue,
                                                    size: 40,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      // Text part
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w800,
                                                color: primaryBlue,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  location,
                                                  style: TextStyle(
                                                    fontSize: 14.5,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.place_outlined,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  area,
                                                  style: TextStyle(
                                                    fontSize: 14.5,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(
                                    height: 1,
                                    color: Colors.black12,
                                  ),
                                  const SizedBox(height: 12),

                                  // 3. Approve/Reject buttons
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Approve button also updates all rooms
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final batch = FirebaseFirestore
                                                  .instance
                                                  .batch();

                                              // 1. Hostel approve
                                              final hostelRef =
                                                  FirebaseFirestore.instance
                                                      .collection('hostels')
                                                      .doc(hostelId);
                                              batch.update(hostelRef, {
                                                'status': 'approved',
                                                'approvedAt':
                                                    FieldValue.serverTimestamp(),
                                              });

                                              // 2. all room together approve
                                              final roomsSnap =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('rooms')
                                                      .where(
                                                        'hostel_id',
                                                        isEqualTo: hostelId,
                                                      )
                                                      .get();

                                              for (final roomDoc
                                                  in roomsSnap.docs) {
                                                batch.update(roomDoc.reference, {
                                                  'status': 'approved',
                                                  'approvedAt':
                                                      FieldValue.serverTimestamp(),
                                                });
                                              }

                                              //notification part
                                              final students =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where(
                                                        'role',
                                                        isEqualTo: 'student',
                                                      )
                                                      .get();

                                              for (var student
                                                  in students.docs) {
                                                await FirebaseFirestore.instance
                                                    .collection('notifications')
                                                    .add({
                                                      'user_id': student.id,
                                                      'type': 'new_hostel',
                                                      'title':
                                                          'New Hostel Available!',
                                                      'desc':
                                                          '$name has been added near you. Check it out now.',
                                                      'time':
                                                          FieldValue.serverTimestamp(),
                                                      'read': false,
                                                      'data': {
                                                        'hostel_id': hostelId,
                                                      },
                                                    });
                                              } //

                                              //  OWNER notification
                                              final ownerNotifRef =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                        'owner_notifications',
                                                      )
                                                      .doc();
                                              batch.set(ownerNotifRef, {
                                                'user_id':
                                                    ownerId, // hostel doc থেকে পাওয়া owner_id
                                                'type': 'hostel_approved',
                                                'title': 'Hostel Approved!',
                                                'desc':
                                                    '$name is now live on NestFinder',
                                                'data': {'hostel_id': hostelId},
                                                'time':
                                                    FieldValue.serverTimestamp(),
                                                'read': false,
                                              });
                                              await batch.commit();

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '$name + ${roomsSnap.docs.length} room Approved ✅',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              debugPrint("Approve error: $e");
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Occurs Problem during approving: $e',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isApproved
                                                ? Colors.green
                                                : Colors.blue,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(90, 36),
                                          ),
                                          child: Text(
                                            isApproved ? 'Approved' : 'Approve',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final batch = FirebaseFirestore
                                                  .instance
                                                  .batch();

                                              // 1. Hostel reject
                                              final hostelRef =
                                                  FirebaseFirestore.instance
                                                      .collection('hostels')
                                                      .doc(hostelId);
                                              batch.update(hostelRef, {
                                                'status': 'rejected',
                                                'rejectedAt':
                                                    FieldValue.serverTimestamp(),
                                              });

                                              // 2.all room together reject
                                              final roomsSnap =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('rooms')
                                                      .where(
                                                        'hostel_id',
                                                        isEqualTo: hostelId,
                                                      )
                                                      .get();

                                              for (final roomDoc
                                                  in roomsSnap.docs) {
                                                batch.update(roomDoc.reference, {
                                                  'status': 'rejected',
                                                  'rejectedAt':
                                                      FieldValue.serverTimestamp(), 
                                                });
                                              }

                                              // 3. one commit all done
                                              await batch.commit();

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '$name + ${roomsSnap.docs.length} room Rejected ❌',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              debugPrint("Reject error: $e");
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Problem occurs during rejection: $e',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(90, 36),
                                          ),
                                          child: Text(
                                            isRejected ? 'Rejected' : 'Reject',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showHostelDetailsDialog(
    BuildContext context,
    Map<String, dynamic> hostel,
    String hostelId,
    String ownerName,
    String ownerEmail,
    String ownerPhone,
    String businessName,
  ) {
    final location = hostel['location'] ?? 'Sylhet';
    final area = hostel['area'] ?? 'Subidbazar';
    final imageUrl = hostel['image_building'] ?? '';

    final facilityMap = {
      'WiFi': hostel['wifi'] ?? false,
      'CCTV Security': hostel['security_cctv'] ?? false,
      'Laundry': hostel['laundry'] ?? false,
      'Drinking Water': hostel['drinking_water'] ?? false,
      'Meal Service': hostel['meal_service'] ?? false,
    };

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E3A5F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 450,
          constraints: const BoxConstraints(maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hostel['name'] ?? 'Green View',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogRow("Location:", location),
                      _dialogRow("Area:", area),
                      const SizedBox(height: 20),
                      const Text(
                        "Owner Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _dialogRow("Name:", ownerName),
                      _dialogRow("Business Name:", businessName),
                      _dialogRow("Email:", ownerEmail),
                      _dialogRow("Phone:", ownerPhone),
                      const SizedBox(height: 20),
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            "Facilities",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._allFacilities.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                facilityMap[f] == true
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: facilityMap[f] == true
                                    ? Colors.green
                                    : Colors.red,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                f,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Room Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .where('hostel_id', isEqualTo: hostelId)
                            .snapshots(),
                        builder: (context, roomSnap) {
                          if (roomSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          if (roomSnap.hasError) {
                            return Text(
                              "Error: ${roomSnap.error}",
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          if (!roomSnap.hasData ||
                              roomSnap.data!.docs.isEmpty) {
                            return const Text(
                              "No rooms added",
                              style: TextStyle(color: Colors.white70),
                            );
                          }
                          final rooms = roomSnap.data!.docs;
                          rooms.sort((a, b) {
                            final numA =
                                int.tryParse(
                                  a['room_number']?.toString() ?? '0',
                                ) ??
                                0;
                            final numB =
                                int.tryParse(
                                  b['room_number']?.toString() ?? '0',
                                ) ??
                                0;
                            return numA.compareTo(numB);
                          });

                          return Column(
                            children: rooms.map((roomDoc) {
                              final room =
                                  roomDoc.data() as Map<String, dynamic>;
                              return _roomExpansionTile(room);
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roomExpansionTile(Map<String, dynamic> room) {
    final roomNumber = room['room_number'] ?? '101';
    final type = room['room_type'] ?? 'Single Room';
    final rent = room['monthly_rent'] ?? 3500;

    final roomImages = List<String>.from(room['room_images'] ?? []);
    final roomImage = roomImages.isNotEmpty ? roomImages[0] : '';

    final available = room['is_available'] ?? true;
  
    final beds = room['beds'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4A70),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Room $roomNumber",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$type • Tk$rent/month",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (roomImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      roomImage,
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: Colors.grey[700],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _dialogRow("Rent:", "Tk$rent/month"),
                _dialogRow("Type:", type),
                _dialogRow("Room No:", roomNumber),
                _dialogRow("Available:", available ? "Yes" : "No"),
                
                _dialogRow("Total Beds:", "$beds"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<String> _allFacilities = [
    'WiFi',
    'CCTV Security',
    'Laundry',
    'Drinking Water',
    'Meal Service',
  ];

  //Review Tab

  Widget _buildReviewTab(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Payment Tab

  Widget _buildPaymentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where(
            'status',
            whereIn: ['Paid', 'Confirmed', 'paid', 'confirmed', 'approved'],
          )
          .orderBy('paid_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildReviewTab("No payment yet", Icons.payments_outlined);
        }

        final payments = snapshot.data!.docs;
        final totalAmount = payments.fold<int>(0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          final perBed = (data['monthly_rent'] ?? 0) as int;
          final beds = (data['beds_booked'] ?? 1) as int;
          return sum + (perBed * beds);
        });

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "${payments.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Total Payments",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Tk $totalAmount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Revenue",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final doc = payments[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final bookingId = doc.id;

                  final hostelName = data['hostel_name'] ?? 'Hostel';
                  final studentName = data['student_name'] ?? 'N/A';
                  final studentEmail = data['student_email'] ?? 'N/A';
                  final studentPhone = data['student_phone'] ?? 'N/A';
                  final bkashNumber = data['bkash_number'] ?? 'N/A';
                  final roomNumber = data['room_number'] ?? 'Room';
                  final perBedPrice = (data['monthly_rent'] ?? 0) as int;
                  final bedsBooked = (data['beds_booked'] ?? 1) as int;
                  final total = perBedPrice * bedsBooked;
                  final ownerApproved = data['owner_approved'] ?? false;
                  final ts =
                      data['paid_at'] ?? data['created_at'] ?? Timestamp.now();
                  final date = (ts as Timestamp).toDate();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hostelName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Room $roomNumber",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Tk $total",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ownerApproved
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ownerApproved ? 'APPROVED' : 'PAID',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ownerApproved
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _infoRow("Student Name:", studentName),
                          _infoRow("Student Email:", studentEmail),
                          _infoRow("Student Phone:", studentPhone),
                          _infoRow("bKash Number:", bkashNumber),
                          _infoRow(
                            "Beds Booked:",
                            "$bedsBooked bed${bedsBooked > 1 ? 's' : ''}",
                          ),
                          _infoRow("Monthly Rent:", "Tk $perBedPrice"),
                          _infoRow(
                            "Payment Date:",
                            DateFormat('dd MMM yyyy, hh:mm a').format(date),
                          ),
                          _infoRow(
                            "Payment Method:",
                            data['payment_method'] ?? 'bKash',
                          ),
                          if (data['transaction_id'] != null)
                            _infoRow("Transaction ID:", data['transaction_id']),
                          const SizedBox(height: 12),
                          // FIXED BUTTON - approve korle disable hoye jabe, row thakbe
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                            
                              onPressed: ownerApproved
                                  ? null
                                  : () async {
                                      try {
                                        final monthly_rent =
                                            (data['monthly_rent'] ??
                                                    data['rent'] ??
                                                    0)
                                                as num;
                                        final beds_booked =
                                            (data['beds_booked'] ?? 1)
                                                as num; // default 1 bed

                                        // 2. Int convert 
                                        final int rent = monthly_rent.toInt();
                                        final int beds = beds_booked.toInt();

                                        final int total_rent = rent * beds;

                                        final commission =
                                            (total_rent * 10) ~/
                                            100; // Admin 10%
                                        final ownerAmount =
                                            total_rent -
                                            commission; // Owner 90%

                                        final payoutDate = DateTime.now().add(
                                          Duration(seconds: 20),
                                        );

                                        // 1. Booking update
                                        await FirebaseFirestore.instance
                                            .collection('bookings')
                                            .doc(bookingId)
                                            .update({
                                              'owner_approved': true,
                                              'status': 'approved',
                                              'approved_at':
                                                  FieldValue.serverTimestamp(),
                                              'payoutDate': Timestamp.fromDate(
                                                payoutDate,
                                              ),
                                              'hostelName':
                                                  data['hostel_name'] ??
                                                  'Unknown Hostel',
                                              'total_rent': total_rent,
                                              'ownerAmount': ownerAmount,
                                              'adminCommission': commission,
                                              'payout_status': 'pending',
                                            });

                                        // 2.  Owner  notification 
                                        final ownerId =
                                            data['owner_id']; 
                                        final studentName =
                                            data['student_name'] ?? 'A student';
                                        final hostelName =
                                            data['hostel_name'] ??
                                            'your hostel';
                                        final roomNo = data['room_no'] ?? '';

                                        if (ownerId != null) {
                                          await FirebaseFirestore.instance
                                              .collection('owner_notifications')
                                              .add({
                                                'user_id': ownerId,
                                                'type': 'new_booking',
                                                'title':
                                                    'New Booking Received!',
                                                'desc':
                                                    '$studentName booked $roomNo in $hostelName',
                                                'data': {
                                                  'booking_id': bookingId,
                                                  'student_id':
                                                      data['student_id'],
                                                  'student_name': studentName,
                                                  'hostel_id':
                                                      data['hostel_id'],
                                                  'hostel_name': hostelName,
                                                  'room_no': roomNo,
                                                  'total_rent': total_rent,
                                                },
                                                'time':
                                                    FieldValue.serverTimestamp(),
                                                'read': false,
                                              });
                                        }

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '$studentName booking is approved ✅',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint("Approve error: $e");
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              icon: Icon(
                                ownerApproved ? Icons.verified : Icons.check,
                                size: 18,
                              ),
                              label: Text(
                                ownerApproved
                                    ? "Owner Approved ✅"
                                    : "Approve Booking",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ownerApproved
                                    ? Colors.grey.shade400
                                    : Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Cancellation Tab

  Widget _buildCancellationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where(
            'status',
            whereIn: [
              'Cancelled',
              'Rejected',
              'Expired',
              'cancelled',
              'rejected',
              'expired',
            ],
          )
          .orderBy('cancelled_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildReviewTab("No cancellation yet", Icons.cancel_outlined);
        }

        final cancellations = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cancellations.length,
          itemBuilder: (context, index) {
            final doc = cancellations[index];
            final data = doc.data() as Map<String, dynamic>;
            String studentName = data['student_name'] ?? 'N/A';
            String studentEmail = data['student_email'] ?? 'N/A';
            String studentPhone = data['student_phone'] ?? 'N/A';
            String bkashNumber = data['bkash_number'] ?? 'N/A';
            final hostelName = data['hostel_name'] ?? 'Hostel';
            final roomNumber = data['room_number'] ?? 'N/A';
            final bedsBooked = (data['beds_booked'] ?? 1) as int;
            final monthlyRent = (data['monthly_rent'] ?? 0) as int;
            final totalAmount = monthlyRent * bedsBooked;
            final reason = data['cancelReason'] ?? 'No reason given';
            final refundAmount = (data['refund_amount'] ?? totalAmount) as int;
            final refundStatus = data['refund_status'] ?? '';
            final cancelDate =
                (data['cancelled_at'] as Timestamp?)?.toDate() ??
                DateTime.now();
            final bookingDate =
                (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now();

            // 24h check for refund
            final canRefund =
                DateTime.now().difference(bookingDate).inHours < 24;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hostelName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Room $roomNumber",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _infoRow("Student Name:", studentName),
                    _infoRow("Student Email:", studentEmail),
                    _infoRow("Student Phone:", studentPhone),
                    _infoRow("bKash Number:", bkashNumber),
                    _infoRow("Room No:", roomNumber),
                    _infoRow(
                      "Beds Booked:",
                      "$bedsBooked bed${bedsBooked > 1 ? 's' : ''}",
                    ),
                    _infoRow(
                      "Booking Date:",
                      DateFormat('dd MMM yyyy, hh:mm a').format(bookingDate),
                    ),
                    _infoRow(
                      "Cancelled On:",
                      DateFormat('dd MMM yyyy, hh:mm a').format(cancelDate),
                    ),
                    const Divider(height: 20),
                    _infoRow("Monthly Rent:", "Tk $monthlyRent"),
                    _infoRow("Total Amount:", "Tk $totalAmount", bold: true),
                    if (refundAmount > 0)
                      _infoRow(
                        "Refund Amount:",
                        "Tk $refundAmount",
                        color: Colors.green,
                      ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.orange[900],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Cancellation Reason",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reason,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (refundStatus != 'refunded' &&
                              refundAmount > 0 &&
                              canRefund) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _showRefundDialog(
                                  context,
                                  doc.id,
                                  studentName,
                                  bkashNumber,
                                  refundAmount,
                                  hostelName,
                                ),
                                icon: const Icon(
                                  Icons.currency_exchange,
                                  size: 18,
                                ),
                                label: const Text("Refund Money"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[700],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ] else if (refundStatus == 'refunded') ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[900],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Refunded Tk $refundAmount ✅",
                                    style: TextStyle(
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (refundAmount > 0 && !canRefund) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Refund Window Expired",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRefundDialog(
    BuildContext context,
    String bookingId,
    String studentName,
    String bkashNumber,
    int amount,
    String hostelName,
  ) {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool loading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> processRefund() async {
              if (pinController.text.isEmpty || pinController.text.length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("5 digit PIN din"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              setState(() => loading = true);
              await Future.delayed(const Duration(seconds: 2));

              // Firestore update
              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(bookingId)
                  .update({
                    'refund_status': 'refunded',
                    'refunded_at': FieldValue.serverTimestamp(),
                  });

              await FirebaseFirestore.instance.collection('refunds').add({
                'booking_id': bookingId,
                'student_name': studentName,
                'bkash_number': bkashNumber,
                'amount': amount,
                'hostel_name': hostelName,
                'refunded_at': FieldValue.serverTimestamp(),
              });

              // NEW: Student  notification 
              final bookingDoc = await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(bookingId)
                  .get();
              final studentUid = bookingDoc.get('student_id');

              await FirebaseFirestore.instance.collection('notifications').add({
                'user_id': studentUid,
                'type': 'refund',
                'title': 'Refund Processed',
                'desc':
                    'Tk $amount refunded for $hostelName to bKash: $bkashNumber',
                'time': FieldValue.serverTimestamp(),
                'read': false,
                'data': {'booking_id': bookingId, 'amount': amount},
              });

              setState(() => loading = false);
              if (mounted) {
                Navigator.pop(context); // 1. bKash dialog close

                // 2. Success dialog show 
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Payment Successful",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Tk $amount refunded to $bkashNumber"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop(); // <-- dialog close
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            }

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade300, Colors.pink.shade700],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "bKash Send Money",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: TextEditingController(
                              text: "Tk $amount",
                            ),
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Recipient bKash Number",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: TextEditingController(
                              text: bkashNumber,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.pink,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Enter PIN",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: pinController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            decoration: InputDecoration(
                              hintText: "*****",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              counterText: "",
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: loading ? null : processRefund,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Send Money",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // PAYOUTS TAB

  Widget _buildPayoutsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'approved')
          .orderBy('payoutDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Firebase Index Required\nCreate index from terminal link",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  "No approved bookings yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;
        Map<String, List<Map<String, dynamic>>> hostelData = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final payoutTimestamp = data['payoutDate'] as Timestamp?;
          if (payoutTimestamp == null) continue;

          final hostelName =
              (data['hostelName'] ?? data['name'] ?? 'Unknown Hostel')
                  as String;
          if (!hostelData.containsKey(hostelName)) {
            hostelData[hostelName] = [];
          }
          data['doc_id'] = doc.id;
          hostelData[hostelName]!.add(data);
        }

        if (hostelData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  "No payouts ready yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(12),
          children: hostelData.entries.map((entry) {
            final hostelName = entry.key;
            final bookings = entry.value;

            final totalAmount = bookings.fold(
              0,
              (sum, b) =>
                  sum + ((b['ownerAmount'] ?? b['amount'] ?? 0) as num).toInt(),
            );
            String formattedAmount = NumberFormat('#,##0').format(totalAmount);

            final firstBooking = bookings.first;
            final payoutDate = (firstBooking['payoutDate'] as Timestamp)
                .toDate();
            final now = DateTime.now();
            final daysLeft = payoutDate.difference(now).inDays;
            final isPaid = firstBooking['payout_status'] == 'paid';
            final canPay = daysLeft <= 0 && !isPaid;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hostelName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${bookings.length} booking(s)",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          "Payout Date: ${payoutDate.day}/${payoutDate.month}/${payoutDate.year}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Tk.$formattedAmount",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green
                            : Color(
                                0xFF003366,
                              ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPaid ? 'Paid to Owner ✓' : '$daysLeft days left',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (!isPaid)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: canPay
                              ? () async {
                                  final batch = FirebaseFirestore.instance
                                      .batch();
                                  String? ownerId; 
                                  String? hostelName;
                                  for (var b in bookings) {
                                    batch.update(
                                      FirebaseFirestore.instance
                                          .collection('bookings')
                                          .doc(b['doc_id']),
                                      {
                                        'payout_status': 'paid',
                                        'payoutDate':
                                            FieldValue.serverTimestamp(),
                                      },
                                    );

                                    ownerId ??=
                                        b['owner_id']; 
                                    hostelName ??=
                                        b['hostel_name']; 
                                  }

                                  //  owner notification
                                  if (ownerId != null) {
                                    final notifRef = FirebaseFirestore.instance
                                        .collection('owner_notifications')
                                        .doc();
                                    batch.set(notifRef, {
                                      'user_id': ownerId,
                                      'type': 'payout_paid',
                                      'title': 'Payout Received!',
                                      'desc':
                                          'Tk. $formattedAmount for $hostelName has been credited',
                                      'data': {
                                        'amount': formattedAmount,
                                        'hostel_name': hostelName,
                                        'booking_count': bookings.length,
                                      },
                                      'time': FieldValue.serverTimestamp(),
                                      'read': false,
                                    });
                                  }

                                  await batch.commit();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "✅ $hostelName - Tk. $formattedAmount marked as paid",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              : null,
                          icon: Icon(Icons.payments, color: Colors.white),
                          label: Text(
                            canPay
                                ? "Mark Paid to Owner"
                                : "Active after 7 days",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFF003366,
                            ), // Active = Full Dark Blue
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Color(
                              0xFF003366,
                            ).withOpacity(0.5),
                            disabledForegroundColor: Colors.white.withOpacity(
                              0.6,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEarningsTab() {
    final primaryBlue = const Color(0xFF003366);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'approved')
          .orderBy('created_at', descending: true) // newest first
          .snapshots(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primaryBlue));
        }

        // Error check
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Error: ${snapshot.error}\n\nCreate index in Firebase Console",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
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
                  Icons.account_balance_wallet,
                  size: 80,
                  color: primaryBlue.withOpacity(0.4),
                ),
                const SizedBox(height: 20),
                Text(
                  "No earnings yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryBlue.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Approve a booking to see earnings",
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryBlue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;
        int totalCommission = 0;

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final commission = ((data['adminCommission'] ?? 0) as num).toInt();
          totalCommission += commission;
        }

        return Column(
          children: [
            // Total Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 50,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Total Admin Earnings",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tk $totalCommission",
                    style: const TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total Bookings: ${docs.length}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Bill List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final hostelName = data['hostelName'] ?? 'Unknown Hostel';
                  final commission = ((data['adminCommission'] ?? 0) as num)
                      .toInt();

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.receipt_long, color: primaryBlue),
                      title: Text(
                        hostelName,
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      trailing: Text(
                        "Tk $commission",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Warning if 0
            if (totalCommission == 0)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "⚠️ adminCommission = 0\nDid you add 'adminCommission' field in Approve button?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 14),
                ),
              ),
          ],
        );
      },
    );
  }
}
