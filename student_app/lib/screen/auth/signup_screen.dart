import 'package:flutter/material.dart';
import 'package:diu_transport_student_app/theme/transit_theme.dart';
import 'package:diu_transport_student_app/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),

            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(Icons.person_add, size: 60, color: theme.colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Create Your Account',
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join DIU Transport for seamless rides',
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
              label: 'Full Name',
              icon: Icons.person,
              controller: nameController,
              hintText: 'Your full name',
            ),
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
              hintText: 'Create a strong password',
            ),
            CustomTextField(
              label: 'Confirm Password',
              icon: Icons.lock_reset,
              isPassword: true,
              controller: confirmPasswordController,
              hintText: 'Re-enter your password',
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign-up logic
                  print('Sign Up Attempt for ${emailController.text}');
                },
                child: Text(
                  'Sign Up',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context), // Go back to login
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
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