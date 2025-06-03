import 'package:flutter/material.dart';
import '../const/vehicle_list.dart';
import '../widgets/vehicle_details_widget.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text("Vehicle of List"),
      ),

      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: vehicleList.length,
        itemBuilder: (context, index) {
          final vehicle = vehicleList[index];
          return VehicleDetailsWidget(
            vehicleName: vehicle['name'],
            vehicleNumber: vehicle['number'],
            vehicleCapacity: vehicle['capacity'],
            vehicleImage: vehicle['image'],
          );
        },
      ),
    );
  }
}

