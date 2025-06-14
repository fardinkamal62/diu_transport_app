import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'hometab/driver_profile_screen.dart';
import 'hometab/driver_settings_screen.dart';
import 'hometab/home_screen_content.dart';
import 'hometab/qr_scanner_page.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isConnected = true;
  bool _hasLocationPermission = false;
  bool _locationServiceEnabled = false;
  String? _selectedVehicle;
  final List<String> _availableVehicles = ['Bus 101 (DHA-GAZ)', 'Bus 102 (DHA-SAV)', 'Microbus A01'];
  bool shiftStartStatus = false;

  int _selectedIndex = 0;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final List<Widget> _otherWidgetOptions = <Widget>[
    const QRScannerPage(),
    const DriverProfileScreen(),
    const DriverSettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _toggleShiftStatus() {
    if (_selectedVehicle == null) return;

    setState(() {
      shiftStartStatus = !shiftStartStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          shiftStartStatus
              ? 'Shift started for $_selectedVehicle'
              : 'Shift ended for $_selectedVehicle',
        ),
      ),
    );
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    setState(() {
      _locationServiceEnabled = serviceEnabled;
      _hasLocationPermission = (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always);
    });

    if (!serviceEnabled) {
      _showLocationServiceDialog();
    } else if (permission == LocationPermission.denied) {
      _requestLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      _showLocationDeniedForeverDialog();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    setState(() {
      _hasLocationPermission = (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always);
    });
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text('Please enable location services for the app to function properly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text('Open Settings', style: Theme.of(context).textTheme.labelLarge),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkLocationPermission();
              },
              child: Text('Cancel', style: Theme.of(context).textTheme.labelMedium),
            ),
          ],
        );
      },
    );
  }

  void _showLocationDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text('Location access is permanently denied. Please enable it from app settings to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Open App Settings', style: Theme.of(context).textTheme.labelLarge),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: Theme.of(context).textTheme.labelMedium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkInitialStatus() async {
    await _checkConnectivity();
    await _checkLocationPermission();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> pages = [
      HomeScreenContent(
        selectedVehicle: _selectedVehicle,
        availableVehicles: _availableVehicles,
        onVehicleChanged: (newValue) {
          setState(() {
            _selectedVehicle = newValue;
          });
        },
        onShiftToggle: _toggleShiftStatus,
        shiftStarted: shiftStartStatus,
      ),
      ..._otherWidgetOptions,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('DIU Transport Driver App'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (!_isConnected)
            Container(
              color: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: theme.colorScheme.onError),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No Internet Connection. Some features may not work.',
                      style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onError),
                    ),
                  ),
                ],
              ),
            ),
          if (!_hasLocationPermission || !_locationServiceEnabled)
            Container(
              color: theme.colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.location_off, color: theme.colorScheme.onSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      !_locationServiceEnabled
                          ? 'Location services are disabled. Tap to enable.'
                          : 'Location permission not granted. Tap to allow.',
                      style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSecondary),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!_locationServiceEnabled) {
                        Geolocator.openLocationSettings();
                      } else {
                        _requestLocationPermission();
                      }
                    },
                    child: Text(
                      'FIX',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Reservations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


