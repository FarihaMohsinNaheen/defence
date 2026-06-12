import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'roommatematcher_page.dart';
import 'experiencedfeed_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;
  int currentIndex = 1;

  // Cloudinary config
  final String cloudName = "dmdq2dtol";
  final String uploadPreset = "hostel_present";

  int overallRating = 0;
  int foodRating = 0;
  int cleanlinessRating = 0;
  int safetyRating = 0;
  int comfortRating = 0;
  String selectedEmoji = "";
  final TextEditingController reviewController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Uint8List? selectedImageBytes;
  bool isSubmitting = false;

  String? selectedHostelId;
  String? selectedHostelName;
  List<Map<String, dynamic>> hostels = [];
  bool isLoadingHostels = true;

  @override
  void initState() {
    super.initState();
    _fetchHostels();
  }

  Future<void> _fetchHostels() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('hostels')
          .where('status', isEqualTo: 'approved')
          .get();

      if (mounted) {
        setState(() {
          hostels = snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return data;
          }).toList();
          isLoadingHostels = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingHostels = false);
      debugPrint("Error fetching hostels: $e");
    }
  }

  Future<String?> _uploadToCloudinary(Uint8List bytes) async {
    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'review_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      final response = await request.send();
      final resStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(resStr);
        return json['secure_url'];
      } else {
        debugPrint("Cloudinary error: $resStr");
        return null;
      }
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      return null;
    }
  }

  Future<void> _submitReview() async {
    if (user == null) return;
    if (reviewController.text.isEmpty ||
        overallRating == 0 ||
        selectedHostelId == null) {
      _showDialog(
        "Incomplete Review",
        "Please select hostel and fill required fields.",
        Icons.error,
        Colors.red,
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      String? imageUrl;
      if (selectedImageBytes != null) {
        imageUrl = await _uploadToCloudinary(selectedImageBytes!);
        if (imageUrl == null) throw "Image upload failed";
      }

      Map<String, dynamic> reviewData = {
        'studentId': user!.uid,
        'studentName':
            user!.displayName ?? user!.email?.split('@')[0] ?? 'Student',
        'hostelId': selectedHostelId,
        'hostelName': selectedHostelName,
        'overallRating': overallRating,
        'foodRating': foodRating,
        'cleanlinessRating': cleanlinessRating,
        'safetyRating': safetyRating,
        'comfortRating': comfortRating,
        'emoji': selectedEmoji,
        'reviewText': reviewController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'approved',
      };

      if (imageUrl != null) {
        reviewData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance.collection('reviews').add(reviewData);
      await _updateHostelRating(selectedHostelId!);
      _showSuccessDialog();
    } catch (e) {
      debugPrint("Submit error: $e");
      _showDialog(
        "Error",
        "Failed to submit review: $e",
        Icons.error,
        Colors.red,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _updateHostelRating(String hostelId) async {
    final reviews = await FirebaseFirestore.instance
        .collection('reviews')
        .where('hostelId', isEqualTo: hostelId)
        .get();

    if (reviews.docs.isNotEmpty) {
      double total = 0;
      for (var doc in reviews.docs) {
        total += (doc['overallRating'] as int).toDouble();
      }
      double avg = total / reviews.docs.length;
      await FirebaseFirestore.instance
          .collection('hostels')
          .doc(hostelId)
          .update({'rating': double.parse(avg.toStringAsFixed(1))});
    }
  }

  void _showDialog(String title, String msg, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 50),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(msg, textAlign: TextAlign.center),
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
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 10),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Your review has been submitted successfully."),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted) {
                    setState(() {
                      overallRating = 0;
                      foodRating = 0;
                      cleanlinessRating = 0;
                      safetyRating = 0;
                      comfortRating = 0;
                      selectedEmoji = "";
                      reviewController.clear();
                      selectedImageBytes = null;
                      selectedHostelId = null;
                      selectedHostelName = null;
                    });
                  }
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFEAF4FF),
        body: Center(
          child: Text(
            "Please login first",
            style: TextStyle(color: primaryBlue, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: Text(
          "Write a Review",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Select Hostel *"),
            const SizedBox(height: 10),

            isLoadingHostels
                ? Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : DropdownButtonFormField<String>(
                    value: hostels.any((h) => h['id'] == selectedHostelId)
                        ? selectedHostelId
                        : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: const Text("Choose hostel"),
                    items: hostels.isEmpty
                        ? []
                        : hostels.map((h) {
                            return DropdownMenuItem(
                              value: h['id'] as String,
                              child: Text((h['name'] ?? 'Hostel').toString()),
                            );
                          }).toList(),
                    onChanged: hostels.isEmpty
                        ? null
                        : (val) {
                            if (val != null) {
                              final selected = hostels.firstWhere(
                                (h) => h['id'] == val,
                              );
                              setState(() {
                                selectedHostelId = val;
                                selectedHostelName = (selected['name'] ?? '')
                                    .toString();
                              });
                            }
                          },
                  ),

            if (selectedHostelName != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: primaryBlue, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "I am sending this review for $selectedHostelName",
                        style: TextStyle(
                          fontSize: 15,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
            buildSectionTitle("Overall Rating *"),
            const SizedBox(height: 10),
            buildStarRating(
              overallRating,
              (value) => setState(() => overallRating = value),
            ),

            const SizedBox(height: 30),
            buildSectionTitle("Rate by Category"),
            const SizedBox(height: 20),
            buildCategoryRating(
              "🍛 Food Quality",
              foodRating,
              (value) => setState(() => foodRating = value),
            ),
            const SizedBox(height: 15),
            buildCategoryRating(
              "🧹 Cleanliness",
              cleanlinessRating,
              (value) => setState(() => cleanlinessRating = value),
            ),
            const SizedBox(height: 15),
            buildCategoryRating(
              "🔐 Safety",
              safetyRating,
              (value) => setState(() => safetyRating = value),
            ),
            const SizedBox(height: 15),
            buildCategoryRating(
              "🛏 Comfort",
              comfortRating,
              (value) => setState(() => comfortRating = value),
            ),

            const SizedBox(height: 30),
            buildSectionTitle("Write your experience *"),
            const SizedBox(height: 15),
            TextField(
              controller: reviewController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText:
                    "Share your real experience about hostel, food, and environment…",
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
                try {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 60,
                    maxWidth: 1200,
                  );
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    if (bytes.isNotEmpty && mounted) {
                      setState(() => selectedImageBytes = bytes);
                    }
                  }
                } catch (e) {
                  debugPrint("Image pick error: $e");
                  _showDialog(
                    "Error",
                    "Failed to pick image: $e",
                    Icons.error,
                    Colors.red,
                  );
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
                          const Text("Upload hostel or food photos"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          selectedImageBytes!,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                          cacheWidth: kIsWeb ? 800 : null,
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
                onPressed: isSubmitting ? null : _submitReview,
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
      bottomNavigationBar: BottomNavigationBar(
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
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoommateMatchingPage()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExperienceFeedPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Review"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Match"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: "Experience",
          ),
        ],
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
      onTap: () => setState(() => selectedEmoji = emoji),
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
