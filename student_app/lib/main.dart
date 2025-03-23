import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:diu_transport_student_app/barikoi_map.dart';
import 'package:diu_transport_student_app/socketio.dart' as socketio;

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
  HttpOverrides.global = MyHttpOverrides();

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    if (kDebugMode) {
      print('Error loading .env file: $e');
    }
  }
  var socket = socketio.socketio();

  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  final dynamic socket;

  const MyApp({super.key, required this.socket});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIU Transport Student App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SymbolMap(socket: socket),
    );
  }
}
