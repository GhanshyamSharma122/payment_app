import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

const String baseUrl = "https://backendpayment.onrender.com";

Future<Map<String, dynamic>> registerUser(Map<String, dynamic> user) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['user'];
  } else {
    throw Exception('Failed to register user: ${response.statusCode}');
  }
}

Future<String> loginUser(String identifier, String password) async {
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
    "timestamp": DateTime.now().toUtc().toIso8601String() + "Z",
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
  final timestamp = DateTime.now().toUtc().toIso8601String() + "Z";
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