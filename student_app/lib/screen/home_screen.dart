// lib/screens/home_screen.dart
import 'package:diu_transport_student_app/screen/settings_content.dart';
import 'package:flutter/material.dart';

import 'home_content.dart'; // Import the settings content
// You might also want to import the custom_text_field.dart if you're using it here for other purposes
// import 'package:diu_transport_student_app/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // State to manage the currently selected tab

  // Define a list of your content widgets corresponding to each tab
  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),     // Index 0
    SettingsContent(), // Index 1
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
          _selectedIndex == 0 ? 'Home' : 'Settings',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the button - maybe context-sensitive based on current tab?
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Floating Action Button Tapped!',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
        },
        // FLOATING ACTION BUTTON STYLE IS ALREADY APPLIED VIA `transitTheme`
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // THE BOTTOM NAVIGATION BAR STYLE IS ALREADY APPLIED VIA `transitTheme`
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // Add more BottomNavigationBarItems here if you add more content widgets
        ],
        currentIndex: _selectedIndex, // Link to the current selected index state
        onTap: _onItemTapped, // Call our state-updating function
      ),
    );
  }
}