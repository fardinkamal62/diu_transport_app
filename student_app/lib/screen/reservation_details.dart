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
    final reservationDate = DateTime.parse(reservation['time']).toLocal(); // Convert to local time

    // Make dispatchTime and pickupTime optional
    DateTime? dispatchTime;
    DateTime? pickupTime;
    try {
      if (reservation['schedule']?['dispatchTime'] != null) {
        dispatchTime = DateTime.parse(reservation['schedule']['dispatchTime']).toLocal(); // Convert to local time
      }
    } catch (_) {}
    try {
      if (reservation['schedule']?['pickupTime'] != null) {
        pickupTime = DateTime.parse(reservation['schedule']['pickupTime']).toLocal(); // Convert to local time
      }
    } catch (_) {}

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
            if (reservation['location'] == 'campus')
              Text(
                "Time: ${DateFormat('MMMM dd, yyyy hh:00 a').format(reservationDate)}",
                style: const TextStyle(fontSize: 16),
              )
            else
              Text(
                "Time: ${DateFormat('MMMM dd, yyyy hh:00 a').format(reservationDate.subtract(Duration(hours: 1)))}",
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
            if (dispatchTime != null)
              if (reservation['location'] == 'campus')
                Text(
                  "Leave Campus by: ${DateFormat('hh:mm a').format(dispatchTime)}",
                  style: const TextStyle(fontSize: 16),
                ),
            if (pickupTime != null)
              if (reservation['location'] == 'notunbazar')
                Text(
                  "Reach Notunbazar by: ${DateFormat('hh:mm a').format(pickupTime)}",
                  style: const TextStyle(fontSize: 16),
                ),
            if (reservation['status'] == 'scheduled')
              if (reservation['location'] == 'campus')
                Text(
                  "Vehicle schedule will be available by: ${DateFormat('hh:00 a').format(reservationDate)}",
                )
              else
              Text(
                "Vehicle schedule will be available by: ${DateFormat('hh:00 a').format(reservationDate.subtract(const Duration(hours: 1)))}",
              ),
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
