import 'dart:convert';
import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:diu_transport_student_app/widgets/loader.dart'; // Import the Loader widget
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedLocation;
  String? selectedTime;
  bool isLoading = false; // Add loading state

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
      setState(() {
        isLoading = true; // Show loading overlay
      });

      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');

      if (userData != null) {
        final data = json.decode(userData);

        final response = await http.post(
          Uri.parse('$socketUrl/api/v1/user/reservation'),
          headers: {'Content-Type': 'application/json','Authorization': '${data['token']}'},
          body: jsonEncode({
            'location': location,
            'time': '${DateFormat("yyyy-MM-dd").format(DateTime.now())}T$time:00',
            'registrationCode': data['user']['reg_code'],
            'userType': 'student',
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservation confirmed successfully!'), backgroundColor: diuPrimaryGreen,),
          );
        } else {
          final errorMsg = jsonDecode(response.body)['error'] ?? 'Failed to confirm reservation.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          if (kDebugMode) {
            print('Error: ${response.body}');
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading overlay
      });
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
          'Location: $locationLabel\nTime: $timeLabel${locationLabel == 'Campus' ? '\n\nBus will leave campus at ${timeLabel}\nMicrobus will leave campus at ${timeLabel
              .substring(0, 3)}20.' : '\n\nBus will be available by ${int.parse(timeLabel.substring(0, 2)) - 1}:20\nMicrobus will be available by ${int.parse(timeLabel
              .substring(0, 2)) - 1}:40.'}',
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

    // Get the current time
    final now = DateTime.now();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Reservation")),
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
                                      : _getButtonColor(timingList[j]['value']!, now),
                                  borderRadius: BorderRadius.circular(42.0),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    final parsedTime = DateFormat("HH:mm").parse(timingList[j]['value']!);
                                    final fullDateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      parsedTime.hour,
                                      parsedTime.minute,
                                    );

                                    // Disable button if time is in the past or within 2 hours
                                    if (fullDateTime.isAfter(now.add(const Duration(hours: 2)))) {
                                      await _showConfirmationDialog(
                                        timingList[j]['label']!,
                                        timingList[j]['value']!,
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                        final parsedTime = DateFormat("HH:mm").parse(timingList[j]['value']!);
                                        final fullDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          parsedTime.hour,
                                          parsedTime.minute,
                                        );

                                        // Disable button if time is in the past or within 2 hours
                                        if (fullDateTime.isBefore(now.add(const Duration(hours: 2)))) {
                                          return Colors.grey.shade600; // Disabled text color
                                        }
                                        return diuSurfaceColor; // Enabled text color
                                      },
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      timingList[j]['label']!,
                                      style: TextStyle(
                                        color: selectedTime == timingList[j]['value']
                                            ? Colors.white
                                            : diuSurfaceColor,
                                      ),
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
        ),
        if (isLoading) const Loader(), // Use the reusable Loader widget
      ],
    );
  }

  Color _getButtonColor(String timeValue, DateTime now) {
    final parsedTime = DateFormat("HH:mm").parse(timeValue);
    final fullDateTime = DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

    // Return disabled color if time is in the past or within 2 hours
    if (fullDateTime.isBefore(now.add(const Duration(hours: 2)))) {
      return Colors.grey.shade300; // Disabled button color
    }
    return diuLightGreen; // Enabled button color
  }
}