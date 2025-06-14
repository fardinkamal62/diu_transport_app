import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../widget/setting_tile.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreen();
}

class _DriverProfileScreen extends State<DriverProfileScreen> {
  String? phoneNumber;
  String? name;
  List<dynamic>? preferredVehicle;

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
        phoneNumber = data['driverDetails']['phoneNumber'];
        name = data['driverDetails']['name'];
        preferredVehicle = data['driverDetails']['preferredVehicle'];
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushReplacementNamed(context, '/driver-login'); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage: const NetworkImage(
                'https://static.wixstatic.com/media/85077f_fc2608aea08d4936aeb7fbb7a255286d~mv2.png/v1/fill/w_805,h_848,al_c/DriverPlaceHolder.png'// Placeholder image for driver profile
              ),
              child: Stack(
                children: [
                  if (false) // Only show if backgroundImage is null or failed to load
                    Icon(Icons.person, size: 70, color: theme.colorScheme.onPrimary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$name', // Driver's Name
              style: theme.textTheme.headlineMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: theme.colorScheme.surface,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildProfileDetailRow(
                      context,
                      icon: Icons.phone,
                      label: 'Phone',
                      value: '$phoneNumber',
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SettingTile(
              theme: theme,
              title: 'Logout',
              leadingIcon: Icons.logout,
              onTap: _logout,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}