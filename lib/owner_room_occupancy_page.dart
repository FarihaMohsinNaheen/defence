import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerRoomOccupancyPage extends StatelessWidget {
  final String hostelId;
  final String hostelName;

  const OwnerRoomOccupancyPage({
    super.key,
    required this.hostelId,
    required this.hostelName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$hostelName - Room Occupancy"),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // MAIN COLLECTION 'rooms' theke filter kortesi hostel_id diye
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('hostel_id', isEqualTo: hostelId) // Eita main fix
            .orderBy('room_number')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.meeting_room_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text("No rooms added yet", style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          final rooms = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index].data() as Map<String, dynamic>;

              // Field name tor Firestore onujayi thik korsi + underscore
              final roomType = room['room_type'] ?? 'Room';
              final total = room['beds'] ?? 0;
              final booked = room['booked_beds'] ?? 0;
              final available =
                  total - booked; // Available calculate kore nilam

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: ListTile(
                  leading: Icon(
                    roomType == 'Single Room' ? Icons.king_bed : Icons.bed,
                    size: 40,
                    color: const Color(0xFF003366),
                  ),
                  title: Text(
                    'Room ${room['room_number']} - $roomType',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Rent: ৳${room['monthly_rent'] ?? 0}'),
                        Text('Total Beds: $total'),
                        Text(
                          'Booked: $booked',
                          style: const TextStyle(color: Colors.red),
                        ),
                        Text(
                          'Available: $available',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: available > 0
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      available > 0 ? 'Available' : 'Full',
                      style: TextStyle(
                        color: available > 0
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
