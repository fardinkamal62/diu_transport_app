import 'package:flutter/material.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_applications,
            size: 80,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            'Settings',
            style: theme.textTheme.headlineMedium!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Adjust app preferences and configurations here.',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.notifications, color: theme.colorScheme.primary),
            title: Text(
              'Notification Preferences',
              style: theme.textTheme.titleMedium,
            ),
            trailing: Switch(
              value: true, // Example switch value
              onChanged: (bool value) {
                // Handle switch toggle
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          Divider(color: theme.dividerTheme.color),
          ListTile(
            leading: Icon(Icons.language, color: theme.colorScheme.primary),
            title: Text(
              'Language',
              style: theme.textTheme.titleMedium,
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface),
            onTap: () {
              // Navigate to language settings
            },
          ),
        ],
      ),
    );
  }
}