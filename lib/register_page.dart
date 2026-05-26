//final white

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'login_page.dart';
// import 'widgets/inputfield_page.dart';

// class RegisterPage extends StatefulWidget {
//   final String role;

//   const RegisterPage({super.key, required this.role});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _cPasswordController = TextEditingController();

//   bool _isLoading = false;

//   final _supabase = Supabase.instance.client;

//   // 🎨 Colors
//   static const Color primaryBlue = Color(0xFF003366);
//   static const Color bg = Color(0xFFE3F2FD);

//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await _supabase.auth.signUp(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final user = response.user;

//       if (user == null) throw Exception("User creation failed");

//       await _supabase.from('users').insert({
//         'id': user.id,
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'role': widget.role,
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Account created successfully 🎉")),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),

//                 /// 🔵 LOGO + APP NAME (SAME COLOR)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.home_work, size: 38, color: primaryBlue),
//                     SizedBox(width: 8),
//                     Text(
//                       "NAN NestFinder",
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: primaryBlue,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   "Create your account to find safe student living",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.black54),
//                 ),

//                 const SizedBox(height: 25),

//                 /// CARD
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     child: Column(
//                       children: [
//                         Text(
//                           "Create Account ✨",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: primaryBlue,
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         /// NAME
//                         InputField(
//                           controller: _nameController,
//                           labelText: "Full Name",
//                           hintText: "Enter full name",
//                           prefixIcon: Icons.person,
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return "Enter name";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 15),

//                         /// EMAIL
//                         InputField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           labelText: "Email",
//                           hintText: "Enter email",
//                           prefixIcon: Icons.email,
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return "Enter email";
//                             }
//                             if (!emailRegex.hasMatch(v)) {
//                               return "Invalid email";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 15),

//                         /// PASSWORD
//                         InputField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           labelText: "Password",
//                           hintText: "Enter password",
//                           prefixIcon: Icons.lock,
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return "Enter password";
//                             }
//                             if (!passwordRegex.hasMatch(v)) {
//                               return "Weak password";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 15),

//                         /// CONFIRM PASSWORD
//                         InputField(
//                           controller: _cPasswordController,
//                           obscureText: true,
//                           labelText: "Confirm Password",
//                           hintText: "Confirm password",
//                           prefixIcon: Icons.lock_outline,
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return "Confirm password";
//                             }
//                             if (v != _passwordController.text) {
//                               return "Passwords do not match";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 25),

//                         /// BUTTON
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryBlue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             onPressed: _isLoading ? null : register,
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text(
//                                     "Create Account",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => LoginPage(role: widget.role),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Already have an account? Login",
//                             style: TextStyle(
//                               color: primaryBlue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         const Text(
//                           "🔒 Your information is secure and verified",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 12),
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

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'login_page.dart';
// import 'widgets/inputfield_page.dart';

// class RegisterPage extends StatefulWidget {
//   final String role;

//   const RegisterPage({super.key, required this.role});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _cPasswordController = TextEditingController();

//   bool _isLoading = false;

//   final _supabase = Supabase.instance.client;

//   // 🎨 COLORS
//   static const Color primaryBlue = Color(0xFF003366);
//   static const Color bg = Color(0xFF003366);

//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await _supabase.auth.signUp(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final user = response.user;

//       if (user == null) throw Exception("User creation failed");

//       await _supabase.from('users').insert({
//         'id': user.id,
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'role': widget.role,
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Account created successfully 🎉")),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBlue,

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 30),

//               /// 🔵 LOGO + APP NAME (WHITE)
//               const Icon(Icons.home_work, size: 60, color: Colors.white),

//               const SizedBox(height: 10),

//               const Text(
//                 "NAN NestFinder",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.2,
//                 ),
//               ),

//               const SizedBox(height: 5),

//               const Text(
//                 "Create your account to find safe student living",
//                 style: TextStyle(color: Colors.white70),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 30),

