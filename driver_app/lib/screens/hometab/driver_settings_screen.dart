import 'package:diu_transport_driver_app/widget/setting_tile.dart';
import 'package:flutter/material.dart';

class DriverSettingsScreen extends StatefulWidget {
  const DriverSettingsScreen({super.key});

  @override
  State<DriverSettingsScreen> createState() => _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends State<DriverSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      'Account Settings',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 20),

                    SettingTile(
                      theme: theme,
                      title: 'Privacy Policy',
                      leadingIcon: Icons.privacy_tip,
                      trailingIcon: Icons.arrow_forward_ios,
                      onTap: (){
                        Navigator.pushNamed(context, '/privacy-policy');
                      }
                    ),
                    SettingTile(
                      theme: theme,
                      title: 'About App',
                      leadingIcon: Icons.info,
                      trailingIcon: Icons.arrow_forward_ios,
                      onTap: () {
                        Navigator.pushNamed(context, '/about-app');
                      },
                    ),
                    SettingTile(
                      theme: theme,
                      title: 'Change Password',
                      leadingIcon: Icons.lock,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('For password changes, please contact the DIU Transport Authority.',style: TextStyle(color: theme.colorScheme.onPrimary)),
                          backgroundColor: theme.colorScheme.primary,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      },
                    ),
                    SettingTile(
                      theme: theme,
                      title: 'Logout',
                      leadingIcon: Icons.logout,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You have been logged out successfully.', style: TextStyle(color: theme.colorScheme.onPrimary)),
                            backgroundColor: theme.colorScheme.primary,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/driver-login');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'App Version: 1.0.0 (Build 20240101)',
                style: theme.textTheme.labelSmall!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
