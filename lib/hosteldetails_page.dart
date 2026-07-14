import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'roomdetails_page.dart';

class HostelDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hostel;
  const HostelDetailsPage({super.key, required this.hostel});

  @override
  State<HostelDetailsPage> createState() => _HostelDetailsPageState();
}

class _HostelDetailsPageState extends State<HostelDetailsPage> {
  String s(dynamic val, [String def = '']) => val?.toString() ?? def;
  int i(dynamic val, [int def = 0]) {
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? def;
    return def;
  }

  bool isSaved = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('saved_hostels')
        .doc(widget.hostel['id'])
        .get();
    setState(() => isSaved = doc.exists);
  }

  Future<void> _toggleSave() async {
    if (user == null) return;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('saved_hostels')
        .doc(widget.hostel['id']);

    if (isSaved) {
      await ref.set({
        'hostel_id': widget.hostel['id'],
        'saved_at': FieldValue.serverTimestamp(),
        ...widget.hostel,
      });
      if (!mounted) return;
      setState(() => isSaved = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.hostel['name']} remove from saved list'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await ref.set({
        'hostel_id': widget.hostel['id'],
        'saved_at': FieldValue.serverTimestamp(),
        ...widget.hostel,
      });
      if (!mounted) return;
      setState(() => isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.hostel['name']} saved successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

   
  bool hasFacility(String key) {
    final val = widget.hostel[key];
    if (val is bool) return val;
    if (val is int) return val == 1;
    if (val is String) return val.toLowerCase() == 'true' || val == '1';
    return false;
  }

 
  Widget _buildFacilityIcon(String label, IconData icon, String key) {
    final active = hasFacility(key);
    final Color primaryBlue = const Color(0xFF003366);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? primaryBlue.withOpacity(0.15) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: active ? primaryBlue : Colors.grey[600],
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? primaryBlue : Colors.grey[600],
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF003366);
    final String hostelId = s(widget.hostel['id']);
    final String hostelName = s(widget.hostel['name'], 'Hostel');
    final String image = s(widget.hostel['image_building']);
    final String location = s(widget.hostel['location']);
    final String area = s(widget.hostel['area']); // FIX 2: Area add
    final String ownerId = s(widget.hostel['owner_id']);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: Text(
          hostelName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : Colors.white,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('hostel_id', isEqualTo: hostelId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No rooms found",
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          final rooms = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image.isNotEmpty ? image : "https://via.placeholder.com/400",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 200, color: Colors.grey[300]),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                hostelName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              if (s(widget.hostel['hostel_type']).isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: s(widget.hostel['hostel_type']) == "Boys"
                        ? Colors.blue.shade100
                        : Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        s(widget.hostel['hostel_type']) == "Boys"
                            ? Icons.male
                            : Icons.female,
                        size: 16,
                        color: s(widget.hostel['hostel_type']) == "Boys"
                            ? Colors.blue
                            : Colors.pink,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${s(widget.hostel['hostel_type'])} Hostel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: s(widget.hostel['hostel_type']) == "Boys"
                              ? Colors.blue
                              : Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              if (area.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  'Area: $area',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Location:$location',
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 24),
              Text(
                "Facilities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 20,
                runSpacing: 16,
                children: [
                  _buildFacilityIcon("WiFi", Icons.wifi, "wifi"),
                  _buildFacilityIcon("CCTV", Icons.security, "security_cctv"),
                  _buildFacilityIcon(
                    "Laundry",
                    Icons.local_laundry_service,
                    "laundry",
                  ),
                  _buildFacilityIcon(
                    "Water",
                    Icons.water_drop,
                    "drinking_water",
                  ),
                  _buildFacilityIcon("Meal", Icons.restaurant, "meal_service"),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                "Available Rooms",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...rooms.map((doc) {
                final room = doc.data() as Map<String, dynamic>;
                room['id'] = doc.id;
                final roomNumber = s(room['room_number'], 'Room');
                final rent = i(room['monthly_rent']);
                final roomId = doc.id;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomDetailsPage(
                          room: room,
                          roomId: roomId,
                          hostel: widget.hostel,
                          ownerId: ownerId,
                          ownerName: s(widget.hostel['owner_name'], 'Owner'),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room $roomNumber",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tk $rent / month",
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryBlue,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
