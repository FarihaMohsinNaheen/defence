import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nan_nestfinder/home_page.dart';
import 'package:nan_nestfinder/owner_dashboard_page.dart';
import 'package:nan_nestfinder/review_page.dart';
import 'package:nan_nestfinder/roommatematcher_page.dart';
import 'package:nan_nestfinder/admin_panel.dart';

class ExperienceFeedPage extends StatefulWidget {
  final bool isAdminPanel; // Admin Panel এর Tab এ use করলে true দিবেন

  const ExperienceFeedPage({super.key, this.isAdminPanel = false});

  @override
  State<ExperienceFeedPage> createState() => _ExperienceFeedPageState();
}

class _ExperienceFeedPageState extends State<ExperienceFeedPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;

  String userRole = 'student';
  bool isLoadingRole = true;
  Map<String, String> userProfileCache = {};
  bool profilesLoading = false;

  int get currentIndex => userRole == 'student' ? 3 : 1;

  @override
  void initState() {
    super.initState();
    if (!widget.isAdminPanel) {
      _fetchUserRole(); // Admin Panel এ role লাগবে না
    } else {
      setState(() => isLoadingRole = false);
    }
  }

  Future<void> _fetchUserRole() async {
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          userRole = doc.data()?['role'] ?? 'student';
          isLoadingRole = false;
        });
      } else {
        setState(() => isLoadingRole = false);
      }
    } catch (e) {
      debugPrint("Error fetching role: $e");
      setState(() => isLoadingRole = false);
    }
  }

  T _get<T>(Map data, String key, T defaultValue) {
    final val = data[key];
    return (val is T) ? val : defaultValue;
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 16,
        );
      }),
    );
  }

  Widget _ratingChip(String label, int rating) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        _buildStars(rating),
      ],
    );
  }

  Future<void> _loadUserProfiles(List<String> studentIds) async {
    if (profilesLoading) return;
    profilesLoading = true;

    final uniqueIds = studentIds
        .where((id) => id.isNotEmpty && !userProfileCache.containsKey(id))
        .toSet()
        .toList();
    if (uniqueIds.isEmpty) {
      profilesLoading = false;
      return;
    }

    final futures = uniqueIds.map((id) async {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .get();
        userProfileCache[id] = doc.data()?['profile']?.toString() ?? '';
      } catch (e) {
        userProfileCache[id] = '';
      }
    });

    await Future.wait(futures);
    profilesLoading = false;
    if (mounted) setState(() {});
  }

  void _handleBack() {
    if (userRole == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminPanelPage()),
      );
    } else if (userRole == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  // Review list এর main code - Admin + Student/Owner 2 জায়গায় use হবে
  Widget _buildReviewList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No reviews yet",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data!.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id;
          return data;
        }).toList();

        final studentIds = posts
            .map((p) => _get<String>(p, 'studentId', ''))
            .toList();
        Future.microtask(() => _loadUserProfiles(studentIds));

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final studentId = _get<String>(post, 'studentId', '');
            final name = _get<String>(post, 'studentName', 'Student');
            final hostelName = _get<String>(post, 'hostelName', 'Hostel');
            final text = _get<String>(post, 'reviewText', '');
            final image = _get<String>(post, 'imageUrl', '');
            final emoji = _get<String>(post, 'emoji', '');
            final overallRating = _get<int>(post, 'overallRating', 0);
            final createdAt = (post['createdAt'] as Timestamp?)?.toDate();
            final profileUrl = userProfileCache[studentId] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: primaryBlue,
                        backgroundImage: profileUrl.isNotEmpty
                            ? NetworkImage(profileUrl)
                            : null,
                        child: profileUrl.isEmpty
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'S',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.apartment,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hostelName,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (createdAt != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            DateFormat('dd MMM').format(createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStars(overallRating),
                      const SizedBox(width: 8),
                      if (emoji.isNotEmpty)
                        Text(emoji, style: const TextStyle(fontSize: 24)),
                      const Spacer(),
                      Text(
                        "Overall: $overallRating/5",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ratingChip("Food", _get<int>(post, 'foodRating', 0)),
                      _ratingChip(
                        "Cleanliness",
                        _get<int>(post, 'cleanlinessRating', 0),
                      ),
                      _ratingChip("Safety", _get<int>(post, 'safetyRating', 0)),
                      _ratingChip(
                        "Comfort",
                        _get<int>(post, 'comfortRating', 0),
                      ),
                    ],
                  ),
                  if (image.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        cacheWidth: 800,
                        loadingBuilder: (context, child, progress) =>
                            progress == null
                            ? child
                            : Container(
                                height: 250,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                        errorBuilder: (_, __, ___) => Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingRole) {
      return const Center(child: CircularProgressIndicator());
    }

    // Admin Panel এর Tab এর ভিতর বসালে শুধু list return করবে
    if (widget.isAdminPanel) {
      return _buildReviewList();
    }

    // Student/Owner এর জন্য full page with AppBar + bottomNav
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: _handleBack,
        ),
        title: Text(
          "Student Experiences",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildReviewList(),
      bottomNavigationBar: userRole == 'student'
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              selectedItemColor: primaryBlue,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: (i) {
                if (i == currentIndex) return;
                if (i == 0)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                else if (i == 1)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewPage()),
                  );
                else if (i == 2)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoommateMatchingPage(),
                    ),
                  );
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.reviews),
                  label: "Review",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: "Match",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dynamic_feed),
                  label: "Experience",
                ),
              ],
            )
          : null,
    );
  }
}
