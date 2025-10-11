import 'package:flutter/material.dart';

import '../screens/driver_home_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {

    final List<Widget> screens = [
      DriverHomeScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial Screen'),
      ),
      body: screens[0],
    );
  }
}
