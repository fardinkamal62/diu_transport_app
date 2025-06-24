import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleReporting extends StatefulWidget {
  const VehicleReporting({super.key});

  @override
  State<VehicleReporting> createState() => _VehicleReportingState();
}

class _VehicleReportingState extends State<VehicleReporting> {
  String damage = 'none';
  int refueling = 0;
  String servicing = 'none';
  bool isSubmitting = false;
  String? vehicleId;
  String? driverId;
  bool reportSubmittedForToday = false; // Added flag to track report submission

  List<String> damageOptions = ['major', 'minor', 'scratch', 'none'];
  List<int> refuelingOptions = [0, 1, 2, 3];
  List<String> servicingOptions = ['interior service', 'tire pump', 'cleaning', 'none'];

  Future<void> _submitReport() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      final data = json.decode(userData!);

      vehicleId = prefs.getString('vehicleId');
      driverId = data['driverDetails']['_id'];

      final response = await http.post(
        Uri.parse('$socketUrl/api/v1/driver/report'),
        headers: {
          'Authorization': '${data['token']}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'damage': damage,
          'refueling': refueling,
          'servicing': servicing,
          'vehicleId': vehicleId,
          'driverId': driverId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully!'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit report.'), backgroundColor: Colors.red),
          );
        }
      } else {
        final responseData = json.decode(response.body);
        if (kDebugMode) {
          print('Error: ${response.statusCode} - ${response.body}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${responseData['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> _checkReportSubmission() async {
    try {
      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      final data = json.decode(userData!);

      vehicleId = prefs.getString('vehicleId');
      driverId = data['driverDetails']['_id'];

      final response = await http.get(
        Uri.parse('$socketUrl/api/v1/driver/report?driverId=$driverId&vehicleId=$vehicleId&time=${DateTime.now().toIso8601String()}'),
        headers: {
          'Authorization': '${data['token']}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] is List && responseData['data'].isNotEmpty) {
          setState(() {
            reportSubmittedForToday = true;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking report submission: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkReportSubmission(); // Check report submission on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reportSubmittedForToday)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      const Text(
                        'Report has already been submitted for today.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              else ...[
                const Text('Damage:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: damageOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option[0].toUpperCase() + option.substring(1)),
                      value: option,
                      groupValue: damage,
                      onChanged: (value) {
                        setState(() {
                          damage = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Refueling:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: refuelingOptions.map((option) {
                    return RadioListTile<int>(
                      title: Text(option.toString()),
                      value: option,
                      groupValue: refueling,
                      onChanged: (value) {
                        setState(() {
                          refueling = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Servicing:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  children: servicingOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option[0].toUpperCase() + option.substring(1)),
                      value: option,
                      groupValue: servicing,
                      onChanged: (value) {
                        setState(() {
                          servicing = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submitReport,
                  child: isSubmitting ? const CircularProgressIndicator() : const Text('Submit Report'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}