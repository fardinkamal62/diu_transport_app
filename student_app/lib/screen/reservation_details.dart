import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationDetails extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetails({super.key, required this.reservation});

  Future<Map<String, String>?> _getQrData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData != null) {
      final data = Map<String, dynamic>.from(json.decode(userData));
      final registrationCode = data['user']['reg_code'];
      final userType = data['user']['type'] ?? 'student';
      if (registrationCode != null && userType != null) {
        return {
          "registrationCode": registrationCode,
          "userType": userType,
          "reservationId": reservation['_id'].toString(),
        };
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final reservationDate = DateTime.parse(reservation['time']);
    final formattedTime = DateFormat('MMMM dd, yyyy hh:mm a').format(reservationDate.toLocal());
    final vehicle = reservation['vehicle']; // Extract vehicle details

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location: ${reservation['location'][0].toUpperCase()}${reservation['location'].substring(1)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Time: $formattedTime",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${reservation['status'][0].toUpperCase()}${reservation['status'].substring(1)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (vehicle != null && vehicle['name'] != '') ...[
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    // Display vehicle icon based on type
                    if (vehicle['type'] == 'microbus')
                      Image.asset(
                        'assets/icons/minibus.png',
                        width: 100,
                        height: 100,
                      )
                    else if (vehicle['type'] == 'bus')
                      Image.asset(
                        'assets/icons/bus.png',
                        width: 100,
                        height: 100,
                      ),
                    const SizedBox(height: 10),
                    // Display vehicle name and registration number
                    Text(
                      vehicle['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Registration Number: ${vehicle['registrationNumber']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            const SizedBox(height: 10),
            FutureBuilder<Map<String, String>?>(
              future: _getQrData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null) {
                  final qrData = json.encode(snapshot.data);
                  return Center(
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                  );
                } else {
                  if (kDebugMode) {
                    print("Failed to load QR data: ${snapshot.error}");
                  }
                  return const Center(
                    child: Text(
                      "Failed to load QR Code",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
