import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:diu_transport_driver_app/barikoi_map.dart';
import 'package:diu_transport_driver_app/socketio.dart';

class HomeScreenContent extends StatefulWidget {
  final VoidCallback onShiftToggle;
  final bool shiftStarted;

  const HomeScreenContent({
    super.key,
    required this.onShiftToggle,
    required this.shiftStarted,
  });

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String? phoneNumber;
  String? name;
  String? driverId;
  Map<String, dynamic>? allocationVehicle;
  bool loadingVehicle = true;
  Map<String, dynamic>? scheduleDispatchInfo;
  DateTime? campusReturnTime;
  bool shiftApiLoading = false;
  String? scheduleId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserData();
    await _fetchAllocationVehicle();
    await _fetchHourlySchedule();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final data = json.decode(userData);
      setState(() {
        phoneNumber = data['driverDetails']['phoneNumber'];
        name = data['driverDetails']['name'];
        driverId = data['driverDetails']['_id'];
      });
    }
  }

  Future<void> _fetchAllocationVehicle() async {
    setState(() {
      loadingVehicle = true;
    });
    try {
      final SERVER_URL = dotenv.env['SERVER_URL'];
      final response = await http.get(Uri.parse('$SERVER_URL/api/v1/driver/allocation?driverId=$driverId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data']?['allocation'] != null) {
          setState(() {
            allocationVehicle = data['data']['allocation'];
            loadingVehicle = false;
          });
        } else {
          setState(() {
            allocationVehicle = null;
            loadingVehicle = false;
          });
        }
      } else {
        setState(() {
          allocationVehicle = null;
          loadingVehicle = false;
        });
      }
    } catch (e) {
      setState(() {
        allocationVehicle = null;
        loadingVehicle = false;
      });
    }
  }

  Future<void> _fetchHourlySchedule() async {
    // Only fetch if allocationVehicle is available
    if (driverId == null || allocationVehicle == null) return;
    try {
      final SERVER_URL = dotenv.env['SERVER_URL'];
      final now = DateTime.now();
      final response = await http.get(Uri.parse('$SERVER_URL/api/v1/schedules?driverId=$driverId&dispatchTime=2025-06-13T04:00:00.782Z'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null && data['data'].isNotEmpty) {
          // Find dispatch for this vehicle
          final schedule = data['data'][0];
          scheduleId = schedule['_id'];
          print('VehicleId: ${allocationVehicle!['vehicleId']}');
          final dispatch = (schedule['dispatches'] as List).firstWhere(
            (d) => d['vehicleId'] == allocationVehicle!['vehicleId'],
            orElse: () => null,
          );
          setState(() {
            scheduleDispatchInfo = dispatch;
            campusReturnTime = DateTime.tryParse(schedule['campusReturnTime'] ?? '');
          });
        } else {
          setState(() {
            scheduleDispatchInfo = null;
            campusReturnTime = null;
          });
        }
      } else {
        setState(() {
          scheduleDispatchInfo = null;
          campusReturnTime = null;
        });
      }
    } catch (e) {
      setState(() {
        scheduleDispatchInfo = null;
        campusReturnTime = null;
      });
    }
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null) return '-';
    final dt = DateTime.tryParse(isoString)?.toLocal();
    if (dt == null) return '-';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  var socket = socketio(); // Initialize your socket connection

  Future<void> _handleShiftToggle() async {
    if (allocationVehicle == null || scheduleDispatchInfo == null) {
      widget.onShiftToggle();
      return;
    }
    setState(() {
      shiftApiLoading = true;
    });
    try {
      final SERVER_URL = dotenv.env['SERVER_URL'];
      await http.post(
        Uri.parse('$SERVER_URL/api/v1/driver/journey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'vehicleId': allocationVehicle!['vehicleId'],
          'scheduleId': scheduleId,
        }),
      );
    } catch (e) {
      // Optionally handle error
    } finally {
      setState(() {
        shiftApiLoading = false;
      });
      widget.onShiftToggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name != null ? 'Welcome, $name!' : 'Welcome, Driver!',
            style: theme.textTheme.headlineLarge!.copyWith(color: theme.colorScheme.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          loadingVehicle
              ? Center(child: CircularProgressIndicator())
              : allocationVehicle != null
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.colorScheme.outline),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.shadow.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/${allocationVehicle!['vehicleType']}.png',
                                width: 40,
                                height: 40,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allocationVehicle!['vehicleName'] ?? '',
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      allocationVehicle!['vehicleRegistrationNumber'] ?? '',
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // New: Dispatch info card
                        if (scheduleDispatchInfo != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.outline),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dispatch Details',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.schedule, size: 20, color: theme.colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Dispatch Time: ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _formatDateTime(scheduleDispatchInfo!['dispatchTime']),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.keyboard_return, size: 20, color: theme.colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Return Time: ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      campusReturnTime != null
                                          ? _formatDateTime(campusReturnTime!.toIso8601String())
                                          : '-',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'No vehicle allocated.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
          const SizedBox(height: 16),
          shiftApiLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: allocationVehicle == null ? null : _handleShiftToggle,
                  icon: Icon(widget.shiftStarted ? Icons.stop : Icons.play_arrow),
                  label: Text(widget.shiftStarted ? 'End Shift' : 'Start Shift'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.shiftStarted ? Colors.red : null,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
          const SizedBox(height: 16),
          // Show the map widget below the shift button
          Expanded(
            child: SymbolMap(socket: socket),
          ),
        ],
      ),
    );
  }
}