import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

const String baseUrl = "https://backendpayment.onrender.com";

Future<Map<String, dynamic>> registerUser(Map<String, dynamic> user) async {
  print('Attempting to register user with data: ${jsonEncode(user)}');
  
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user),
  );

  print('Registration response status: ${response.statusCode}');
  print('Registration response body: ${response.body}');

  final responseBody = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return responseBody['user'];
  } else {
    final errorMessage = responseBody['message'] ?? responseBody['error'] ?? 'Unknown error';
    throw Exception('Failed to register user: $errorMessage');
  }
}

Future<String> loginUser(String identifier, String password) async {
  // For testing purposes
  if (identifier == "testuser" && password == "password123") {
    return "test_token";
  }

  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'identifier': identifier,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['token'];
  } else {
    throw Exception('Failed to login: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> initiateOnlinePayment(
    String token, String senderId, String recipientId, double amount) async {
  final payload = {
    "sender_id": senderId,
    "recipient_id": recipientId,
    "amount": amount,
    "currency": "INR",
    "description": "Flutter Test Online Payment",
    "transaction_type": "TEST",
    "timestamp": "${DateTime.now().toUtc().toIso8601String()}Z",
  };

  final response = await http.post(
    Uri.parse('$baseUrl/api/payment/initiate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to initiate online payment: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> syncOfflineTransaction(
    String token, String userId, String recipientIdentifier, double amount) async {
  const uuid = Uuid();
  final localTxId = uuid.v4();
  final timestamp = "${DateTime.now().toUtc().toIso8601String()}Z";
  final sigStr = '$userId|$recipientIdentifier|$amount|INR|$timestamp';
  final encryptedData = sha256.convert(utf8.encode(sigStr)).toString();

  final record = {
    "local_transaction_id": localTxId,
    "recipient_identifier": recipientIdentifier,
    "amount": amount,
    "currency": "INR",
    "timestamp": timestamp,
    "encrypted_data": encryptedData,
  };

  final payload = {
    "user_id": userId,
    "device_id": uuid.v4(),
    "transactions": [record],
  };

  final response = await http.post(
    Uri.parse('$baseUrl/api/offline/sync'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to sync offline transaction: ${response.statusCode}');
  }
}

Future<List<dynamic>> fetchAllTransactions(String token) async {
  // For demo/testing: return mock data instead of making an actual API call
  // This ensures the transaction history screen works properly during development
  if (token == "test_token") {
    // Adding a small delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return mock transaction data
    return [
      {
        'id': '1',
        'amount': 2500.00,
        'type': 'incoming',
        'sender': 'Company ABC',
        'receiver': 'testuser',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'status': 'completed'
      },
      {
        'id': '2',
        'amount': 85.00,
        'type': 'outgoing',
        'sender': 'testuser',
        'receiver': 'Shopping Mart',
        'date': DateTime.now().toIso8601String(),
        'status': 'completed'
      },
      {
        'id': '3',
        'amount': 750.00,
        'type': 'outgoing',
        'sender': 'testuser',
        'receiver': 'Rent Payment',
        'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'status': 'completed'
      },
      {
        'id': '4',
        'amount': 120.50,
        'type': 'incoming',
        'sender': 'Jane D',
        'receiver': 'testuser',
        'date': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'status': 'completed'
      },
      {
        'id': '5',
        'amount': 45.75,
        'type': 'outgoing',
        'sender': 'testuser',
        'receiver': 'Grocery Store',
        'date': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'status': 'completed'
      }
    ];
  }

  // If not using test token, try the actual API
  final response = await http.get(
    Uri.parse('$baseUrl/api/transactions'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch transactions: ${response.statusCode}');
  }
}