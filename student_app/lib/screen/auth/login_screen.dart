import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:diu_transport_student_app/widgets/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this import is present
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv for environment variables
import 'package:http/http.dart' as http; // Import http for API calls
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:convert'; // Import for JSON parsing

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Animation for the logo/title
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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate( // Slight slide up
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward(); // Start the animation when the screen loads
    _checkToken(); // Check if the user is already logged in
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final data = json.decode(userData);
      if (data['token'] != null) {
        Navigator.pushReplacementNamed(context, '/home-screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: diuBackgroundColor,
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
                      child: Icon(Icons.directions_bus, size: 70, color: theme.colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'DIU Transport Student App',
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to access your transport services',
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
              label: 'Email',
              icon: Icons.email,
              controller: emailController,
              hintText: 'e.g., student@diu.edu.bd',
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
                            text: 'Please visit ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'students.diu.ac',
                                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url = Uri.parse('https://students.diu.ac');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Could not open the link')),
                                      );
                                    }
                                  },
                              ),
                              TextSpan(text: ' to reset your password.'),
                            ],
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
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid email format')),
                    );
                    return;
                  }

                  try {
                    final socketUrl = dotenv.env['SOCKET_URL'] ?? '';
                    if (socketUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Server URL not configured')),
                      );
                      return;
                    }

                    final response = await http.post(
                      Uri.parse('$socketUrl/api/v1/user/login'),
                      body: {'email': email, 'password': password},
                    );

                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);

                      if (responseData['success'] == true && responseData['data'] != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userData', json.encode(responseData['data'])); // Store user data
                        Navigator.pushReplacementNamed(context, '/home-screen'); // Use pushReplacement to prevent back navigation
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
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sign Up'),
                                content: RichText(
                                  text: TextSpan(
                                    text: 'Please visit ',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      TextSpan(
                                        text: 'students.diu.ac',
                                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://students.diu.ac');
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url, mode: LaunchMode.externalApplication);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Could not open the link')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(text: ' to create an account.'),
                                    ],
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}