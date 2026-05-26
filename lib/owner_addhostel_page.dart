// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddHostelPage extends StatefulWidget {
//   const AddHostelPage({super.key});

//   @override
//   State<AddHostelPage> createState() => _AddHostelPageState();
// }

// class _AddHostelPageState extends State<AddHostelPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   final TextEditingController hostelNameController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController areaController = TextEditingController();
//   final TextEditingController rentController = TextEditingController();

//   bool wifi = false;
//   bool electricity = false;
//   bool water = false;
//   bool security = false;

//   String selectedRoomType = "Single Room";

//   final ImagePicker picker = ImagePicker();

//   Uint8List? roomImage;
//   Uint8List? buildingImage;

//   //bottom navbar active index
//   int currentIndex = 2;

//   Future<void> pickImage(bool isRoom) async {
//     try {
//       final XFile? pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (pickedFile != null) {
//         final bytes = await pickedFile.readAsBytes();

//         setState(() {
//           if (isRoom) {
//             roomImage = bytes;
//           } else {
//             buildingImage = bytes;
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint("Image picker error: $e");
//     }
//   }

//   void submitForm() {
//     if (hostelNameController.text.isEmpty ||
//         locationController.text.isEmpty ||
//         areaController.text.isEmpty ||
//         rentController.text.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text("Missing Information"),
//           content: const Text("Please fill all required fields."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("OK", style: TextStyle(color: primaryBlue)),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: primaryBlue),
//             const SizedBox(width: 10),
//             const Text("Success"),
//           ],
//         ),
//         content: const Text("Hostel listing submitted successfully."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);

//               /// ✅ RESET EVERYTHING AFTER SUBMIT
//               setState(() {
//                 hostelNameController.clear();
//                 locationController.clear();
//                 areaController.clear();
//                 rentController.clear();

//                 wifi = false;
//                 electricity = false;
//                 water = false;
//                 security = false;

//                 selectedRoomType = "Single Room";

//                 roomImage = null;
//                 buildingImage = null;
//               });
//             },
//             child: Text("OK", style: TextStyle(color: primaryBlue)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: primaryBlue),
//         title: Text(
//           "Add Hostel",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             sectionTitle("🏠 Basic Information"),

//             const SizedBox(height: 15),

//             buildTextField("Hostel Name", Icons.home, hostelNameController),
//             const SizedBox(height: 15),
//             buildTextField("Location", Icons.location_on, locationController),
//             const SizedBox(height: 15),
//             buildTextField("Area", Icons.map, areaController),

//             const SizedBox(height: 25),

//             sectionTitle("💰 Rent Details"),

//             const SizedBox(height: 15),

//             buildTextField("Monthly Rent", Icons.money, rentController),

//             const SizedBox(height: 15),

//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedRoomType,
//                   isExpanded: true,
//                   items: const [
//                     DropdownMenuItem(
//                       value: "Single Room",
//                       child: Text("Single Room"),
//                     ),
//                     DropdownMenuItem(
//                       value: "Shared Room",
//                       child: Text("Shared Room"),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       selectedRoomType = value!;
//                     });
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             sectionTitle("📸 Upload Photos"),

//             const SizedBox(height: 15),

//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => pickImage(true),
//                     child: uploadBox("Room Image", roomImage, Icons.bed),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => pickImage(false),
//                     child: uploadBox(
//                       "Building Image",
//                       buildingImage,
//                       Icons.apartment,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 25),

//             sectionTitle("🛠 Facilities"),

//             const SizedBox(height: 15),

//             buildSwitchTile("WiFi", Icons.wifi, wifi, (v) {
//               setState(() => wifi = v);
//             }),
//             buildSwitchTile("Electricity", Icons.electric_bolt, electricity, (
//               v,
//             ) {
//               setState(() => electricity = v);
//             }),
//             buildSwitchTile("Water", Icons.water_drop, water, (v) {
//               setState(() => water = v);
//             }),
//             buildSwitchTile("Security", Icons.security, security, (v) {
//               setState(() => security = v);
//             }),

//             const SizedBox(height: 35),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: submitForm,
//                 child: const Text(
//                   "Submit Listing",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   /// SECTION TITLE
//   Widget sectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: primaryBlue,
//       ),
//     );
//   }

