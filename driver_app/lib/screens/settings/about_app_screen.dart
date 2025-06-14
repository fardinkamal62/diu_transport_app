import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // --- App Logo/Icon ---
            Icon(
              Icons.directions_bus, // Or your actual app logo/icon
              size: 100,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),

            // --- App Name and Version ---
            Text(
              'DIU Transport Driver App',
              style: theme.textTheme.headlineLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0 (Build 20240614)', // Current App Version
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // --- App Description ---
            Text(
              'The DIU Transport Driver App empowers drivers of Dhaka International University\'s transport fleet with tools to manage their daily shifts, track routes, verify student reservations via QR codes, and communicate effectively. Our goal is to streamline the transport system for a safer and more efficient commute.',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            // --- Developer/Company Info ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Developed by:',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Department of CSE, Dhaka International University',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 30),

            //TODO:: Developers contact information with link.


            // --- Copyright Information ---
            Text(
              '© 2025 Dhaka International University. All rights reserved.',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}