import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationDetails extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetails({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationDate = DateTime.parse(reservation['time']);
    final formattedTime = DateFormat('MMMM dd, yyyy HH:mm').format(reservationDate);
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
              const Text(
                "Vehicle Details:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Name: ${vehicle['name']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                "Registration Number: ${vehicle['registrationNumber']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                "Type: ${vehicle['type'][0].toUpperCase()}${vehicle['type'].substring(1)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