//               /// ⚪ WHITE CARD
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   child: Column(
//                     children: [
//                       Text(
//                         "Create Account ✨",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: primaryBlue,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       /// NAME
//                       InputField(
//                         controller: _nameController,
//                         labelText: "Full Name",
//                         hintText: "Enter full name",
//                         prefixIcon: Icons.person,
//                         validator: (v) {
//                           if (v == null || v.trim().isEmpty) {
//                             return "Enter name";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       /// EMAIL
//                       InputField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         labelText: "Email",
//                         hintText: "Enter email",
//                         prefixIcon: Icons.email,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter email";
//                           }
//                           if (!emailRegex.hasMatch(v)) {
//                             return "Invalid email";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       /// PASSWORD
//                       InputField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         labelText: "Password",
//                         hintText: "Enter password",
//                         prefixIcon: Icons.lock,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter password";
//                           }
//                           if (!passwordRegex.hasMatch(v)) {
//                             return "Weak password";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       /// CONFIRM PASSWORD
//                       InputField(
//                         controller: _cPasswordController,
//                         obscureText: true,
//                         labelText: "Confirm Password",
//                         hintText: "Confirm password",
//                         prefixIcon: Icons.lock_outline,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Confirm password";
//                           }
//                           if (v != _passwordController.text) {
//                             return "Passwords do not match";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 25),

//                       /// CREATE ACCOUNT BUTTON
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryBlue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: _isLoading ? null : register,
//                           child: _isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Create Account",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => LoginPage(role: widget.role),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "Already have an account? Login",
//                           style: TextStyle(
//                             color: primaryBlue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       const Text(
//                         "🔒 Your information is secure and verified",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'login_page.dart';
// import 'widgets/inputfield_page.dart';

// class RegisterPage extends StatefulWidget {
//   final String role;

//   const RegisterPage({super.key, required this.role});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _cPasswordController = TextEditingController();

//   bool _isLoading = false;

//   final _supabase = Supabase.instance.client;

//   static const Color primaryBlue = Color(0xFF003366);
//   static const Color bg = Color(0xFF003366);

//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await _supabase.auth.signUp(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final user = response.user;

//       if (user == null) throw Exception("User creation failed");

//       await _supabase.from('users').insert({
//         'id': user.id,
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'role': widget.role,
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Account created successfully 🎉")),
//       );

//       // ✅ FIXED NAVIGATION (SAFE DELAY)
//       Future.delayed(const Duration(seconds: 1), () {
//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
//         );
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBlue,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 30),

//               const Icon(Icons.home_work, size: 60, color: Colors.white),

//               const SizedBox(height: 10),

//               const Text(
//                 "NAN NestFinder",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.2,
//                 ),
//               ),

//               const SizedBox(height: 5),

//               const Text(
//                 "Create your account to find safe student living",
//                 style: TextStyle(color: Colors.white70),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 30),

//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),

//                 child: Form(
//                   key: _formKey,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   child: Column(
//                     children: [
//                       Text(
//                         "Create Account ✨",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: primaryBlue,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       InputField(
//                         controller: _nameController,
//                         labelText: "Full Name",
//                         hintText: "Enter full name",
//                         prefixIcon: Icons.person,
//                         validator: (v) {
//                           if (v == null || v.trim().isEmpty) {
//                             return "Enter name";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         labelText: "Email",
//                         hintText: "Enter email",
//                         prefixIcon: Icons.email,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter email";
//                           }
//                           if (!emailRegex.hasMatch(v)) {
//                             return "Invalid email";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         labelText: "Password",
//                         hintText: "Enter password",
//                         prefixIcon: Icons.lock,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter password";
//                           }
//                           if (!passwordRegex.hasMatch(v)) {
//                             return "Weak password";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _cPasswordController,
//                         obscureText: true,
//                         labelText: "Confirm Password",
//                         hintText: "Confirm password",
//                         prefixIcon: Icons.lock_outline,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Confirm password";
//                           }
//                           if (v != _passwordController.text) {
//                             return "Passwords do not match";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 25),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryBlue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: _isLoading ? null : register,
//                           child: _isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Create Account",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => LoginPage(role: widget.role),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "Already have an account? Login",
//                           style: TextStyle(
//                             color: primaryBlue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       const Text(
//                         "🔒 Your information is secure and verified",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'login_page.dart';
// import 'widgets/inputfield_page.dart';

