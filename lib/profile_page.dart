import 'package:flutter/material.dart';

const Color navyBlue = Color.fromARGB(255, 2, 17, 46);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),

        child: SingleChildScrollView(
          child: Column(
            children: [
              /// PROFILE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Stack(
                      children: [
                        /// PROFILE IMAGE
                        const CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage("assets/images/doll.jpg"),
                        ),

                        /// ONLINE DOT
                        Positioned(
                          bottom: 2,
                          right: 2,

                          child: Container(
                            width: 18,
                            height: 18,

                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,

                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Fariha Naheen",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "CSE",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// MENU CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  children: [
                    menuTile(Icons.star_border, "My Reviews"),

                    divider(),

                    menuTile(Icons.home_outlined, "My Bookings"),

                    divider(),

                    menuTile(Icons.favorite_border, "Saved Hostels"),

                    divider(),

                    menuTile(Icons.settings_outlined, "Settings"),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: () {},

                  icon: const Icon(Icons.logout, color: Colors.white),

                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: navyBlue),

      title: Text(title),

      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget divider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
}
