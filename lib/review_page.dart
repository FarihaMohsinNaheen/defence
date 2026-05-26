// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'home_page.dart';
// import 'profile_page.dart';
// import 'roommatematcher_page.dart';

// class ReviewPage extends StatefulWidget {
//   const ReviewPage({super.key});

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   int currentIndex = 1;

//   int overallRating = 0;
//   int foodRating = 0;
//   int cleanlinessRating = 0;
//   int safetyRating = 0;
//   int comfortRating = 0;

//   String selectedEmoji = "";

//   final TextEditingController reviewController = TextEditingController();

//   /// ✅ ADDED FOR IMAGE PICKER
//   File? selectedImage;
//   final ImagePicker picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       /// BOTTOM NAV BAR
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) {
//           setState(() {
//             currentIndex = i;
//           });

//           if (i == 0) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           } else if (i == 1) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const ReviewPage()),
//             );
//           } else if (i == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
//             );
//           } else if (i == 3) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ProfilePage()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: primaryBlue),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Write a Review",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSectionTitle("Overall Rating"),
//             const SizedBox(height: 10),

//             buildStarRating(overallRating, (value) {
//               setState(() {
//                 overallRating = value;
//               });
//             }),

//             const SizedBox(height: 30),

//             buildSectionTitle("Rate by Category"),
//             const SizedBox(height: 20),

//             buildCategoryRating("🍛 Food Quality", foodRating, (value) {
//               setState(() => foodRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🧹 Cleanliness", cleanlinessRating, (value) {
//               setState(() => cleanlinessRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🔐 Safety", safetyRating, (value) {
//               setState(() => safetyRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🛏 Comfort", comfortRating, (value) {
//               setState(() => comfortRating = value);
//             }),

//             const SizedBox(height: 30),

//             buildSectionTitle("Write your experience"),
//             const SizedBox(height: 15),

//             TextField(
//               controller: reviewController,
//               maxLines: 6,
//               decoration: InputDecoration(
//                 hintText:
//                     "Share your real experience about room, food, and environment…",
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             buildSectionTitle("Add Photos"),
//             const SizedBox(height: 15),

//             /// ✅ ONLY MODIFIED PART (IMAGE PICKER)
//             GestureDetector(
//               onTap: () async {
//                 final pickedFile = await picker.pickImage(
//                   source: ImageSource.gallery,
//                 );

//                 if (pickedFile != null) {
//                   setState(() {
//                     selectedImage = File(pickedFile.path);
//                   });
//                 }
//               },
//               child: Container(
//                 height: 140,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),

//                 /// ✅ SHOW IMAGE OR DEFAULT UI
//                 child: selectedImage == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_a_photo, size: 40, color: primaryBlue),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                               color: primaryBlue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text("Upload room or food photos"),
//                         ],
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.file(
//                           selectedImage!,
//                           width: double.infinity,
//                           height: 140,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             buildSectionTitle("How was your experience?"),
//             const SizedBox(height: 15),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildEmoji("😡"),
//                 buildEmoji("😐"),
//                 buildEmoji("🙂"),
//                 buildEmoji("😍"),
//               ],
//             ),

//             const SizedBox(height: 40),

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
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return Dialog(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(25),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(18),
//                                 decoration: BoxDecoration(
//                                   color: primaryBlue.withOpacity(0.1),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.check_circle,
//                                   color: primaryBlue,
//                                   size: 70,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 "Review Submitted!",
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: primaryBlue,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 "Your review has been submitted successfully.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 25),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryBlue,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 14,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text(
//                                     "OK",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: const Text(
//                   "Submit Review",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
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

//   Widget buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: primaryBlue,
//       ),
//     );
//   }

//   Widget buildStarRating(int rating, Function(int) onTap) {
//     return Row(
//       children: List.generate(5, (index) {
//         return IconButton(
//           onPressed: () => onTap(index + 1),
//           icon: Icon(
//             index < rating ? Icons.star : Icons.star_border,
//             color: Colors.orange,
//             size: 36,
//           ),
//         );
//       }),
//     );
//   }

//   Widget buildCategoryRating(String title, int rating, Function(int) onTap) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: primaryBlue,
//             ),
//           ),
//           const SizedBox(height: 10),
//           buildStarRating(rating, onTap),
//         ],
//       ),
//     );
//   }

//   Widget buildEmoji(String emoji) {
//     bool isSelected = selectedEmoji == emoji;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedEmoji = emoji;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? primaryBlue : Colors.white,
//           shape: BoxShape.circle,
//         ),
//         child: Text(emoji, style: const TextStyle(fontSize: 30)),
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'home_page.dart';
// import 'profile_page.dart';
// import 'roommatematcher_page.dart';

// class ReviewPage extends StatefulWidget {
//   const ReviewPage({super.key});

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   int currentIndex = 1;

//   int overallRating = 0;
//   int foodRating = 0;
//   int cleanlinessRating = 0;
//   int safetyRating = 0;
//   int comfortRating = 0;

//   String selectedEmoji = "";

//   final TextEditingController reviewController = TextEditingController();

//   /// ✅ ADDED FOR IMAGE PICKER
//   File? selectedImage;
//   final ImagePicker picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       /// BOTTOM NAV BAR
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) {
//           setState(() {
//             currentIndex = i;
//           });

//           if (i == 0) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           } else if (i == 1) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const ReviewPage()),
//             );
//           } else if (i == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
//             );
//           } else if (i == 3) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ProfilePage()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: primaryBlue),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Write a Review",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSectionTitle("Overall Rating"),
//             const SizedBox(height: 10),

//             buildStarRating(overallRating, (value) {
//               setState(() {
//                 overallRating = value;
//               });
//             }),

//             const SizedBox(height: 30),

//             buildSectionTitle("Rate by Category"),
//             const SizedBox(height: 20),

//             buildCategoryRating("🍛 Food Quality", foodRating, (value) {
//               setState(() => foodRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🧹 Cleanliness", cleanlinessRating, (value) {
//               setState(() => cleanlinessRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🔐 Safety", safetyRating, (value) {
//               setState(() => safetyRating = value);
//             }),

//             const SizedBox(height: 15),

//             buildCategoryRating("🛏 Comfort", comfortRating, (value) {
//               setState(() => comfortRating = value);
//             }),

//             const SizedBox(height: 30),

//             buildSectionTitle("Write your experience"),
//             const SizedBox(height: 15),

//             TextField(
//               controller: reviewController,
//               maxLines: 6,
//               decoration: InputDecoration(
//                 hintText:
//                     "Share your real experience about room, food, and environment…",
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             buildSectionTitle("Add Photos"),
//             const SizedBox(height: 15),

//             /// ✅ ONLY MODIFIED PART (IMAGE PICKER)
//             GestureDetector(
//               onTap: () async {
//                 final pickedFile = await picker.pickImage(
//                   source: ImageSource.gallery,
//                 );

//                 if (pickedFile != null) {
//                   setState(() {
//                     selectedImage = File(pickedFile.path);
//                   });
//                 }
//               },
//               child: Container(
//                 height: 140,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),

//                 /// ✅ SHOW IMAGE OR DEFAULT UI
//                 child: selectedImage == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_a_photo, size: 40, color: primaryBlue),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                               color: primaryBlue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text("Upload room or food photos"),
//                         ],
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.file(
//                           selectedImage!,
//                           width: double.infinity,
//                           height: 140,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             buildSectionTitle("How was your experience?"),
//             const SizedBox(height: 15),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildEmoji("😡"),
//                 buildEmoji("😐"),
//                 buildEmoji("🙂"),
//                 buildEmoji("😍"),
//               ],
//             ),

//             const SizedBox(height: 40),

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
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return Dialog(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(25),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(18),
//                                 decoration: BoxDecoration(
//                                   color: primaryBlue.withOpacity(0.1),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.check_circle,
//                                   color: primaryBlue,
//                                   size: 70,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 "Review Submitted!",
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: primaryBlue,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 "Your review has been submitted successfully.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 25),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryBlue,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 14,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text(
//                                     "OK",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: const Text(
//                   "Submit Review",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
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

//   Widget buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: primaryBlue,
//       ),
//     );
//   }

//   Widget buildStarRating(int rating, Function(int) onTap) {
//     return Row(
//       children: List.generate(5, (index) {
//         return IconButton(
//           onPressed: () => onTap(index + 1),
//           icon: Icon(
//             index < rating ? Icons.star : Icons.star_border,
//             color: Colors.orange,
//             size: 36,
//           ),
//         );
//       }),
//     );
//   }

//   Widget buildCategoryRating(String title, int rating, Function(int) onTap) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: primaryBlue,
//             ),
//           ),
//           const SizedBox(height: 10),
//           buildStarRating(rating, onTap),
//         ],
//       ),
//     );
//   }

//   Widget buildEmoji(String emoji) {
//     bool isSelected = selectedEmoji == emoji;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedEmoji = emoji;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? primaryBlue : Colors.white,
//           shape: BoxShape.circle,
//         ),
//         child: Text(emoji, style: const TextStyle(fontSize: 30)),
//       ),
//     );
//   }
// }

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';
import 'profile_page.dart';
import 'roommatematcher_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final Color primaryBlue = const Color(0xFF003366);

  int currentIndex = 1;

  int overallRating = 0;
  int foodRating = 0;
  int cleanlinessRating = 0;
  int safetyRating = 0;
  int comfortRating = 0;

  String selectedEmoji = "";

  final TextEditingController reviewController = TextEditingController();

  /// WEB SAFE IMAGE STORAGE
  final ImagePicker picker = ImagePicker();
  Uint8List? selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

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
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReviewPage()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Write a Review",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Overall Rating"),
            const SizedBox(height: 10),
            buildStarRating(overallRating, (value) {
              setState(() => overallRating = value);
            }),

            const SizedBox(height: 30),

            buildSectionTitle("Rate by Category"),
            const SizedBox(height: 20),

            buildCategoryRating("🍛 Food Quality", foodRating, (value) {
              setState(() => foodRating = value);
            }),

            const SizedBox(height: 15),

            buildCategoryRating("🧹 Cleanliness", cleanlinessRating, (value) {
              setState(() => cleanlinessRating = value);
            }),

            const SizedBox(height: 15),

            buildCategoryRating("🔐 Safety", safetyRating, (value) {
              setState(() => safetyRating = value);
            }),

            const SizedBox(height: 15),

            buildCategoryRating("🛏 Comfort", comfortRating, (value) {
              setState(() => comfortRating = value);
            }),

            const SizedBox(height: 30),

            buildSectionTitle("Write your experience"),
            const SizedBox(height: 15),

            TextField(
              controller: reviewController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText:
                    "Share your real experience about room, food, and environment…",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            buildSectionTitle("Add Photos"),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();

                  setState(() {
                    selectedImageBytes = bytes;
                  });
                }
              },

              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: selectedImageBytes == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: primaryBlue),
                          const SizedBox(height: 10),
                          Text(
                            "Add Photo",
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Upload room or food photos"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          selectedImageBytes!,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            buildSectionTitle("How was your experience?"),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildEmoji("😡"),
                buildEmoji("😐"),
                buildEmoji("🙂"),
                buildEmoji("😍"),
              ],
            ),

            const SizedBox(height: 40),

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
                onPressed: () {
                  if (reviewController.text.isEmpty || overallRating == 0) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 50),
                              const SizedBox(height: 10),
                              const Text(
                                "Incomplete Review",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("Please fill all required fields."),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Success!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Your review has been submitted successfully.",
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                              ),
                              onPressed: () {
                                Navigator.pop(context);

                                setState(() {
                                  overallRating = 0;
                                  foodRating = 0;
                                  cleanlinessRating = 0;
                                  safetyRating = 0;
                                  comfortRating = 0;
                                  selectedEmoji = "";
                                  reviewController.clear();
                                  selectedImageBytes = null;
                                });
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryBlue,
      ),
    );
  }

  Widget buildStarRating(int rating, Function(int) onTap) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => onTap(index + 1),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 36,
          ),
        );
      }),
    );
  }

  Widget buildCategoryRating(String title, int rating, Function(int) onTap) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          buildStarRating(rating, onTap),
        ],
      ),
    );
  }

  Widget buildEmoji(String emoji) {
    bool isSelected = selectedEmoji == emoji;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji = emoji;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
