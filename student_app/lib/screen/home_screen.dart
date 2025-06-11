import 'package:flutter/material.dart';
import 'package:diu_transport_student_app/barikoi_map.dart'; // Import the map widget
import 'package:diu_transport_student_app/socketio.dart';
import 'package:diu_transport_student_app/screen/add_reservation_screen.dart'; // Import the ReservationScreen
import 'package:diu_transport_student_app/screen/profile.dart'; // Import the ProfileScreen
import 'package:diu_transport_student_app/screen/reservation_history.dart'; // Import the ReservationHistory screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // State to manage the currently selected tab

  var socket = socketio(); // Initialize your socket connection
  // Define a list of your content widgets corresponding to each tab
  late final List<Widget> _widgetOptions = <Widget>[
    SymbolMap(socket: socket), // Show the map in the Home tab
    ReservationHistory(), // Add ReservationHistory to the widget options
    ProfileScreen(), // Add ProfileScreen to the widget options
    // Add more content widgets here for additional tabs
  ];

  // Function to handle tab taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Access your theme

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Dynamically change app bar title based on selected tab
          _selectedIndex == 0 ? 'Home' :
          _selectedIndex == 1 ? 'History' :
          _selectedIndex == 2 ? 'Profile' : 'Other',
          style: theme.appBarTheme.titleTextStyle, // Use theme's title style
        ),
        centerTitle: theme.appBarTheme.centerTitle, // Use theme's centerTitle property
        backgroundColor: theme.appBarTheme.backgroundColor, // Use theme's background color
        foregroundColor: theme.appBarTheme.foregroundColor, // Use theme's foreground color for title/icons
        elevation: theme.appBarTheme.elevation, // Use theme's elevation
      ),
      body: IndexedStack(
        index: _selectedIndex, // Displays the widget at the current index
        children: _widgetOptions, // The list of all possible content widgets
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ReservationScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        // THE BOTTOM NAVIGATION BAR STYLE IS ALREADY APPLIED VIA `transitTheme`
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History', // Add History tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Link to the current selected index state
        onTap: _onItemTapped, // Call our state-updating function
      ),
    );
  }
}