// class RegisterPage extends StatefulWidget {
//   final String role;

//   const RegisterPage({super.key, required this.role});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _cPasswordController = TextEditingController();

//   bool _isLoading = false;

//   final _supabase = Supabase.instance.client;

//   static const Color primaryBlue = Color(0xFF003366);

//   final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
//   );

//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await _supabase.auth.signUp(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final user = response.user;

//       if (user == null) throw Exception("User creation failed");

//       await _supabase.from('users').insert({
//         'id': user.id,
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'role': widget.role,
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Account created successfully 🎉")),
//       );

//       Future.delayed(const Duration(seconds: 1), () {
//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
//         );
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBlue,

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 30),

//               const Icon(Icons.home_work, size: 60, color: Colors.white),

//               const SizedBox(height: 10),

//               const Text(
//                 "NAN NestFinder",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),

//                 child: Form(
//                   key: _formKey,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,

//                   child: Column(
//                     children: [
//                       const Text(
//                         "Create Account ✨",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: primaryBlue,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       InputField(
//                         controller: _nameController,
//                         labelText: "Full Name",
//                         hintText: "Enter full name",
//                         prefixIcon: Icons.person,
//                         validator: (v) {
//                           if (v == null || v.trim().isEmpty) {
//                             return "Enter name";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         labelText: "Email",
//                         hintText: "Enter email",
//                         prefixIcon: Icons.email,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter email";
//                           }
//                           if (!emailRegex.hasMatch(v)) {
//                             return "Invalid email";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         labelText: "Password",
//                         hintText: "Enter password",
//                         prefixIcon: Icons.lock,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Enter password";
//                           }
//                           if (!passwordRegex.hasMatch(v)) {
//                             return "Minimum 8 characters";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 15),

//                       InputField(
//                         controller: _cPasswordController,
//                         obscureText: true,
//                         labelText: "Confirm Password",
//                         hintText: "Confirm password",
//                         prefixIcon: Icons.lock_outline,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return "Confirm password";
//                           }
//                           if (v != _passwordController.text) {
//                             return "Passwords do not match";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 25),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryBlue,
//                           ),
//                           onPressed: _isLoading ? null : register,
//                           child: _isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Create Account",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => LoginPage(role: widget.role),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Already have an account? Login",
//                           style: TextStyle(color: primaryBlue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  bool _isLoading = false;

  final _supabase = Supabase.instance.client;

  static const Color primaryBlue = Color(0xFF003366);

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@(gmail\.com|lus\.ac\.bd)$',
  );

  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) throw Exception("User creation failed");

      await _supabase.from('users').insert({
        'id': user.id,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': widget.role,
      });

      if (!mounted) return;

      /// ✅ ADDED EMAIL VERIFICATION HANDLING
      if (user.emailConfirmedAt == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Verification email sent. Please check your inbox 📩",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully 🎉")),
        );
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      InputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        hintText: "Enter email",
                        prefixIcon: Icons.email,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter email";
                          }
                          if (!emailRegex.hasMatch(v)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      InputField(
                        controller: _passwordController,
                        obscureText: true,
                        labelText: "Password",
                        hintText: "Enter password",
                        prefixIcon: Icons.lock_outline,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter password";
                          }
                          if (!passwordRegex.hasMatch(v)) {
                            return "Minimum 8 characters";
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
                          if (v == null || v.isEmpty) {
                            return "Confirm password";
                          }
                          if (v != _passwordController.text) {
                            return "Passwords do not match";
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
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginPage(role: widget.role),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: primaryBlue),
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
