import 'package:flutter/material.dart';
import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:diu_transport_student_app/widgets/custom_text_field.dart';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
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
                onPressed: () {
                  // Implement login logic here
                  print('Login Attempt for ${emailController.text}');
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
                onPressed: () => Navigator.pushNamed(context, '/signup'),
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
                      ),
                    ],
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