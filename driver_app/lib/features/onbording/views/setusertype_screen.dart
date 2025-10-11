import 'package:diu_transport_driver_app/features/auth/views/driver_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetusertypeScreen extends StatefulWidget {
  const SetusertypeScreen({super.key});

  @override
  State<SetusertypeScreen> createState() => _SetusertypeScreenState();
}

class _SetusertypeScreenState extends State<SetusertypeScreen> {
  String lang = 'English';
  int selectedBtn = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.blueAccent, size: 30),
            const SizedBox(width: 8),
            Text(
              'app_title'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String newValue) {
              setState(() {
                lang = newValue;
              });
              if (newValue == 'English') {
                Get.updateLocale(const Locale('en', 'US'));
              } else {
                Get.updateLocale(const Locale('bn', 'BD'));
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              PopupMenuItem<String>(
                value: 'Bangla',
                child: Text('Bangla'),
              ),
            ],
            child: Row(
              children: [
                const Icon(Icons.language, color: Colors.black87, size: 18),
                const SizedBox(width: 6),
                Text(
                  lang,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.black87),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),

      // ------------------ BODY -------------------
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'tagline'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'subtitle'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Driver Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedBtn = 0;
                  });
                },
                icon: const Icon(Icons.directions_car_rounded),
                label: Text(
                  'driver'.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  selectedBtn == 0 ? Colors.blueAccent : Colors.white,
                  foregroundColor:
                  selectedBtn == 0 ? Colors.white : Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Commuter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedBtn = 1;
                  });
                },
                icon: const Icon(Icons.verified_user_rounded),
                label: Text(
                  'commuter'.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  selectedBtn == 1 ? Colors.blueAccent : Colors.white,
                  foregroundColor:
                  selectedBtn == 1 ? Colors.white : Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Get.to(DriverLoginScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Icon(Icons.arrow_forward_rounded, size: 40),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text.rich(
                TextSpan(
                  text: 'terms'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'terms_of_service'.tr,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'privacy_policy'.tr,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
