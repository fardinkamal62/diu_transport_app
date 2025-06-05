import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
        titleTextStyle: TextStyle(color: diuSurfaceColor),
      ),
      // //Text(
      //       'Settings',
      //       style: theme.textTheme.headlineMedium!.copyWith(
      //         color: theme.colorScheme.onSurface,
      //       // ),
      body: Container(
        width: 300.0,
        height: 200.0,
        decoration: BoxDecoration(color: diuLightGreen),
      ),
    );
  }
}
