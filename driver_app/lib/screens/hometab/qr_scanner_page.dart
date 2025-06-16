import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool _scanned = false;
  MobileScannerController? _scannerController;

  // Add these variables to hold vehicleId and scheduleId
  String? vehicleId;
  String? scheduleId;

  late String token;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal, // Normal detection speed
      facing: CameraFacing.back,
      autoStart: true,
    );
    _loadVehicleAndScheduleData(); // Load vehicleId and scheduleId
  }

  Future<void> _loadVehicleAndScheduleData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vehicleId = prefs.getString('vehicleId'); // Retrieve vehicleId from SharedPreferences
      scheduleId = prefs.getString('scheduleId'); // Retrieve scheduleId from SharedPreferences
    });
  }

  Future<String> _determineLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      const notunBazar = {'latitude': 23.7981, 'longitude': 90.4265};
      const sayeedNagar = {'latitude': 23.7987, 'longitude': 90.4350};
      const campus = {'latitude': 23.7941, 'longitude': 90.4471};

      double distanceToNotunBazar = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        notunBazar['latitude']!,
        notunBazar['longitude']!,
      );

      double distanceToSayeedNagar = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        sayeedNagar['latitude']!,
        sayeedNagar['longitude']!,
      );

      double distanceToCampus = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        campus['latitude']!,
        campus['longitude']!,
      );

      if (distanceToNotunBazar < 100) {
        return "notunbazar";
      } else if (distanceToSayeedNagar < 100) {
        return "sayeednagar";
      } else {
        return "campus";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error determining location: $e");
      }
      return "campus";
    }
  }

  Future<void> _makeReservationApiCall(String registrationCode, String? reservationId, String userType) async {
    if (vehicleId == null || scheduleId == null) {
      _showToast("Vehicle or schedule data is missing.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final data = json.decode(userData);
      setState(() {
        token = data['token'];
      });
    }

    final location = await _determineLocation(); // Dynamically determine location
    final serverUrl = dotenv.env['SERVER_URL'];

    final url = Uri.parse('$serverUrl/api/v1/manual-reservation');
    final body = {
      'vehicleId': vehicleId,
      'scheduleId': scheduleId,
      'registrationCode': registrationCode,
      'location': location,
      'userType': userType,
      'reservationId': reservationId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        _showToast("Reservation successful!");
      } else {
        _showToast("Failed to make reservation");

        if (kDebugMode) {
          print("Failed to make reservation. Error: ${response.body}");
        }
      }
    } catch (e) {
      _showToast("Error: $e");
    }
  }

  /// Displays a brief message SnackBar at the bottom of the screen.
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      setState(() => _scanned = true);
      final String? rawValue = barcodes.first.rawValue;

      if (rawValue != null) {
        try {
          final data = json.decode(rawValue);
          final registrationCode = data['registrationCode'];
          final reservationId = data['reservationId'];
          final userType = data['userType'];

          if (registrationCode != null && userType != null) {
            _makeReservationApiCall(registrationCode, reservationId, userType);
          } else {
            _showToast("Invalid QR code data.");
          }
        } catch (e) {
          _showToast("Error parsing QR code: $e");
        }
      } else {
        _showToast("No value found in QR code.");
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() => _scanned = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            controller: _scannerController,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white, size: 60),
                    SizedBox(height: 10),
                    Text(
                      'Position QR Code in the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).size.width * 0.7) / 2.4,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).size.width * 0.7) / 2.4,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.7) / 2,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.7) / 2,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
