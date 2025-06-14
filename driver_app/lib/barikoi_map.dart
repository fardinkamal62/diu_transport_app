import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class SymbolMap extends StatefulWidget {
  final dynamic socket;
  final Map<String, dynamic>? vehicle;

  const SymbolMap({super.key, required this.socket, this.vehicle});

  @override
  State<StatefulWidget> createState() => _SymbolMapState();
}

class _SymbolMapState extends State<SymbolMap> {
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(23.7942, 90.4470),
    zoom: 16,
  );
  MapLibreMapController? mController;
  Timer? _locationTimer;

  static const styleId = 'osm-liberty';
  static final apiKey = dotenv.env['API_KEY'] ?? '';
  static final mapUrl =
      'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';
  static const iconUrl = 'https://img.icons8.com/ios/50/bus.png';

  final List<LatLng> coordinates = [];
  final Map<String, LatLng> vehicleLocations = {};
  List<Symbol> symbols = [];

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  @override
  void initState() {
    super.initState();
    if (apiKey.isEmpty) {
      if (kDebugMode) {
        print('Error: API_KEY is not set in the .env file');
      }
      return;
    }
    // Error handling for socket connection
    widget.socket.on('connect_error', (error) {
      if (kDebugMode) {
        print('Socket connection error: $error');
      }
    });
    widget.socket.on('location', (data) {
      try {
        String vehicleId = data['vehicleId'].toString();
        double latitude = double.parse(data['latitude'].toString());
        double longitude = double.parse(data['longitude'].toString());
        String vehicleName = data['vehicleName'].toString();
        setState(() {
          LatLng newCoordinate = LatLng(latitude, longitude);
          vehicleLocations[vehicleId] = newCoordinate;
          _updateMarkers(vehicleName);
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing location data: $e');
        }
      }
    });

    Future<Position> getCurrentPosition () async {
      return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    }

    // Emit data every 5 seconds
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {

      Position currentPosition = await getCurrentPosition();

      if (widget.vehicle?['vehicleId']!.isNotEmpty && mController != null) {
        widget.socket.emit('location', {
          'vehicleId': widget.vehicle?['vehicleId'],
          'latitude': currentPosition.latitude.toString(),
          'longitude': currentPosition.longitude.toString(),
          'vehicleName': widget.vehicle?['vehicleName'],
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up socket listeners
    widget.socket.off('location');
    widget.socket.off('connect_error');
    // Cancel location timer
    _locationTimer?.cancel();
    // Clean up map controller
    mController?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  void _updateMarkers(String vehicleName) {
    if (mController != null) {
      mController!.clearSymbols();
      symbols.clear();
      vehicleLocations.forEach((vehicleId, coordinate) {
        SymbolOptions symbolOptions = SymbolOptions(
          geometry: coordinate,
          iconImage: 'custom-marker',
          iconSize: 1.5,
          iconAnchor: 'bottom',
          iconHaloColor: '#ffffff',
          textField: vehicleName,
          textSize: 12.5,
          textOffset: Offset(0, 1.2),
          textAnchor: 'bottom',
          textColor: '#000000',
          textHaloBlur: 1,
          textHaloColor: '#ffffff',
          textHaloWidth: 0.8,
        );
        mController!.addSymbol(symbolOptions).then((symbol) {
          symbols.add(symbol);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapLibreMap(
              initialCameraPosition: initialPosition,
              styleString: mapUrl,
              onMapCreated: (MapLibreMapController mapController) {
                mController = mapController;

                mController?.onSymbolTapped.add(_onSymbolTapped);
              },
              onStyleLoadedCallback: () {
                addImageFromUrl("custom-marker", Uri.parse(iconUrl)).then((value) {
                  _updateMarkers('');
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _onSymbolTapped(Symbol symbol) {
    //update symbol text when tapped
    mController?.updateSymbol(symbol, SymbolOptions(textField: "clicked"));
  }

  // Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        return mController!.addImage(name, response.bodyBytes);
      } else {
        if (kDebugMode) {
          print('Failed to load image: HTTP ${response.statusCode}');
        }
        // Use a fallback image or show an error
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading image: $e');
      }
      // Use a fallback image or show an error
    }
  }
}