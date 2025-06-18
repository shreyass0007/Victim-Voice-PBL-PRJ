import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _handlePermissions();
      await _initializeNotifications();
      _setupConnectivity();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error in initialization: $e');
    }
  }

  Future<void> _handlePermissions() async {
    try {
      await Future.wait([
        _requestPermissions(),
        _requestNotificationPermissions(),
      ]);
    } catch (e) {
      debugPrint('Error in _handlePermissions: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      await Permission.location.request();
      await Permission.camera.request();
      await Permission.microphone.request();
      await Permission.storage.request();
    } catch (e) {
      debugPrint('Error in _requestPermissions: $e');
    }
  }

  Future<void> _requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        debugPrint('Notification permission status: $status');
      }
    } catch (e) {
      debugPrint('Error in _requestNotificationPermissions: $e');
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification response received: ${response.payload}');
        },
      );
    } catch (e) {
      debugPrint('Error in _initializeNotifications: $e');
    }
  }

  void _setupConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      debugPrint('Connectivity changed: $result');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.blue[300]! : Colors.blue[700]!,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      appBar: AppBar(
        title: Text(
          'Student Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isDark ? Colors.white : Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: isDark ? Colors.blue[900] : Colors.blue[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Colors.blue[900]!.withOpacity(0.2),
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    Colors.blue[50]!,
                    Colors.white,
                  ],
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to Student Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.blue[900],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifications.cancelAll();
    super.dispose();
  }
}
