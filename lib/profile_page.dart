import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final Color primaryBlue = const Color(0xFF003366);

  final String cloudName = "dmdq2dtol";
  final String uploadPreset = "hostel_present";

  String name = "Loading...";
  String email = "Loading...";
  String phone = "Loading...";
  String profile = "";
  List<String> secondaryEmails = [];
  String uid = "";

  bool isLoading = true;
  bool isUpdatingPic = false;

  final ImagePicker picker = ImagePicker();
  Uint8List? newImageBytes;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    uid = user.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists && mounted) {
      setState(() {
        name = doc.data()?['name'] ?? user.displayName ?? "No Name";
        email = doc.data()?['email'] ?? user.email ?? "No Email";
        phone = doc.data()?['phone'] ?? "Not added";
        profile = doc.data()?['profile'] ?? "";
        secondaryEmails = List<String>.from(
          doc.data()?['secondary_emails'] ?? [],
        );
        isLoading = false;
      });
    } else {
      setState(() {
        email = user.email ?? "";
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => newImageBytes = bytes);
      _uploadProfilePic(bytes);
    }
  }

  Future<void> _uploadProfilePic(Uint8List bytes) async {
    try {
      setState(() => isUpdatingPic = true);
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'student_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final newUrl = jsonDecode(respStr)['secure_url'];
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profile': newUrl,
        });
        setState(() {
          profile = newUrl;
          newImageBytes = null;
          isUpdatingPic = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile picture updated ✅"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => isUpdatingPic = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // EDIT PROFILE: Only Name + Phone
  void _showEditProfileDialog() {
    nameController.text = name;
    phoneController.text = phone == "Not added" ? "" : phone;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: _updateNamePhone,
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNamePhone() async {
    final newName = nameController.text.trim();
    final newPhone = phoneController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name cannot be empty"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': newName,
      'phone': newPhone,
      'updated_at': FieldValue.serverTimestamp(),
    });

    setState(() {
      name = newName;
      phone = newPhone.isEmpty ? "Not added" : newPhone;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated ✅"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ADD SECONDARY EMAIL
  void _showAddEmailDialog() {
    newEmailController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Add Another Email",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: newEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "New Email",
            prefixIcon: Icon(Icons.email_outlined, color: primaryBlue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: _addSecondaryEmail,
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _addSecondaryEmail() async {
    final newEmail = newEmailController.text.trim();
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (newEmail == email || secondaryEmails.contains(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already exists"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    secondaryEmails.add(newEmail);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'secondary_emails': secondaryEmails,
    });

    setState(() {});
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email added ✅"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // SWITCH PRIMARY EMAIL
  void _showSwitchEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Switch Email",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.email, color: primaryBlue),
              title: Text(email),
              subtitle: const Text("Primary"),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
            ...secondaryEmails.map(
              (e) => ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.grey),
                title: Text(e),
                onTap: () async {
                  // swap emails
                  secondaryEmails.remove(e);
                  secondaryEmails.add(email);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                        'email': e,
                        'secondary_emails': secondaryEmails,
                      });
                  setState(() => email = e);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Switched to $e"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // CHANGE PASSWORD - separate option
  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final currentPass = currentPassController.text.trim();
    final newPass = newPassController.text.trim();
    final confirmPass = confirmPassController.text.trim();

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be 6+ characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords don't match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPass,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPass);

      if (mounted) {
        Navigator.pop(context);
        currentPassController.clear();
        newPassController.clear();
        confirmPassController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password changed ✅"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      String msg = "Error changing password";
      if (e.toString().contains("wrong-password")) {
        msg = "Current password is wrong";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showChangePasswordDialog() {
    currentPassController.clear();
    newPassController.clear();
    confirmPassController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Change Password",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                prefixIcon: Icon(Icons.lock, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: Icon(Icons.lock_outline, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                prefixIcon: Icon(Icons.lock_reset, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: _changePassword,
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: primaryBlue),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryBlue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: primaryBlue.withOpacity(0.1),
                              backgroundImage: newImageBytes != null
                                  ? MemoryImage(newImageBytes!)
                                  : profile.isNotEmpty
                                  ? NetworkImage(profile)
                                  : null,
                              child: profile.isEmpty && newImageBytes == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: primaryBlue,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: isUpdatingPic ? null : pickImage,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: primaryBlue,
                                  child: isUpdatingPic
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Student",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildInfoCard(Icons.email, "Primary Email", email, false),
                  _buildInfoCard(Icons.phone, "Phone", phone, false),

                  GestureDetector(
                    onTap: _showEditProfileDialog,
                    child: _buildInfoCard(
                      Icons.edit,
                      "Edit Profile",
                      "Name & Phone only",
                      true,
                    ),
                  ),

                  GestureDetector(
                    onTap: _showAddEmailDialog,
                    child: _buildInfoCard(
                      Icons.add_circle_outline,
                      "Add Another Email",
                      "Add backup email",
                      true,
                    ),
                  ),

                  if (secondaryEmails.isNotEmpty)
                    GestureDetector(
                      onTap: _showSwitchEmailDialog,
                      child: _buildInfoCard(
                        Icons.swap_horiz,
                        "Switch Email",
                        "${secondaryEmails.length} backup email(s)",
                        true,
                      ),
                    ),

                  GestureDetector(
                    onTap: _showChangePasswordDialog,
                    child: _buildInfoCard(
                      Icons.key,
                      "Change Password",
                      "Update password",
                      true,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _logout,
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String value,
    bool clickable,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (clickable)
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
