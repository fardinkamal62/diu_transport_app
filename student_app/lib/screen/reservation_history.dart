import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'reservation_details.dart'; // Import the ReservationDetails page

class ReservationHistory extends StatefulWidget {
  const ReservationHistory({super.key});

  @override
  State<ReservationHistory> createState() => _ReservationHistoryState();
}

class _ReservationHistoryState extends State<ReservationHistory> {
  bool isLoading = true;
  List<dynamic> reservations = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>(); // Add a key for RefreshIndicator

  @override
  void initState() {
    super.initState();
    _fetchReservationHistory();
  }

  Future<void> _fetchReservationHistory() async {
    try {
      final socketUrl = dotenv.env['SERVER_URL'] ?? '';
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');

      if (userData != null) {
        final data = json.decode(userData);

        final response = await http.get(
          Uri.parse('$socketUrl/api/v1/user/reservation?registrationCode=${data['user']['reg_code']}'),
          headers: {'Authorization': '${data['token']}'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            reservations = responseData['data']['reservations'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch reservation history.'), backgroundColor: Colors.red),
          );
          if (kDebugMode) {
            print('Error: ${response.statusCode} - ${response.body}');
          }
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey, // Assign the key
              onRefresh: _fetchReservationHistory, // Ensure pull-to-refresh calls the method
              child: reservations.isEmpty
                  ? ListView( // Ensure RefreshIndicator wraps a scrollable widget
                      children: const [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 200), // Center vertically
                            child: Text(
                              "No reservations found.",
                              style: TextStyle(fontSize: 16), // Optional: Adjust font size
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        final reservationDate = DateTime.parse(reservation['time']);
                        final formattedTime = DateFormat('MMMM dd, yyyy hh:mm a').format(reservationDate);
                        final isToday = DateFormat('yyyy-MM-dd').format(reservationDate) ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        final isScheduled = reservation['status'].toLowerCase() == 'scheduled';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: isToday ? Colors.green.shade100 : Colors.white, // Highlight condition
                          child: ListTile(
                            title: Text(
                              "Location: ${reservation['location'][0].toUpperCase()}${reservation['location'].substring(1)}",
                            ),
                            subtitle: Text(
                              "Time: $formattedTime\nStatus: ${reservation['status'][0].toUpperCase()}${reservation['status'].substring(1)}",
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ReservationDetails(reservation: reservation),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
