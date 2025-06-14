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

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserData();
    await _fetchAllocationVehicle();
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

  IconData _getVehicleIcon(String? type) {
    switch (type) {
      case 'bus':
        return Icons.directions_bus;
      case 'car':
        return Icons.directions_car;
      case 'van':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car;
    }
  }

  var socket = socketio(); // Initialize your socket connection

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
                  ? Container(
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
                          Icon(
                            _getVehicleIcon(allocationVehicle!['vehicleType']),
                            size: 40,
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
                    )
                  : Center(
                      child: Text(
                        'No vehicle allocated.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: allocationVehicle == null ? null : widget.onShiftToggle,
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