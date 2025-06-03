import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VehicleDetailsWidget(
                vehicleName: "Bus",
                vehicleNumber: "DIU-1234",
                vehicleCapacity: "50",
                vehicleImage: "assets/img/bus.png",
              ),
              VehicleDetailsWidget(
                vehicleName: "Car",
                vehicleNumber: "DIU-5678",
                vehicleCapacity: "5",
                vehicleImage: "assets/img/car.png",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

