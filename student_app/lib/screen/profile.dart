import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // Import Clipboard functionality
import 'package:qr_flutter/qr_flutter.dart'; // Import QR code package

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profilePhoto;
  String? name;
  String? regCode;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final data = json.decode(userData);
      setState(() {
        profilePhoto = data['user']['profile_photo'];
        name = data['user']['name'];
        regCode = data['user']['reg_code'];
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (profilePhoto != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profilePhoto!),
              )
            else
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
            const SizedBox(height: 20),
            if (name != null)
              Text(
                name!,
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Registration Number:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (regCode != null) {
                      Clipboard.setData(ClipboardData(text: regCode!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration code copied to clipboard')),
                      );
                    }
                  },
                  child: Text(
                    '$regCode',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Indicate it's clickable
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (regCode != null)
              Column(
                children: [
                  const SizedBox(height: 10),
                  QrImageView(
                    data: regCode!,
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ],
              ),
            const Spacer(), // Push the logout button to the bottom
            ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Make the button red
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.logout, color: Colors.white), // Add logout icon
            ),
          ],
        ),
      ),
    );
  }
}