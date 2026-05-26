// import 'package:flutter/material.dart';
// import 'register_page.dart';
// import 'home_page.dart';
// import 'owner_dashboard_page.dart';

// const Color navyBlue = Color.fromARGB(255, 2, 17, 46);

// class LoginPage extends StatefulWidget {
//   final String role; // ✅ ADDED ROLE

//   const LoginPage({super.key, required this.role});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   // ✅ REGEX
//   final RegExp phoneRegex = RegExp(r"^[0-9]{10,15}$");
//   final RegExp passwordRegex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$");

//   void loginUser() {
//     if (_formKey.currentState!.validate()) {
//       if (widget.role == "Student") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),

//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.home_work, color: navyBlue),
//                     SizedBox(width: 8),
//                     Text(
//                       "NAN NestFinder",
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: navyBlue,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   "Find Safe & Trusted Student Living",
//                   style: TextStyle(color: Colors.grey),
//                 ),

//                 const SizedBox(height: 20),

//                 const Icon(Icons.apartment, size: 60, color: navyBlue),

//                 const SizedBox(height: 20),

//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 12,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Welcome Back (${widget.role}) 👋",
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       /// PHONE
//                       TextFormField(
//                         controller: phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           hintText: "Enter phone number",
//                           prefixIcon: const Icon(Icons.phone_outlined),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Enter phone number";
//                           }
//                           if (!phoneRegex.hasMatch(value)) {
//                             return "Enter valid phone number";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       /// PASSWORD
//                       TextFormField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Enter password",
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Enter password";
//                           }
//                           if (!passwordRegex.hasMatch(value)) {
//                             return "Weak password (letters + numbers)";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 24),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 55,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: navyBlue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           onPressed: loginUser,
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(color: Colors.white, fontSize: 17),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Don't have an account?"),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       RegisterPage(role: widget.role),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               " Sign Up",
//                               style: TextStyle(
//                                 color: navyBlue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'register_page.dart';
// import 'home_page.dart';
// import 'owner_dashboard_page.dart';

// const Color navyBlue = Color.fromARGB(255, 2, 17, 46);

// class LoginPage extends StatefulWidget {
//   final String role;

//   const LoginPage({super.key, required this.role});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   final supabase = Supabase.instance.client;

//   bool isLoading = false;

//   /// EMAIL REGEX
//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   /// PASSWORD REGEX
//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> loginUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       /// LOGIN WITH SUPABASE
//       await supabase.auth.signInWithPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       /// NAVIGATE BASED ON ROLE
//       if (widget.role == "Student") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//         );
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),

//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.home_work, color: navyBlue),
//                     SizedBox(width: 8),
//                     Text(
//                       "NAN NestFinder",
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: navyBlue,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   "Find Safe & Trusted Student Living",
//                   style: TextStyle(color: Colors.grey),
//                 ),

//                 const SizedBox(height: 20),

//                 const Icon(Icons.apartment, size: 60, color: navyBlue),

//                 const SizedBox(height: 20),

//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 12,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Welcome Back (${widget.role}) 👋",
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       /// EMAIL
//                       TextFormField(
//                         controller: emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: InputDecoration(
//                           hintText: "Enter email",
//                           prefixIcon: const Icon(Icons.email_outlined),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Enter email";
//                           }
//                           if (!emailRegex.hasMatch(value.trim())) {
//                             return "Use Gmail or lus.ac.bd email";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       /// PASSWORD
//                       TextFormField(
//                         controller: passwordController,
//                         obscureText: true,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: InputDecoration(
//                           hintText: "Enter password",
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Enter password";
//                           }
//                           if (!passwordRegex.hasMatch(value)) {
//                             return "Weak password (letters + numbers)";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 24),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 55,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: navyBlue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           onPressed: isLoading ? null : loginUser,
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Login",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 17,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Don't have an account?"),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       RegisterPage(role: widget.role),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               " Sign Up",
//                               style: TextStyle(
//                                 color: navyBlue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'register_page.dart';
// import 'home_page.dart';
// import 'owner_dashboard_page.dart';

// class LoginPage extends StatefulWidget {
//   final String role;

//   const LoginPage({super.key, required this.role});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   final supabase = Supabase.instance.client;

//   bool isLoading = false;

//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> loginUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       await supabase.auth.signInWithPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       /// ROLE BASED NAVIGATION
//       if (widget.role == "Student") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
//         );
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF10B981)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const Icon(
//                   Icons.home_work_rounded,
//                   size: 70,
//                   color: Colors.white,
//                 ),

//                 const SizedBox(height: 10),

//                 const Text(
//                   "NAN NestFinder",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),

//                 const SizedBox(height: 5),

//                 Text(
//                   "Safe & Trusted Student Living",
//                   style: TextStyle(color: Colors.white.withOpacity(0.8)),
//                 ),

//                 const SizedBox(height: 30),

//                 /// LOGIN CARD
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 15,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Text(
//                           "Login as ${widget.role}",
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         /// EMAIL
//                         TextFormField(
//                           controller: emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Enter email";
//                             }
//                             if (!emailRegex.hasMatch(value.trim())) {
//                               return "Invalid email format";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 15),

//                         /// PASSWORD
//                         TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             prefixIcon: const Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Enter password";
//                             }
//                             if (!passwordRegex.hasMatch(value)) {
//                               return "Weak password";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 20),

//                         /// LOGIN BUTTON
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF1E3A8A),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: isLoading ? null : loginUser,
//                             child: isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text(
//                                     "Login",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         /// SIGN UP NAVIGATION (FIXED)
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => RegisterPage(role: widget.role),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(
//                               color: Color(0xFF1E3A8A),
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'register_page.dart';
import 'home_page.dart';
import 'owner_dashboard_page.dart';

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
  final supabase = Supabase.instance.client;

  bool isLoading = false;

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
  );

  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (widget.role == "Student") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  static const Color primaryBlue = Color(0xFF003366);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// LOGO + NAME
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

              /// WHITE CARD
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
                      Text(
                        "Login as ${widget.role}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// EMAIL
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

                      /// PASSWORD
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

                      /// LOGIN BUTTON
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

                      /// REGISTER LINK (NO UNDERLINE)
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
