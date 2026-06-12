import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'register_page.dart';
import 'home_page.dart';
import 'owner_dashboard_page.dart';
import 'admin_panel.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
  );
  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  static const Color primaryBlue = Color(0xFF003366);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear old SnackBar so message shows fresh every time
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() => isLoading = true);

    try {
      /// 1. FIREBASE AUTH LOGIN
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) throw "User not found";

      /// 2. RELOAD + WAIT FOR FIREBASE SYNC
      await user.reload();
      await Future.delayed(const Duration(seconds: 1));
      User? refreshedUser = FirebaseAuth.instance.currentUser;

      /// 3. BLOCK IF EMAIL NOT VERIFIED - SHOW MESSAGE EVERY TIME
      if (refreshedUser != null && !refreshedUser.emailVerified) {
        // FIX 1: Send mail BEFORE signOut, else user becomes null
        try {
          await refreshedUser.sendEmailVerification();
        } catch (e) {
          print("Send verification error: $e");
        }

        await FirebaseAuth.instance.signOut();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email sent. Check inbox + spam folder"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: "Resend",
              textColor: Colors.white,
              onPressed: () async {
                // FIX 2: Get current user again before sending
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) {
                  // If user signed out, sign in again silently to send mail
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    currentUser = FirebaseAuth.instance.currentUser;
                  } catch (_) {}
                }

                if (currentUser != null && !currentUser.emailVerified) {
                  await currentUser.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Verification email sent again 📧 Check spam",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
        );
        return;
      }

      /// 4. CLEAR SNACKBAR BEFORE NAVIGATION
      ScaffoldMessenger.of(context).clearSnackBars();

      /// 5. FETCH ROLE FROM FIRESTORE
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = doc.data()?['role'].toString().toLowerCase();

      if (!mounted) return;

      /// 6. ROLE BASED NAVIGATION
      if (role == 'owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
        );
      } else if (role == 'student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPanelPage()),
        );
      } else {
        throw "Invalid role in database";
      }
    } catch (e) {
      String errorMsg = "Login failed";

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMsg = "No account found with this email";
        } else if (e.code == 'wrong-password') {
          errorMsg = "Wrong password";
        } else if (e.code == 'invalid-email') {
          errorMsg = "Invalid email format";
        } else {
          errorMsg = e.message ?? "Login failed";
        }
      } else {
        errorMsg = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                "NAN Nest-Finder",
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
                        "Login",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter email";
                          }
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          if (!passwordRegex.hasMatch(value)) {
                            return "Min 8 chars with letters & numbers";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : loginUser,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterPage(role: widget.role),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
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
