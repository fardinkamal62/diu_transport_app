import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleReporting extends StatefulWidget {
  const VehicleReporting({super.key});

  @override
  State<VehicleReporting> createState() => _VehicleReportingState();
}

class _VehicleReportingState extends State<VehicleReporting> {
  String damage = 'none';
  int refueling = 0;
  String servicing = 'none';
  String tyreCondition = 'good';
  String lights = 'working';
  String fuelLevel = 'full';
  String interiorClean = 'clean';
  String? remarks;
  String? odometerReading;
  File? photo;

  bool isSubmitting = false;
  String? vehicleId;
  String? driverId;
  bool reportSubmittedForToday = false;

  final List<String> damageOptions = ['major', 'minor', 'scratch', 'none'];
  final List<int> refuelingOptions = [0, 1, 2, 3];
  final List<String> servicingOptions = ['interior service', 'tire pump', 'cleaning', 'none'];
  final List<String> tyreOptions = ['good', 'worn out', 'flat', 'damaged'];
  final List<String> lightOptions = ['working', 'broken', 'dim', 'not checked'];
  final List<String> fuelOptions = ['empty', 'half', 'three-quarter', 'full'];
  final List<String> cleanOptions = ['clean', 'average', 'dirty'];

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);

    try {
      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      final data = json.decode(userData!);

      vehicleId = prefs.getString('vehicleId');
      driverId = data['driverDetails']['_id'];

      final uri = Uri.parse('$socketUrl/api/v1/driver/report');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = data['token'];
      request.fields.addAll({
        'damage': damage,
        'refueling': refueling.toString(),
        'servicing': servicing,
        'tyreCondition': tyreCondition,
        'lights': lights,
        'fuelLevel': fuelLevel,
        'interiorClean': interiorClean,
        'remarks': remarks ?? '',
        'odometerReading': odometerReading ?? '',
        'vehicleId': vehicleId ?? '',
        'driverId': driverId ?? '',
      });

      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photo!.path));
      }

      final response = await request.send();
      final responseData = json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200 && responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('✅ Vehicle inspection submitted successfully!'),
              backgroundColor: Colors.green),
        );
        setState(() => reportSubmittedForToday = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ Failed: ${responseData['message']}'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => photo = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Vehicle Inspection"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: reportSubmittedForToday
            ? _submittedView()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _headerCard(),
                const SizedBox(height: 20),
                _buildSectionCard("Damage", Icons.car_crash, damageOptions, damage,
                        (val) => damage = val!),
                _buildSectionCard("Refueling", Icons.local_gas_station, refuelingOptions,
                    refueling, (val) => refueling = val!),
                _buildSectionCard("Servicing", Icons.build_circle_rounded, servicingOptions,
                    servicing, (val) => servicing = val!),
                _buildSectionCard("Tyre Condition", Icons.tire_repair, tyreOptions,
                    tyreCondition, (val) => tyreCondition = val!),
                _buildSectionCard("Lights & Indicators", Icons.lightbulb, lightOptions,
                    lights, (val) => lights = val!),
                _buildSectionCard("Fuel Level", Icons.battery_charging_full, fuelOptions,
                    fuelLevel, (val) => fuelLevel = val!),
                _buildSectionCard("Interior Cleanliness", Icons.cleaning_services, cleanOptions,
                    interiorClean, (val) => interiorClean = val!),
                const SizedBox(height: 20),
                _inputCard("Odometer Reading (km)", Icons.speed, TextInputType.number,
                        (val) => odometerReading = val),
                _inputCard(
                    "Remarks / Notes", Icons.note_alt_outlined, TextInputType.text,
                        (val) => remarks = val),
                const SizedBox(height: 20),
                _photoCard(),
                const SizedBox(height: 30),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: const [
        Icon(Icons.car_repair, color: Colors.blueAccent, size: 50),
        SizedBox(height: 10),
        Text("Daily Vehicle Inspection Report",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(
          "Ensure your vehicle is road-ready and safe to drive.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _buildSectionCard<T>(
      String title, IconData icon, List<T> options, T groupValue, Function(T?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blueAccent),
        collapsedIconColor: Colors.blueAccent,
        iconColor: Colors.blueAccent,
        title: Text(title,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 15)),
        children: options.map((option) {
          return RadioListTile<T>(
            activeColor: Colors.blueAccent,
            title: Text(
              option.toString(),
              style: const TextStyle(color: Colors.black54),
            ),
            value: option,
            groupValue: groupValue,
            onChanged: (val) => setState(() => onChanged(val)),
          );
        }).toList(),
      ),
    );
  }

  Widget _inputCard(String hint, IconData icon, TextInputType type, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: TextFormField(
        keyboardType: type,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _photoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
      ],
    ),
    child: Column(
      children: [
        const Text("Upload Vehicle Photo",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 10),
        if (photo != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(photo!, height: 120, fit: BoxFit.cover),
          ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.camera_alt, color: Colors.blueAccent),
          label: const Text("Capture Photo", style: TextStyle(color: Colors.blueAccent)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blueAccent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _pickImage,
        ),
      ],
    ),
  );

  Widget _submitButton() => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 20, spreadRadius: 2),
      ],
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: isSubmitting ? null : _submitReport,
      icon: isSubmitting
          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white))
          : const Icon(Icons.send_rounded, color: Colors.white),
      label: Text(
        isSubmitting ? "Submitting..." : "Submit Inspection",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  );

  Widget _submittedView() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified, color: Colors.green, size: 80),
        SizedBox(height: 16),
        Text(
          "Report Submitted for Today ✅",
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
