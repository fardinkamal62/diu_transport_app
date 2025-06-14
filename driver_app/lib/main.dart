import 'dart:io';
import 'package:diu_transport_driver_app/screens/auth/driver_login_screen.dart';
import 'package:diu_transport_driver_app/screens/driver_home_screen.dart';
import 'package:diu_transport_driver_app/screens/settings/about_app_screen.dart';
import 'package:diu_transport_driver_app/screens/settings/privacy_policy_screen.dart';
import 'package:diu_transport_driver_app/theme/driver_transit_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:diu_transport_driver_app/barikoi_map.dart';
import 'package:diu_transport_driver_app/socketio.dart' as socketio;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  // Only use this in development builds
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    HttpOverrides.global = MyHttpOverrides();
  }

  bool envLoaded = false;
  try {
    await dotenv.load(fileName: "assets/.env");
    envLoaded = true;
  } catch (e) {
    if (kDebugMode) {
      print('Error loading .env file: $e');
    }
  }

  // Validate required environment variables
  if (envLoaded) {
    final requiredEnvVars = ['API_KEY', 'SERVER_URL'];
    final missingEnvVars = requiredEnvVars.where((v) => dotenv.env[v] == null).toList();

    if (missingEnvVars.isNotEmpty) {
      if (kDebugMode) {
        print('Missing required environment variables: ${missingEnvVars.join(', ')}');
      }
      // In production, fail fast if required env vars are missing
      if (const bool.fromEnvironment('dart.vm.product') == true) {
        throw Exception('Missing required environment variables: ${missingEnvVars.join(', ')}');
      }
    }
  }

  var socket = socketio.socketio();

  // Handle socket connection status
  socket.on('connect', (_) {
    if (kDebugMode) {
      print('Socket connected');
    }
  });

  socket.on('connect_error', (error) {
    if (kDebugMode) {
      print('Socket connection error: $error');
    }
  });

  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  final dynamic socket;

  const MyApp({super.key, required this.socket});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIU Transport Driver App',
      theme: driverTransitTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/driver-login', // Start at login screen
      routes: {
        '/driver-login': (context) => const DriverLoginScreen(),
        '/driver-home-screen': (context) => const DriverHomeScreen(),
        '/about-app': (context) => const AboutAppScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(), // Reusing AboutAppScreen for privacy policy
      },
      // home: SymbolMap(socket: socket),
    );
  }
}
