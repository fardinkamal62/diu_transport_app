import 'dart:io';
import 'package:diu_transport_student_app/screen/auth/forget_pass_screen.dart';
import 'package:diu_transport_student_app/screen/auth/login_screen.dart';
import 'package:diu_transport_student_app/screen/auth/signup_screen.dart';
import 'package:diu_transport_student_app/screen/home_screen.dart';
import 'package:diu_transport_student_app/theme/transit_theme.dart'; // Correct import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// No need for 'package:diu_transport_student_app/const/color_palet.dart'; anymore as all colors are in theme.

import 'package:diu_transport_student_app/barikoi_map.dart'; // Keep if you're using this
import 'package:diu_transport_student_app/socketio.dart' as socketio; // Keep if you're using this

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  if (envLoaded) {
    final requiredEnvVars = ['API_KEY', 'SOCKET_URL'];
    final missingEnvVars = requiredEnvVars.where((v) => dotenv.env[v] == null).toList();

    if (missingEnvVars.isNotEmpty) {
      if (kDebugMode) {
        print('Missing required environment variables: ${missingEnvVars.join(', ')}');
      }
      if (const bool.fromEnvironment('dart.vm.product') == true) {
        throw Exception('Missing required environment variables: ${missingEnvVars.join(', ')}');
      }
    }
  }

  // Ensure socketio.socketio() is correctly defined and available
  // Assuming 'socketio.dart' correctly provides a 'socketio' function/class
  var socket;
  try {
    socket = socketio.socketio();
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
  } catch (e) {
    if (kDebugMode) {
      print('Failed to initialize socket: $e');
    }
    // Optionally handle error or provide a default socket object
  }


  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  final dynamic socket;

  const MyApp({super.key, required this.socket});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIU Transport Student App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(), // Added const
        '/signup': (context) => const SignUpScreen(), // Added const
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home-screen': (context) => const HomeScreen(),
        '/map': (context) => SymbolMap(socket: socket),
      },
      theme: transitTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}