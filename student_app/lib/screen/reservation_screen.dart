import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservation")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: 350.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: diuPrimaryGreen,
              borderRadius: BorderRadius.circular(15.0),
            ),

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Select the time you want to board the bus!",
                style: TextStyle(color: diuOnPrimaryColor),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 07:30 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "07:30 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 8:00 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "08:00 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("booking For 09:00 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "09:00 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 10:00 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "10:00 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 11:00 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "11:00 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("booking For 12:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "12:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 01:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "01:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 02:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "02:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("booking For 03:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "03:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 04:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "04:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 05:00 AM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "05:00 AM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("booking For 06:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "06:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 07:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "07:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("Booking For 8:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus??",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "08:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diuLightGreen,
                      borderRadius: BorderRadius.circular(42.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text("booking For 09:00 PM"),
                              content: Text(
                                "Would you like to select this time to board the bus?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the popup
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "09:00 PM",
                          style: TextStyle(color: diuSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
