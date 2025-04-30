// lib/app.dart
import 'package:flutter/material.dart';
import 'package:payment_app/common/theme/theme.dart'; 
import 'package:payment_app/presentation/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gen Z Payment App',
      theme: AppTheme.lightTheme, // Use the light theme we defined
      home: const LoginScreen(), // Set the initial screen to the LoginScreen
      // You can define routes for navigation here later
      // routes: {
      //   '/home': (context) => HomeScreen(),
      // },
    );
  }
}