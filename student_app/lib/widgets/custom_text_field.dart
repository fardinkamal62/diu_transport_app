import 'package:flutter/material.dart';
import '../const/color_palet.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  CustomTextField({
    required this.label,
    required this.icon,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textColor),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.secondary),
            filled: true,
            fillColor: AppColors.inputFieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.inputFieldBorder),
            ),
            hintText: "Enter your $label",
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          style: TextStyle(color: AppColors.textColor),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
