import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification service
  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Get the device timezone
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request permission for notifications (especially for Android 13+)
    await _requestPermissions();
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Request notification permission
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
        
    // Request exact alarm permission for Android 12+
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  /// Check and request Samsung-specific alarm permissions
  Future<void> requestSamsungAlarmPermissions(BuildContext context) async {
    if (!Platform.isAndroid) return;
    
    // Check if we're on a Samsung device
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final isSamsung = androidInfo.manufacturer?.toLowerCase().contains('samsung') ?? false;
    
    if (isSamsung) {
      try {
        // Try scheduling a test notification to see if we have permission
        final testTime = DateTime.now().add(const Duration(days: 1));
        await scheduleTransportNotification(
          location: 'Test',
          time: '00:00',
          scheduledTime: testTime,
          message: 'Permission test notification',
          notificationId: 999999,
        );
        
        // If we get here, permission is granted
        if (kDebugMode) {
          print('Samsung alarm permissions appear to be granted');
        }
      } catch (e) {
        if (e.toString().contains('exact_alarms_not_permitted')) {
          // Show dialog to guide user to settings
          if (context.mounted) {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Permission Required'),
                content: const Text(
                  'This app needs "Alarms and Reminders" permission to send you timely notifications about your transport.\n\n'
                  'Please enable this in your device settings > Apps > DIU Transport > Permissions > Alarms and reminders.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else if (kDebugMode) {
          print('Error checking Samsung permissions: $e');
        }
      }
    }
  }

  /// Handle notification response when user taps on it
  static void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    // Handle the notification tap
    debugPrint('Notification tapped: ${notificationResponse.payload}');
    // You can navigate to specific screens based on the payload
  }

  /// Schedule a notification for transport reservation
  Future<void> scheduleTransportNotification({
    required String location,
    required String time,
    required DateTime scheduledTime,
    required String message,
    int? notificationId,
  }) async {
    // Generate unique notification ID if not provided
    notificationId ??= DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Configure notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'transport_channel',
          'Transport Notifications',
          channelDescription: 'Notifications for transport reservations',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Transport Reminder',
      message,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload:
          '$location|$time|${DateFormat('yyyy-MM-dd HH:mm').format(scheduledTime)}',
    );
  }

  /// Schedule multiple notifications for a transport reservation
  Future<void> scheduleReservationNotifications({
    required String location,
    required String timeSlot,
    required DateTime reservationDateTime,
  }) async {
    final DateTime now = DateTime.now();

    // Only schedule if the time is in the future
    if (reservationDateTime.isAfter(now)) {
      try {
        await scheduleTransportNotification(
          location: location,
          time: timeSlot,
          scheduledTime: reservationDateTime,
          message: 'Transport reminder for $location at $timeSlot',
          notificationId: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        );
      } catch (e) {
        // If exact alarms are not permitted, try using an immediate notification instead
        if (e.toString().contains('exact_alarms_not_permitted')) {
          await showImmediateNotification(
            title: 'Transport Reminder',
            body: 'Transport reminder for $location at $timeSlot',
            payload: '$location|$timeSlot',
          );
        } else {
          rethrow; // Re-throw other exceptions
        }
      }
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Show an immediate notification
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'transport_channel',
          'Transport Notifications',
          channelDescription: 'Notifications for transport reservations',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
