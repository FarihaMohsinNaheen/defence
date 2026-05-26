// import 'package:flutter/material.dart';

// class HelpSupportPage extends StatefulWidget {
//   const HelpSupportPage({super.key});

//   @override
//   State<HelpSupportPage> createState() => _HelpSupportPageState();
// }

// class _HelpSupportPageState extends State<HelpSupportPage> {
//   final Color primaryBlue = const Color(0xFF003366);

//   final TextEditingController messageController = TextEditingController();

//   final List<Map<String, String>> faqs = [
//     {
//       "q": "How do I book a hostel?",
//       "a": "Open hostel details and tap 'Book Now'.",
//     },
//     {
//       "q": "How can I contact hostel owner?",
//       "a": "Use contact option inside hostel details.",
//     },
//     {
//       "q": "How does roommate matching work?",
//       "a": "We match based on department and preferences.",
//     },
//     {
//       "q": "Can I save hostels?",
//       "a": "Yes, tap the heart icon to save hostels.",
//     },
//   ];

//   void showPopup({required Widget content}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         Future.delayed(const Duration(seconds: 2), () {
//           Navigator.pop(context);
//         });

//         return Center(
//           child: Material(color: Colors.transparent, child: content),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: primaryBlue),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Help & Support",
//           style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// TITLE
//             Text(
//               "How can we help you?",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),

//             const SizedBox(height: 15),

//             /// SEARCH BAR
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   icon: Icon(Icons.search),
//                   hintText: "Search help topics...",
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// FAQ TITLE
//             Text(
//               "Frequently Asked Questions",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),

//             const SizedBox(height: 15),

//             ...faqs.map((faq) => faqTile(faq["q"]!, faq["a"]!)),

//             const SizedBox(height: 25),

//             /// CONTACT SUPPORT
//             Text(
//               "Contact Support",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: primaryBlue,
//               ),
//             ),

//             const SizedBox(height: 15),

//             Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: messageController,
//                     maxLines: 4,
//                     decoration: const InputDecoration(
//                       hintText: "Write your message...",
//                       border: InputBorder.none,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   /// SEND MESSAGE BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryBlue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (messageController.text.trim().isEmpty) {
//                           showPopup(
//                             content: Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: const Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.error,
//                                     color: Colors.red,
//                                     size: 55,
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     "Please write a message first!",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                           return;
//                         }

//                         messageController.clear();

//                         showPopup(
//                           content: Container(
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green,
//                                   size: 55,
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   "Message Sent Successfully!",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Send Message",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white, // ✅ FIXED
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// CONTACT OPTIONS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 contactCard(Icons.email, "Email"),
//                 contactCard(Icons.call, "Call"),
//                 contactCard(Icons.chat, "Chat"),
//               ],
//             ),

//             const SizedBox(height: 35),

//             /// DANGER ZONE
//             Text(
//               "Danger Zone",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red.shade700,
//               ),
//             ),

//             const SizedBox(height: 10),

//             Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 border: Border.all(color: Colors.red),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Delete My Account",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   const Text(
//                     "All your data will be permanently deleted.",
//                     style: TextStyle(color: Colors.grey),
//                   ),

//                   const SizedBox(height: 12),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text("Delete Account"),
//                             content: const Text(
//                               "Are you sure you want to delete your account?",
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text("Cancel"),
//                               ),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                 ),
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Delete My Account",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   /// FAQ TILE
//   Widget faqTile(String question, String answer) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: ExpansionTile(
//         title: Text(
//           question,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: [
//           Padding(padding: const EdgeInsets.all(12), child: Text(answer)),
//         ],
//       ),
//     );
//   }

//   /// CONTACT CARD
//   Widget contactCard(IconData icon, String label) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: primaryBlue),
//           const SizedBox(height: 5),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final Color primaryBlue = const Color(0xFF003366);

  final TextEditingController messageController = TextEditingController();

  String searchQuery = "";

  /// MASTER FAQ LIST (DO NOT FILTER THIS DIRECTLY)
  final List<Map<String, String>> faqs = [
    {
      "q": "How do I book a hostel?",
      "a": "Open hostel details and tap 'Book Now'.",
    },
    {
      "q": "How can I contact hostel owner?",
      "a": "Use contact option inside hostel details.",
    },
    {
      "q": "How does roommate matching work?",
      "a": "We match based on department and preferences.",
    },
    {
      "q": "Can I save hostels?",
      "a": "Yes, tap the heart icon to save hostels.",
    },
  ];

  /// REAL APP STYLE FILTER LOGIC
  List<Map<String, String>> get filteredFaqs {
    if (searchQuery.isEmpty) return faqs;

    return faqs.where((faq) {
      final q = faq["q"]!.toLowerCase();
      final a = faq["a"]!.toLowerCase();
      final query = searchQuery.toLowerCase();

      return q.contains(query) || a.contains(query);
    }).toList();
  }

  /// POPUP FUNCTION
  void showPopup(Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });

        return Center(
          child: Material(color: Colors.transparent, child: content),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 15),

            /// SEARCH BAR (REAL WORKING)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search help topics...",
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// FAQ TITLE
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 15),

            /// FAQ LIST (REAL FILTER)
            filteredFaqs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No results found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: filteredFaqs
                        .map((faq) => faqTile(faq["q"]!, faq["a"]!))
                        .toList(),
                  ),

            const SizedBox(height: 25),

            /// CONTACT SUPPORT
            Text(
              "Contact Support",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Write your message...",
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// SEND MESSAGE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (messageController.text.trim().isEmpty) {
                          showPopup(
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 55,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Please write a message first!",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                          return;
                        }

                        messageController.clear();

                        showPopup(
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 55,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Message Sent Successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Send Message",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// CONTACT OPTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                contactCard(Icons.email, "Email"),
                contactCard(Icons.call, "Call"),
                contactCard(Icons.chat, "Chat"),
              ],
            ),

            const SizedBox(height: 35),

            /// DELETE ACCOUNT
            Text(
              "Danger Zone",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delete My Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This action is permanent and cannot be undone.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Account"),
                            content: const Text(
                              "Are you sure you want to delete your account?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Delete My Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FAQ TILE
  Widget faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(padding: const EdgeInsets.all(12), child: Text(answer)),
        ],
      ),
    );
  }

  /// CONTACT CARD
  Widget contactCard(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryBlue),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}
