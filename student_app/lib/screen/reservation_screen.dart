import 'dart:convert';
import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedLocation;
  String? selectedTime;

  final List<Map<String, String>> locations = [
    {'label': 'Campus', 'value': 'campus'},
    {'label': 'Notunbazar', 'value': 'notunbazar'},
    {'label': 'Sayeed Nagar', 'value': 'sayeednagar'},
  ];

  // Time when bus will reach campus
  final List<Map<String, String>> campusReachTiming = [
    {'label': '08:30 AM', 'value': '8:30'},
    {'label': '09:00 AM', 'value': '9:00'},
    {'label': '10:00 AM', 'value': '10:00'},
    {'label': '11:00 AM', 'value': '11:00'},
    {'label': '12:00 PM', 'value': '12:00'},
    {'label': '01:00 PM', 'value': '13:00'},
    {'label': '02:00 PM', 'value': '14:00'},
    {'label': '03:00 PM', 'value': '15:00'},
    {'label': '04:00 PM', 'value': '16:00'},
    {'label': '05:00 PM', 'value': '17:00'},
    {'label': '06:00 PM', 'value': '18:00'},
    {'label': '07:00 PM', 'value': '19:00'},
    {'label': '08:00 PM', 'value': '20:00'},
    {'label': '09:00 PM', 'value': '21:00'},
  ];

  // Time when bus will leave campus
  final List<Map<String, String>> campusLeaveTime = [
    {'label': '07:40 AM', 'value': '7:40'},
    {'label': '08:40 AM', 'value': '8:40'},
    {'label': '09:40 AM', 'value': '9:40'},
    {'label': '10:40 AM', 'value': '10:40'},
    {'label': '11:40 AM', 'value': '11:40'},
    {'label': '12:40 PM', 'value': '12:40'},
    {'label': '01:40 PM', 'value': '13:40'},
    {'label': '02:40 PM', 'value': '14:40'},
    {'label': '03:40 PM', 'value': '15:40'},
    {'label': '04:40 PM', 'value': '16:40'},
    {'label': '05:40 PM', 'value': '17:40'},
    {'label': '06:40 PM', 'value': '18:40'},
    {'label': '07:40 PM', 'value': '19:40'},
  ];

  Future<void> _makeReservation(String location, String time) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/reservation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'location': location, 'time': time}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reservation confirmed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm reservation.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showConfirmationDialog(String timeLabel, String timeValue) async {
    final locationLabel = locations.firstWhere(
      (loc) => loc['value'] == selectedLocation,
      orElse: () => {'label': ''},
    )['label'];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reservation?'),
        content: Text(
          'Location: $locationLabel\nTime: $timeLabel',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        selectedTime = timeValue;
      });
      await _makeReservation(selectedLocation!, timeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which timing array to use
    List<Map<String, String>> timingList = [];
    if (selectedLocation != null) {
      if (selectedLocation == 'campus') {
        timingList = campusLeaveTime;
      } else {
        timingList = campusReachTiming;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Reservation")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Location selection
          Container(
            margin: EdgeInsets.all(20),
            width: 350.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: diuPrimaryGreen,
              borderRadius: BorderRadius.circular(15.0),
            ),

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "From where do you want to board?",
                style: TextStyle(color: diuOnPrimaryColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: locations.map((loc) {
                  final isSelected = selectedLocation == loc['value'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 120.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? diuPrimaryGreen // Darker shade when selected
                            : diuLightGreen,
                        borderRadius: BorderRadius.circular(42.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedLocation = loc['value'];
                            selectedTime = null; // Reset time selection
                          });
                        },
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            loc['label']!,
                            style: TextStyle(color: diuSurfaceColor),
                          ),
                        ),
                        icon: const SizedBox.shrink(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          if (selectedLocation != null) ...{
            // Time selection
            Container(
              margin: EdgeInsets.all(20),
              width: 350.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: diuPrimaryGreen,
                borderRadius: BorderRadius.circular(15.0),
              ),

              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  selectedLocation == 'campus'
                      ? "Select the time you want to leave campus"
                      : "Select the time you want to reach campus",
                  style: TextStyle(color: diuOnPrimaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Dynamically generate time buttons in rows of 3
            Column(
              children: [
                for (int i = 0; i < timingList.length; i += 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int j = i; j < i + 3 && j < timingList.length; j++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                          child: Container(
                            width: 120.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: selectedTime == timingList[j]['value']
                                  ? diuPrimaryGreen
                                  : diuLightGreen,
                              borderRadius: BorderRadius.circular(42.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await _showConfirmationDialog(
                                  timingList[j]['label']!,
                                  timingList[j]['value']!,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  timingList[j]['label']!,
                                  style: TextStyle(color: diuSurfaceColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          },
        ],
      ),
    );
  }
}