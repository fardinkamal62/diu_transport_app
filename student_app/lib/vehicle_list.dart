import 'package:flutter/material.dart';

import 'Constant/color.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text("Vehicle of List", style: GoogleFonts.montserrat()),
      ),
      backgroundColor: CustomColor.BgColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "কর্ণফুলী",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Vehicle image
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "মেঘনা",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "সুরমা",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "পদ্মা",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "তিস্তা",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ব্রহ্মপুত্র ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/bus.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 01",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 02",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 03",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 04",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 05",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width:
                        MediaQuery.of(context).size.width -
                        20, // Responsive width
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: CustomColor.ContainerBg,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha((0.8 * 255).toInt()),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flexible Text Section
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hiace No 07",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: CustomColor.TextColor1,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "ঢাকা- মেট্রো- গ\n২৬-৯৬৭৫",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: CustomColor.TextColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          // Flexible Image Section
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/img/car.png',
                                fit: BoxFit.cover,
                                width: 300.0,
                                height: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
