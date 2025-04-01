import 'package:flutter/material.dart';
import '../../const/color_palet.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: AppColors.primary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Center(child: Image.asset('assets/img/bus_booking.png', height: 150)),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(label: 'Full Name', icon: Icons.person, controller: nameController),
                CustomTextField(label: 'Student ID', icon: Icons.badge_rounded, controller: studentIDController),
                CustomTextField(label: 'Email', icon: Icons.email, controller: emailController),
                CustomTextField(label: 'Password', icon: Icons.lock, isPassword: true, controller: passwordController),

                Row(
                  children: [
                    Checkbox(
                      value: isAccepted,
                      onChanged: (value) {
                        setState(() => isAccepted = value!);
                      },
                      activeColor: AppColors.secondary,
                    ),
                    Expanded(
                      child: Text('I accept the Privacy Policy & Terms'),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isAccepted ? () {} : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBg),
                    child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Already have an account? Login', style: TextStyle(color: AppColors.secondary)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
