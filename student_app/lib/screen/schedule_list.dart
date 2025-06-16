import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  bool isLoading = false;
  Map<String, List<dynamic>> hourlySchedules = {};
  String selectedHour = ''; // Track the selected hour

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      isLoading = true;
    });

    try {
      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      final data = json.decode(userData!);

      final response = await http.get(
        Uri.parse('$socketUrl/api/v1/schedules'),
        headers: {'Authorization': '${data['token']}'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          final data = responseData['data'];
          Map<String, List<dynamic>> groupedSchedules = {};

          for (var schedule in data) {
            final campusReturnTime = DateTime.parse(schedule['campusReturnTime']).toLocal(); // Convert to UTC+6
            final hour = campusReturnTime.hour.toString();
            groupedSchedules.putIfAbsent(hour, () => []).add(schedule);
          }

          setState(() {
            hourlySchedules = groupedSchedules;
          });
        }
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode} - ${response.body}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch schedules.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatHour(String hour) {
    final intHour = int.parse(hour);
    final dateTime = DateTime(0, 1, 1, intHour); // Create a DateTime object for formatting
    return DateFormat('hh a').format(dateTime); // Format hour in AM-PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 14, // Only 14 hours (8 AM to 9 PM)
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: List.generate(
                      14,
                      (index) => Tab(
                        text: _formatHour((index + 8).toString()), // Start from 8 AM
                      ),
                    ),
                    onTap: (index) {
                      setState(() {
                        selectedHour = (index + 8).toString(); // Adjust for 8 AM start
                      });
                    },
                  ),
                  Expanded(
                    child: selectedHour.isEmpty
                        ? const Center(child: Text('Select an hour to view details.'))
                        : Builder(
                            builder: (context) {
                              final schedules = hourlySchedules[selectedHour] ?? [];
                              if (schedules.isEmpty) {
                                return const Center(child: Text('No schedules available.'));
                              }
                              final schedule = schedules.first; // Safely access the first schedule
                              final campusReturnTime = DateTime.parse(schedule['campusReturnTime']).toLocal(); // Convert to local time
                              final dispatches = schedule['dispatches'];

                              if (dispatches.isEmpty) {
                                return const Center(child: Text('No dispatch details available.'));
                              }

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Campus Return Time: ${DateFormat('hh:mm a').format(campusReturnTime)}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Dispatch Details:',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: dispatches.length,
                                        itemBuilder: (context, index) {
                                          final dispatch = dispatches[index];
                                          final vehicle = dispatch['vehicle'];
                                          final pickupTime = DateTime.parse(dispatch['pickupTime']).toLocal(); // Convert to local time
                                          final dispatchTime = DateTime.parse(dispatch['dispatchTime']).toLocal(); // Convert to local time
                                          final returnTime = DateTime.parse(dispatch['returnTime']).toLocal(); // Convert to local time

                                          return Card(
                                            margin: const EdgeInsets.symmetric(vertical: 8),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Vehicle: ${vehicle['name']}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Text('Type: ${vehicle['type'][0].toUpperCase()}${vehicle['type'].substring(1)}'),
                                                  Text('Registration: ${vehicle['vehicleRegistrationNumber']}'),
                                                  const SizedBox(height: 8),
                                                  Text('Pickup Time: ${DateFormat('hh:mm a').format(pickupTime)}'),
                                                  Text('Campus Leave Time: ${DateFormat('hh:mm a').format(dispatchTime)}'),
                                                  Text('Return Time: ${DateFormat('hh:mm a').format(returnTime)}'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}