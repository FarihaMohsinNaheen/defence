import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/Owner_Help&Support_page.dart';

import 'package:nan_nestfinder/login_page.dart';
import 'package:nan_nestfinder/owner_aboutus_page.dart';
import 'package:nan_nestfinder/owner_dashboard_page.dart';
import 'package:nan_nestfinder/owner_privacypolicy_page.dart';
import 'package:nan_nestfinder/owner_profile_page.dart';
import 'main.dart';

class OwnerSettingPage extends StatefulWidget {
  const OwnerSettingPage({super.key});

  @override
  State<OwnerSettingPage> createState() => _OwnerSettingsPageState();
}

class _OwnerSettingsPageState extends State<OwnerSettingPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final user = FirebaseAuth.instance.currentUser;
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _loading = true;
  final String adminEmail = "adminnannestfinder@gmail.com";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (mounted && doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _notificationsEnabled = data['notifications_enabled'] ?? true;
          _darkMode = data['dark_mode'] ?? false;
          _loading = false;
        });
        themeNotifier.value = _darkMode ? ThemeMode.dark : ThemeMode.light;
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      key: value,
    });
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(role: 'owner'),
        ), // FIX: student not owner
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OwnerDashboardPage()),
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Account
          _buildSectionTitle("Account"),
          Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _buildNavTile(
                  Icons.person_outline,
                  'Edit Profile',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
                  ),
                ),
                const Divider(height: 1),
                _buildNavTile(
                  Icons.lock_outline,
                  'Change Password',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
                  ),
                ),
                const Divider(height: 1),
                _buildNavTile(
                  Icons.email_outlined,
                  'Change Email',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerProfilePage()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. App Preferences
          _buildSectionTitle("Preferences"),
          Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.notifications_outlined,
                    color: primaryBlue,
                  ),
                  title: const Text('In-app Notifications'),
                  subtitle: const Text('Booking & chat updates'),
                  value: _notificationsEnabled,
                  activeColor: primaryBlue,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                    _updateSetting('notifications_enabled', val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode_outlined, color: primaryBlue),
                  title: const Text('Dark Mode'),
                  value: _darkMode,
                  activeColor: primaryBlue,
                  onChanged: (val) {
                    setState(() => _darkMode = val);
                    _updateSetting('dark_mode', val);
                    themeNotifier.value = val
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Support
          _buildSectionTitle("Support"),
          Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _buildNavTile(
                  Icons.help_outline,
                  'Help & FAQ',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OwnerHelpsupportPage(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _buildNavTile(
                  Icons.info_outline,
                  'About Us',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerAboutUsPage()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.support_agent, color: primaryBlue),
                  title: const Text('Contact Support'),
                  subtitle: Text(adminEmail),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Contact Support"),
                      content: Text("Email us at:\n$adminEmail"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                _buildNavTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OwnerPrivacyPolicyPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 4. Logout Button - Added
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _logout, // calls the confirm dialog
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget _buildNavTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
