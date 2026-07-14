import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_dashboard_page.dart';
import 'owner_hostellist_page.dart';
import 'owner_profile_page.dart';

class AddHostelPage extends StatefulWidget {
  final Map<String, dynamic>? hostel;
  final bool isEditMode;

  const AddHostelPage({super.key, this.hostel, this.isEditMode = false});

  @override
  State<AddHostelPage> createState() => _AddHostelPageState();
}

class _AddHostelPageState extends State<AddHostelPage> {
  final Color primaryBlue = const Color(0xFF003366);

  final String cloudName = "dmdq2dtol";
  final String uploadPreset = "hostel_present";

  final TextEditingController hostelNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  bool wifi = false;
  bool securityCctv = false;
  bool laundry = false;
  bool drinkingWater = false;
  bool mealService = false;
  String? hostelType;

  int currentStep = 0;
  int roomCount = 1;
  List<RoomData> rooms = [];

  final ImagePicker picker = ImagePicker();
  XFile? buildingXFile;
  Uint8List? buildingImageBytes;
  String? existingBuildingUrl;

  int currentIndex = 2;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.hostel != null) {
      _loadExistingData();
    } else {
      rooms.add(RoomData());
    }
  }

  Future<void> _loadExistingData() async {
    final data = widget.hostel!;
    hostelNameController.text = data['name'] ?? '';
    locationController.text = data['location'] ?? '';
    areaController.text = (data['area'] ?? '').toString();

    wifi = data['wifi'] ?? false;
    securityCctv = data['security_cctv'] ?? false;
    laundry = data['laundry'] ?? false;
    drinkingWater = data['drinking_water'] ?? false;
    mealService = data['meal_service'] ?? false;
    hostelType = data['hostel_type'];

    existingBuildingUrl = data['image_building'];

    if (data['id'] != null) {
      final roomSnap = await FirebaseFirestore.instance
          .collection('rooms')
          .where('hostel_id', isEqualTo: data['id'])
          .get();

      rooms = roomSnap.docs.map((doc) {
        final d = doc.data();
        final room = RoomData();
        room.roomNumber = d['room_number'] ?? '';
        room.roomNumberController.text = d['room_number'] ?? '';

        
        String type = d['room_type'] ?? 'Single Room';
        if (type == 'Single Room') {
          room.roomType = 'Single Room';
        } else {
          room.roomType =
              'Shared Room'; 
        }

        room.monthlyRent = d['monthly_rent'] ?? 0;
        room.beds = d['beds'] ?? 1;
        room.rentController.text = (d['monthly_rent'] ?? 0).toString();
        room.bedController.text = (d['beds'] ?? 1).toString();
        room.existingRoomUrls = List<String>.from(d['room_images'] ?? []);
        return room;
      }).toList();

      roomCount = rooms.length;
      if (rooms.isEmpty) rooms.add(RoomData());
    }
    setState(() {});
  }

  Future<void> pickBuildingImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        buildingXFile = picked;
        buildingImageBytes = bytes;
        existingBuildingUrl = null;
      });
    }
  }

  Future<void> pickRoomImages(int roomIndex) async {
    final List<XFile> picked = await picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked.isNotEmpty) {
      List<Uint8List> bytesList = [];
      for (var img in picked) {
        bytesList.add(await img.readAsBytes());
      }
      setState(() {
        rooms[roomIndex].roomImagesBytes = bytesList;
        rooms[roomIndex].roomXFiles = picked;
        rooms[roomIndex].existingRoomUrls = [];
      });
    }
  }

  Future<String?> uploadToCloudinary({
    required Uint8List bytes,
    String? filename,
  }) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename:
                filename ??
                'hostel_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      final response = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(respStr);
        return jsonData['secure_url'];
      } else {
        throw "Upload failed: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  Future<Map<String, String>> _getOwnerInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'phone': '', 'email': ''};
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return {
      'phone': doc.data()?['phone'] ?? '',
      'email': doc.data()?['email'] ?? user.email ?? '',
      'business_name': doc.data()?['business_name'] ?? '',
    };
  }

  void goToRoomCount() {
    if (hostelNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter hostel name first")));
      return;
    }
    setState(() {
      currentStep = 1;
      if (rooms.length != roomCount) {
        updateRoomCount(roomCount);
      }
    });
  }

  void updateRoomCount(int count) {
    setState(() {
      roomCount = count;
      if (count > rooms.length) {
        rooms.addAll(List.generate(count - rooms.length, (_) => RoomData()));
      } else {
        for (int i = count; i < rooms.length; i++) {
          rooms[i].dispose();
        }
        rooms = rooms.sublist(0, count);
      }
    });
  }

  Future<void> submitForm() async {
    if (isSubmitting) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not logged in";

      for (int i = 0; i < rooms.length; i++) {
        if (rooms[i].roomNumberController.text.trim().isEmpty) {
          throw "Enter room number for Room ${i + 1}";
        }
        if (rooms[i].beds <= 0) {
          throw "Enter valid bed count for Room ${i + 1}";
        }
        if (rooms[i].monthlyRent <= 0) {
          throw "Enter valid rent for Room ${i + 1}";
        }
        if (rooms[i].roomImagesBytes.isEmpty &&
            rooms[i].existingRoomUrls.isEmpty) {
          throw "Upload at least 1 image for Room ${i + 1}";
        }
      }

      if (!mounted) return;
      setState(() => isSubmitting = true);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            Center(child: CircularProgressIndicator(color: primaryBlue)),
      );

      final ownerInfo = await _getOwnerInfo();

      String? buildingUrl = existingBuildingUrl;
      if (buildingImageBytes != null) {
        buildingUrl = await uploadToCloudinary(
          bytes: buildingImageBytes!,
          filename: buildingXFile?.name,
        );
        if (buildingUrl == null) throw "Building image upload failed";
      }

      final hostelData = {
        'owner_id': user.uid,
        'owner_phone': ownerInfo['phone'],
        'owner_email': ownerInfo['email'],
        'business_name': ownerInfo['business_name'],
        'name': hostelNameController.text.trim(),
        'location': locationController.text.trim(),
        'area': areaController.text.trim(),
        'wifi': wifi,
        'security_cctv': securityCctv,
        'laundry': laundry,
        'drinking_water': drinkingWater,
        'meal_service': mealService,
        'hostel_type': hostelType,
        'image_building': buildingUrl,
        'status': 'pending',
        'is_available': true,
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (!widget.isEditMode) {
        hostelData['created_at'] = FieldValue.serverTimestamp();
      }

      String hostelId;
      if (widget.isEditMode && widget.hostel != null) {
        hostelId = widget.hostel!['id'];
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostelId)
            .update(hostelData);
      } else {
        final docRef = await FirebaseFirestore.instance
            .collection('hostels')
            .add(hostelData);
        hostelId = docRef.id;
      }

      if (mounted) Navigator.pop(context);

      if (widget.isEditMode) {
        final oldRooms = await FirebaseFirestore.instance
            .collection('rooms')
            .where('hostel_id', isEqualTo: hostelId)
            .get();
        for (var doc in oldRooms.docs) {
          await doc.reference.delete();
        }
      }

      for (int i = 0; i < rooms.length; i++) {
        List<String> uploadedUrls = List.from(rooms[i].existingRoomUrls);

        for (int j = 0; j < rooms[i].roomImagesBytes.length; j++) {
          final url = await uploadToCloudinary(
            bytes: rooms[i].roomImagesBytes[j],
            filename: rooms[i].roomXFiles[j].name,
          );
          if (url != null) uploadedUrls.add(url);
        }

        await FirebaseFirestore.instance.collection('rooms').add({
          'hostel_id': hostelId,
          'room_number': rooms[i].roomNumberController.text.trim(),
          'room_type': rooms[i].roomType,
          'monthly_rent': rooms[i].monthlyRent,
          'beds': rooms[i].beds,
          'booked_beds': 0,
          'is_available': true,
          'status': 'pending',
          'room_images': uploadedUrls,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      setState(() => isSubmitting = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              Text(widget.isEditMode ? "Updated" : "Success"),
            ],
          ),
          content: Text(
            widget.isEditMode
                ? "Hostel + Rooms updated!\nStatus reset to PENDING."
                : "Hostel + ${rooms.length} rooms submitted!\nPending admin approval.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
                  (route) => false,
                );
              },
              child: Text("OK", style: TextStyle(color: primaryBlue)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    hostelNameController.dispose();
    locationController.dispose();
    areaController.dispose();
    for (var room in rooms) {
      room.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            if (currentStep > 0) {
              setState(() => currentStep--);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
              );
            }
          },
        ),
        title: Text(
          currentStep == 0
              ? "Hostel Info"
              : currentStep == 1
              ? "Room Count"
              : "Room Details",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: currentStep == 0
          ? buildHostelInfoStep()
          : currentStep == 1
          ? buildRoomCountStep()
          : buildRoomDetailsStep(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }


  Widget buildHostelInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection("🏠 Basic Information", [
            _buildInput(hostelNameController, "Hostel Name", Icons.home),
            const SizedBox(height: 12),
            _buildInput(locationController, "Location", Icons.location_on),
            const SizedBox(height: 12),
            _buildInput(areaController, "Area", Icons.map),
          ]),
          const SizedBox(height: 20),
          _buildSection("📸 Building Photo", [
            GestureDetector(
              onTap: pickBuildingImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryBlue, width: 1.5),
                ),
                child: buildingImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          buildingImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : existingBuildingUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          existingBuildingUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apartment, size: 40, color: primaryBlue),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to upload HD building image",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection("🛠 Facilities", [
            _buildSwitch(
              "WiFi",
              Icons.wifi,
              wifi,
              (v) => setState(() => wifi = v),
            ),
            _buildSwitch(
              "24/7 Security & CCTV",
              Icons.security,
              securityCctv,
              (v) => setState(() => securityCctv = v),
            ),
            _buildSwitch(
              "Laundry Service",
              Icons.local_laundry_service,
              laundry,
              (v) => setState(() => laundry = v),
            ),
            _buildSwitch(
              "Pure Drinking Water",
              Icons.water_drop,
              drinkingWater,
              (v) => setState(() => drinkingWater = v),
            ),
            _buildSwitch(
              "Meal Service",
              Icons.restaurant,
              mealService,
              (v) => setState(() => mealService = v),
            ),
          ]), 
          const SizedBox(height: 20),
          _buildSection("🏢 Hostel Type", [
          
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryBlue),
              ),
              child: DropdownButton<String>(
                value: hostelType,
                hint: const Text("Select Boys/Girls Hostel"),
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: "Boys", child: Text("Boys Hostel")),
                  DropdownMenuItem(value: "Girls", child: Text("Girls Hostel")),
                ],
                onChanged: (val) => setState(() => hostelType = val),
              ),
            ),
          ]), 
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: goToRoomCount,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Next: Add Rooms",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoomCountStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How many rooms does your hostel have?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<int>(
              value: roomCount,
              isExpanded: true,
              underline: const SizedBox(),
              items: List.generate(
                20,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text("${i + 1} Room${i > 0 ? 's' : ''}"),
                ),
              ),
              onChanged: (val) => updateRoomCount(val!),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => currentStep = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Next: Fill Room Details",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoomDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Add details for each room",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(roomCount, (index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Room ${index + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: rooms[index].roomNumberController,
                      decoration: InputDecoration(
                        labelText: "Room Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (v) => rooms[index].roomNumber = v,
                    ),
                    const SizedBox(height: 12),
                    // Bed input field
                    TextField(
                      controller: rooms[index].bedController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Beds",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (v) =>
                          rooms[index].beds = int.tryParse(v) ?? 1,
                    ),
                    const SizedBox(height: 12),
                    // Only 2 room type options
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: rooms[index].roomType,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ["Single Room", "Shared Room"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() {
                          rooms[index].roomType = v!;
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: rooms[index].rentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Monthly Rent Tk",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (v) =>
                          rooms[index].monthlyRent = int.tryParse(v) ?? 0,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => pickRoomImages(index),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Upload HD Images (${rooms[index].roomImagesBytes.length} selected)",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit for Approval",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController c, String hint, IconData icon) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        if (i == currentIndex) return;
        setState(() => currentIndex = i);
        if (i == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
          );
        }
        if (i == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyListingsPage()),
          );
        }
        if (i == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          activeIcon: Icon(Icons.list_alt),
          label: "Hostels",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}

class RoomData {
  String roomNumber = "";
  String roomType = "Single Room";
  int monthlyRent = 0;
  int beds = 1;

  List<Uint8List> roomImagesBytes = [];
  List<XFile> roomXFiles = [];
  List<String> existingRoomUrls = [];

  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController bedController = TextEditingController();

  void dispose() {
    roomNumberController.dispose();
    rentController.dispose();
    bedController.dispose();
  }
}
