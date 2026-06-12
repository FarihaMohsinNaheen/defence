import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/roleselection_page.dart';

import 'login_page.dart';
import 'widgets/inputfield_page.dart';

class RegisterPage extends StatefulWidget {
  final String role;

  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF003366);
  static const Color borderColor = Color(0xFFB0BEC5);

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
  );
  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');
  final RegExp phoneRegex = RegExp(r'^(01[3-9]\d{8})$');

  String? selectedDepartment;
  String? selectedLifestyle;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) throw Exception("User creation failed");

      // Save name to Firebase Auth profile
      await user.updateDisplayName(_nameController.text.trim());

      // Save to Firestore
      final String phone = _phoneController.text.trim();
      final String email = _emailController.text.trim();

      final Map<String, dynamic> data = {
        'id': user.uid,
        'name': _nameController.text.trim(),
        'email': email,
        'phone': phone,
        'role': widget.role.toLowerCase(),
        'created_at': FieldValue.serverTimestamp(),
      };

      // For owner, save business name + owner_phone + owner_email
      if (widget.role.toLowerCase() == "owner") {
        data['business_name'] = _businessNameController.text.trim();
        data['owner_phone'] = phone;
        data['owner_email'] = email;
      }

      if (widget.role == "student") {
        data['department'] = selectedDepartment;
        data['lifestyle'] = selectedLifestyle;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(data);

      // 1. Send verification email
      await user.sendEmailVerification();

      // 2. Sign out immediately
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // 3. Show dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Verify your email 📧"),
          content: Text(
            "We sent a verification link to:\n$email\nClick it in Gmail, then come back and login.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(role: widget.role),
                  ),
                );
              },
              child: Text("OK, Go to Login"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Clean error messages for defense
      String errorMsg = "Registration failed";

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMsg = "This email already exists. Try login instead";
        } else if (e.code == 'weak-password') {
          errorMsg = "Password must be 6+ characters";
        } else if (e.code == 'invalid-email') {
          errorMsg = "Invalid email format";
        } else {
          errorMsg = e.message ?? "Registration failed";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildDropdownBox({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    IconData icon = Icons.arrow_drop_down,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryBlue),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryBlue, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 1.2),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
      isExpanded: true,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.home_work, size: 60, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "NAN NestFinder",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const Text(
                        "Create Account ✨",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 20),

                      InputField(
                        controller: _nameController,
                        labelText: "Full Name",
                        hintText: "Enter full name",
                        prefixIcon: Icons.person,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Enter name"
                            : null,
                      ),

                      const SizedBox(height: 15),

                      InputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        hintText: "Enter email",
                        prefixIcon: Icons.email,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter email";
                          if (!emailRegex.hasMatch(v)) return "Invalid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      InputField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        labelText: "Phone Number *",
                        hintText: "01XXXXXXXXX",
                        prefixIcon: Icons.phone,
                        maxLength: 11,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter phone number";
                          }
                          if (!phoneRegex.hasMatch(v)) {
                            return "Enter valid BD number 01XXXXXXXXX";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      if (widget.role.toLowerCase() == "owner") ...[
                        InputField(
                          controller: _businessNameController,
                          labelText: "Business Name *",
                          hintText: "Enter your hostel/business name",
                          prefixIcon: Icons.business,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Enter business name"
                              : null,
                        ),
                        const SizedBox(height: 15),
                      ],

                      InputField(
                        controller: _passwordController,
                        obscureText: true,
                        labelText: "Password",
                        hintText: "Enter password",
                        prefixIcon: Icons.lock_outline,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter password";
                          if (!passwordRegex.hasMatch(v)) {
                            return "Minimum 8 characters with number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      InputField(
                        controller: _cPasswordController,
                        obscureText: true,
                        labelText: "Confirm Password",
                        hintText: "Confirm password",
                        prefixIcon: Icons.lock_outline,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Confirm password";
                          if (v != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      if (widget.role == "student") ...[
                        const SizedBox(height: 15),
                        _buildDropdownBox(
                          label: "Department *",
                          value: selectedDepartment,
                          icon: Icons.school,
                          items: const [
                            DropdownMenuItem(value: "CSE", child: Text("CSE")),
                            DropdownMenuItem(
                              value: "Architecture",
                              child: Text("Architecture"),
                            ),
                            DropdownMenuItem(
                              value: "Civil",
                              child: Text("Civil"),
                            ),
                            DropdownMenuItem(value: "EEE", child: Text("EEE")),
                            DropdownMenuItem(value: "BBA", child: Text("BBA")),
                            DropdownMenuItem(
                              value: "English",
                              child: Text("English"),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedDepartment = value),
                          validator: (v) =>
                              (widget.role == "student" && v == null)
                              ? "Select department"
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildDropdownBox(
                          label: "Lifestyle *",
                          value: selectedLifestyle,
                          icon: Icons.people,
                          items: const [
                            DropdownMenuItem(
                              value: "Study-focused",
                              child: Text("Study-focused"),
                            ),
                            DropdownMenuItem(
                              value: "Quiet",
                              child: Text("Quiet"),
                            ),
                            DropdownMenuItem(
                              value: "Social",
                              child: Text("Social"),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedLifestyle = value),
                          validator: (v) =>
                              (widget.role == "student" && v == null)
                              ? "Select lifestyle"
                              : null,
                        ),
                      ],

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _isLoading ? null : register,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Create Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginPage(role: widget.role),
                          ),
                        ),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: primaryBlue),
                        ),
                      ),
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RoleSelectionPage(), // <- your role selection page
                          ),
                        ),
                        child: const Text(
                          "Go back to Role Selection Page",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
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
}