//   /// TEXT FIELD
//   Widget buildTextField(
//     String hint,
//     IconData icon,
//     TextEditingController controller,
//   ) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: primaryBlue),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   /// UPLOAD BOX
//   Widget uploadBox(String title, Uint8List? image, IconData icon) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: image != null
//           ? ClipRRect(
//               borderRadius: BorderRadius.circular(18),
//               child: Image.memory(
//                 image,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 40, color: primaryBlue),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: primaryBlue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   /// SWITCH TILE
//   Widget buildSwitchTile(
//     String title,
//     IconData icon,
//     bool value,
//     Function(bool) onChanged,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: SwitchListTile(
//         value: value,
//         onChanged: onChanged,
//         activeColor: primaryBlue,
//         title: Text(
//           title,
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//         secondary: Icon(icon, color: primaryBlue),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nan_nestfinder/owner_dashboard_page.dart';
import 'package:nan_nestfinder/owner_hostellist_page.dart';
import 'package:nan_nestfinder/owner_profile_page.dart';

class AddHostelPage extends StatefulWidget {
  const AddHostelPage({super.key});

  @override
  State<AddHostelPage> createState() => _AddHostelPageState();
}

class _AddHostelPageState extends State<AddHostelPage> {
  final Color primaryBlue = const Color(0xFF003366);

  final TextEditingController hostelNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  bool wifi = false;
  bool electricity = false;
  bool water = false;
  bool security = false;

  String selectedRoomType = "Single Room";

  final ImagePicker picker = ImagePicker();

  Uint8List? roomImage;
  Uint8List? buildingImage;

  // Bottom navbar active index
  int currentIndex = 2;

  Future<void> pickImage(bool isRoom) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          if (isRoom) {
            roomImage = bytes;
          } else {
            buildingImage = bytes;
          }
        });
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  void submitForm() {
    if (hostelNameController.text.isEmpty ||
        locationController.text.isEmpty ||
        areaController.text.isEmpty ||
        rentController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Missing Information"),
          content: const Text("Please fill all required fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: primaryBlue)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: primaryBlue),
            const SizedBox(width: 10),
            const Text("Success"),
          ],
        ),
        content: const Text("Hostel listing submitted successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              /// RESET EVERYTHING AFTER SUBMIT
              setState(() {
                hostelNameController.clear();
                locationController.clear();
                areaController.clear();
                rentController.clear();

                wifi = false;
                electricity = false;
                water = false;
                security = false;

                selectedRoomType = "Single Room";

                roomImage = null;
                buildingImage = null;
              });
            },
            child: Text("OK", style: TextStyle(color: primaryBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryBlue),

        /// ✅ BACK ARROW ADDED
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Add Hostel",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("🏠 Basic Information"),

            const SizedBox(height: 15),

            buildTextField("Hostel Name", Icons.home, hostelNameController),

            const SizedBox(height: 15),

            buildTextField("Location", Icons.location_on, locationController),

            const SizedBox(height: 15),

            buildTextField("Area", Icons.map, areaController),

            const SizedBox(height: 25),

            sectionTitle("💰 Rent Details"),

            const SizedBox(height: 15),

            buildTextField("Monthly Rent", Icons.money, rentController),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRoomType,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: "Single Room",
                      child: Text("Single Room"),
                    ),
                    DropdownMenuItem(
                      value: "Shared Room",
                      child: Text("Shared Room"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRoomType = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle("📸 Upload Photos"),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => pickImage(true),
                    child: uploadBox("Room Image", roomImage, Icons.bed),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: GestureDetector(
                    onTap: () => pickImage(false),
                    child: uploadBox(
                      "Building Image",
                      buildingImage,
                      Icons.apartment,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            sectionTitle("🛠 Facilities"),

            const SizedBox(height: 15),

            buildSwitchTile("WiFi", Icons.wifi, wifi, (v) {
              setState(() => wifi = v);
            }),

            buildSwitchTile("Electricity", Icons.electric_bolt, electricity, (
              v,
            ) {
              setState(() => electricity = v);
            }),

            buildSwitchTile("Water", Icons.water_drop, water, (v) {
              setState(() => water = v);
            }),

            buildSwitchTile("Security", Icons.security, security, (v) {
              setState(() => security = v);
            }),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: submitForm,
                child: const Text(
                  "Submit Listing",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (i) {
          setState(() {
            currentIndex = i;
          });

          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
            );
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyListingsPage()),
            );
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AddHostelPage()),
            );
          } else if (i == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Hostel List",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: "Add Hostel",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryBlue,
      ),
    );
  }

  /// TEXT FIELD
  Widget buildTextField(
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// UPLOAD BOX
  Widget uploadBox(String title, Uint8List? image, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.memory(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: primaryBlue),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  /// SWITCH TILE
  Widget buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: primaryBlue,
        title: Text(
          title,
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        secondary: Icon(icon, color: primaryBlue),
      ),
    );
  }
}
