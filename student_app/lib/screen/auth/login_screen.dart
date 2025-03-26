import 'package:flutter/material.dart';
import '../../const/color_palet.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Center(child: Image.asset('assets/image/img.png', height: 150)),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'DIU Transport Student App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(label: 'Email', icon: Icons.email, controller: emailController),
                CustomTextField(label: 'Password', icon: Icons.lock, isPassword: true, controller: passwordController),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                    child: Text('Forgot Password?', style: TextStyle(color: AppColors.secondary)),
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBg, // Set the background color here
                    ),
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),

                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text('Don\'t have an account? Sign Up', style: TextStyle(color: AppColors.secondary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
