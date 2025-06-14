import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../theme/driver_transit_theme.dart';
import '../../widget/custom_text_field.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Ensure token check runs on screen load
    _checkToken();
  }

  @override
  void dispose() {
    _animationController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final data = json.decode(userData);
      if (data['token'] != null) {
        Navigator.pushReplacementNamed(context, '/driver-home-screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the driverTransitTheme directly
    final ThemeData theme =
        driverTransitTheme; // Use the dedicated driver theme

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Use background from driver theme
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.directions_bus_filled,
                        size: 70,
                        color: theme.colorScheme.onPrimary,
                      ), // Changed icon
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'DIU Transport Driver App', // Changed title
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to manage your routes and passengers', // Changed subtitle
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            CustomTextField(
              label: 'Phone Number', // Changed label
              icon: Icons.phone,
              controller: phoneNumberController,
              hintText: '01XXXXXXXXX',
            ),
            CustomTextField(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
              controller: passwordController,
              hintText: 'Enter your password',
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Forgot Password'),
                        content: RichText(
                          text: TextSpan(
                            text: 'Please visit office for new password.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final phoneNumber = phoneNumberController.text.trim();
                  final password = passwordController.text.trim();

                  if (phoneNumber.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  if (phoneNumber.length != 11 || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid phone number format')),
                    );
                    return;
                  }

                  try {
                    final socketUrl = dotenv.env['SERVER_URL'] ?? '';
                    if (socketUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Server URL not configured')),
                      );
                      return;
                    }

                    final response = await http.post(
                      Uri.parse('$socketUrl/api/v1/driver/login'),
                      body: {'phoneNumber': phoneNumber, 'password': password},
                    );

                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);

                      if (responseData['success'] == true && responseData['data'] != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userData', json.encode(responseData['data'])); // Store user data
                        Navigator.pushReplacementNamed(context, '/driver-home-screen'); // Use pushReplacement to prevent back navigation
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid response from server')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid email or password')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error connecting to server')),
                    );
                    if (kDebugMode) {
                      print('Error during login: $e');
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Driver Registration'),
                          content: RichText(
                            text: TextSpan(
                              text:
                              'Please visit office for registration.',
                              style:
                              Theme.of(
                                context,
                              ).textTheme.bodyMedium,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    ),
                child: Text(
                  'New Driver?',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
