import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool showErrorMessage;

  const Loader({super.key, this.showErrorMessage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      child: const Center(
        child: CircularProgressIndicator(), // Loading spinner
      ),
    );
  }
}
