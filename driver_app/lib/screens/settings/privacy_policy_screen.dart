import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for DIU Transport Driver App',
              style: theme.textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: June 14, 2025', // Current Date
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '1. Introduction'),
            _buildParagraph(
              context,
              'This Privacy Policy describes how Daffodil International University ("DIU", "we", "us", or "our") collects, uses, and discloses your information in connection with your use of the DIU Transport Driver App (the "App"). This App is designed exclusively for drivers affiliated with DIU\'s transport system to manage their duties efficiently. By using the App, you agree to the collection and use of information in accordance with this policy.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '2. Information We Collect'),
            _buildSubSectionTitle(context, '2.1 Personal Information:'),
            _buildListItem(context, '**Driver Profile Data:** When you use the App, we collect personal information provided during your registration and profile setup, which may include your name, employee ID, contact number, email address, assigned vehicle details (type, license plate), and assigned routes.'),
            _buildListItem(context, '**Emergency Contact Information:** Details of your emergency contacts, if provided.'),
            const SizedBox(height: 12),

            _buildSubSectionTitle(context, '2.2 Location Information:'),
            _buildListItem(context, '**Precise Location:** We collect real-time precise location data (GPS) from your device when the App is in use and, depending on your device settings and permissions, sometimes in the background. This is essential for route monitoring, ensuring timely service, managing vehicle assignments, and for safety purposes during your shift.'),
            const SizedBox(height: 12),

            _buildSubSectionTitle(context, '2.3 QR Scan Data:'),
            _buildListItem(context, 'When you use the QR scanner feature, we collect data related to scanned student IDs and reservation details to verify student eligibility for transport services.'),
            const SizedBox(height: 12),

            _buildSubSectionTitle(context, '2.4 Device and Usage Data:'),
            _buildListItem(context, 'We may collect information about your device (e.g., device model, operating system, unique device identifiers) and how you interact with the App, such as features used, time spent on the App, and crash reports. This helps us improve App functionality and user experience.'),
            _buildListItem(context, '**Network Status:** Information about your internet connectivity (Wi-Fi, mobile data) is collected to ensure optimal app performance and delivery of real-time updates.'),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '3. How We Use Your Information'),
            _buildParagraph(
              context,
              'We use the collected information for various purposes, including:',
            ),
            _buildListItem(context, 'To provide and maintain the transport services.'),
            _buildListItem(context, 'To manage your driver shifts, assignments, and routes.'),
            _buildListItem(context, 'To verify student reservations through QR code scanning.'),
            _buildListItem(context, 'For safety and security, including real-time vehicle tracking and emergency response.'),
            _buildListItem(context, 'To improve and personalize the App experience.'),
            _buildListItem(context, 'To communicate with you regarding your shifts, app updates, or urgent matters.'),
            _buildListItem(context, 'For internal administration, troubleshooting, and data analysis.'),
            _buildListItem(context, 'To comply with legal obligations and internal policies of DIU.'),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '4. How We Share Your Information'),
            _buildParagraph(
              context,
              'Your information may be shared in the following circumstances:',
            ),
            _buildListItem(context, '**Within DIU:** With relevant administrative departments of Daffodil International University for operational, management, and safety purposes.'),
            _buildListItem(context, '**With Emergency Services:** In case of an emergency, your location and relevant profile information may be shared with emergency response teams.'),
            _buildListItem(context, '**Third-Party Service Providers:** We may employ third-party companies and individuals to facilitate our App services (e.g., cloud hosting, analytics, mapping services). These third parties have access to your information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.'),
            _buildListItem(context, '**Legal Requirements:** We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or government agency).'),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '5. Data Security'),
            _buildParagraph(
              context,
              'We are committed to protecting the security of your information. We implement a variety of security measures to maintain the safety of your personal data when you enter, submit, or access your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '6. Data Retention'),
            _buildParagraph(
              context,
              'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law (e.g., for regulatory purposes). When your information is no longer needed, we will securely delete or anonymize it.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '7. Your Rights'),
            _buildParagraph(
              context,
              'As a driver for DIU, you have certain rights regarding your personal information, subject to applicable laws and DIU policies, including the right to access, update, correct, or request deletion of your information. Please contact the DIU Transport Office for requests regarding your data.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '8. Changes to This Privacy Policy'),
            _buildParagraph(
              context,
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, '9. Contact Us'),
            _buildParagraph(
              context,
              'If you have any questions about this Privacy Policy, please contact us:',
            ),
            _buildListItem(context, '**By email:** transport.office@diu.edu.bd'),
            _buildListItem(context, '**By visiting our website:** www.diu.ac/transport'),
            _buildListItem(context, '**By mail:** Daffodil International University Transport Office, Dhaka, Bangladesh'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper method to build sub-section titles
  Widget _buildSubSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper method to build paragraphs
  Widget _buildParagraph(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.85),
        height: 1.5, // Improve readability
      ),
      textAlign: TextAlign.justify,
    );
  }

  // Helper method to build list items
  Widget _buildListItem(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.85))),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}