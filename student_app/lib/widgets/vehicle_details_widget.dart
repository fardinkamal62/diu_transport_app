// lib/widgets/vehicle_details_widget.dart

import 'package:flutter/material.dart';
import '../theme/transit_theme.dart'; // Ensure this path is correct

class VehicleDetailsWidget extends StatefulWidget {
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleCapacity;
  final String vehicleImage;

  const VehicleDetailsWidget({
    super.key,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    required this.vehicleImage,
  });

  @override
  State<VehicleDetailsWidget> createState() => _VehicleDetailsWidgetState();
}

class _VehicleDetailsWidgetState extends State<VehicleDetailsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Quick animation for tap feedback
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Access the entire theme
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector( // Added GestureDetector for tap animation
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        // Implement what happens when the card is tapped (e.g., navigate to detail screen)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.vehicleName} tapped!'),
            backgroundColor: theme.colorScheme.primary,
            duration: const Duration(milliseconds: 800),
          ),
        );
      },
      child: ScaleTransition( // Apply scale animation on tap
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Consistent padding
          // Use theme's CardTheme for base styling, then override specifics
          decoration: BoxDecoration(
            color: theme.colorScheme.surface, // Use surface color from theme
            borderRadius: BorderRadius.circular(16.0), // More rounded corners
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.2), // Softer shadow from theme
                blurRadius: 15, // Increased blur for softer look
                spreadRadius: 2,
                offset: const Offset(0, 8), // More vertical offset
              ),
            ],
          ),
          child: IntrinsicHeight( // Ensure row children take up necessary height
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill height
              children: [
                // Vehicle Image Section - Left Side
                Container(
                  width: 120, // Fixed width for the image container
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    // Optional: Add a subtle gradient behind the image
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer.withOpacity(0.6),
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // Rounded image corners
                    child: Image.asset(
                      widget.vehicleImage,
                      fit: BoxFit.cover,
                      // You might want to add a placeholder or error builder
                      // errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  ),
                ),

                // Flexible Text Section - Right Side
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vehicleName,
                          style: textTheme.headlineSmall!.copyWith( // Prominent name with headlineSmall
                            color: theme.colorScheme.primary, // Primary color for name
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Vehicle No: ${widget.vehicleNumber}',
                          style: textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: diuLightGreen,// Lighter, themed background
                            borderRadius: BorderRadius.circular(20.0), // Pill shape for capacity
                          ),
                          child: Text(
                            'Capacity: ${widget.vehicleCapacity}',
                            style: textTheme.labelMedium!.copyWith( // Use labelMedium
                              color: diuOnPrimaryColor, // Text on surface color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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