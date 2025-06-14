
import 'package:flutter/material.dart';

class HomeScreenContent extends StatelessWidget {
  final String? selectedVehicle;
  final List<String> availableVehicles;
  final ValueChanged<String?> onVehicleChanged;
  final VoidCallback onShiftToggle;
  final bool shiftStarted;

  const HomeScreenContent({
    super.key,
    required this.selectedVehicle,
    required this.availableVehicles,
    required this.onVehicleChanged,
    required this.onShiftToggle,
    required this.shiftStarted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome, Driver!',
            style: theme.textTheme.headlineLarge!.copyWith(color: theme.colorScheme.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Select your active vehicle to start your shift.',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedVehicle,
                hint: Text(
                  'Select a Vehicle',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                iconSize: 30,
                elevation: 16,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                onChanged: onVehicleChanged,
                items: availableVehicles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: selectedVehicle == null ? null : onShiftToggle,
            icon: Icon(shiftStarted ? Icons.stop : Icons.play_arrow),
            label: Text(shiftStarted ? 'End Shift' : 'Start Shift'),
            style: ElevatedButton.styleFrom(
              backgroundColor: shiftStarted ? Colors.red : null,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            selectedVehicle != null
                ? 'Current Vehicle: $selectedVehicle'
                : 'Please select your vehicle to begin.',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}