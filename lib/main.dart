import 'package:flutter/material.dart';
import 'package:payment_app/services/api_service.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:convert'; // Import the dart:convert library

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Service Tests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  String testOutput = "Running tests...";

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    try {
      // Test User Data 1
      final user1 = {
        "username": "test_user_updated_1",
        "email": "test1_updated@example.com",
        "phone_number": "5544332211",
        "password": "new_pass123",
        "first_name": "UpdatedTest",
        "last_name": "One",
        "date_of_birth": "1996-06-06"
      };

      // Test User Data 2
      final user2 = {
        "username": "another_user_updated",
        "email": "another_updated@example.com",
        "phone_number": "0099887766",
        "password": "new_secure456",
        "first_name": "AnotherUpdated",
        "last_name": "User",
        "date_of_birth": "1999-11-11"
      };

      log("\n--- Registration Test ---");
      final sender = await registerUser(user1);
      log("Sender Registered: ${jsonEncode(sender)}");
      final receiver = await registerUser(user2);
      log("Receiver Registered: ${jsonEncode(receiver)}");

      log("\n--- Login Test ---");
      final token = await loginUser(user1["username"]!, user1["password"]!);
      log("Login Successful. Token: $token");

      log("\n--- Online Payment Test ---");
      const onlineAmount = 120.75;
      final onlineResponse = await initiateOnlinePayment(
          token, sender['id']!, receiver['id']!, onlineAmount);
      log("Online Payment Response: ${jsonEncode(onlineResponse)}");

      log("\n--- Offline Sync Test ---");
      const offlineAmount = 35.50;
      final offlineResponse = await syncOfflineTransaction(
          token, sender['id']!, receiver['username']!, offlineAmount);
      log("Offline Sync Response: ${jsonEncode(offlineResponse)}");

      log("\n--- Fetch Transactions Test ---");
      final transactions = await fetchAllTransactions(token);
      log("Transaction History: ${jsonEncode(transactions)}");

      setState(() {
        testOutput = "Tests completed. Check the console for output.";
      });
    } catch (e) {
      setState(() {
        testOutput = "An error occurred: $e";
      });
      log("Error during tests: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Service Tests'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            testOutput,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}